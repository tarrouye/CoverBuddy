//
//  CarouselView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct CarouselView<Content: View>: View {
    // number of cards we will house
    let cardCount: Int
    
    // binding to refer to currently selected / highlighted card
    @Binding var currentIndex: Int
    
    var spacingOffset : CGFloat
    var showPageDots : Bool
    
    let action : ((Int) -> Void)?
    
    let bgView : AnyView?
    
    let content: Content

    @GestureState private var translation: CGFloat = 0
    
    

    init(cardCount: Int, currentIndex: Binding<Int>, spacingOffset : CGFloat = 0, showPageDots: Bool = false, action: ((Int) -> Void)? = nil, bgView : AnyView? = nil, @ViewBuilder content: () -> Content) {
        self.cardCount = cardCount
        self._currentIndex = currentIndex
        self.spacingOffset = spacingOffset
        self.showPageDots = showPageDots
        self.action = action
        self.bgView = bgView
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: -spacingOffset) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * (geometry.size.width - spacingOffset))
            .offset(x: self.translation)
            .animation(.linear(duration: 0.125))
            .clipShape(Rectangle())
            .overlay(
                Group {
                    if (self.showPageDots) {
                        Spacer()
                        
                        HStack {
                            ForEach(0..<self.cardCount, id: \.self) { index in
                                Circle()
                                    .fill(index == self.currentIndex ? Color.white : Color.gray)
                                    .frame(width: 5, height: 5)
                            }
                        }
                        .offset(y: 10)
                    }
                }
            )
            .background(Group {
                if self.bgView != nil {
                    self.bgView
                }
            })
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    // snap to selection, limit to moving one at a time
                    let offset = max(-1.25, min(2 * value.translation.width / geometry.size.width, 1.25))
                    let newIndex = Int((CGFloat(self.currentIndex) - offset).rounded())
                    
                    let curbedIndex = min(max(newIndex, 0), self.cardCount - 1)
                    
                    if (curbedIndex != currentIndex) {
                        // Changed
                        if (self.action != nil) {
                            self.action!(curbedIndex)
                        }
                        
                        withAnimation {
                            self.currentIndex = curbedIndex
                        }
                        
                    }
                    
                    
                }
            )
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
