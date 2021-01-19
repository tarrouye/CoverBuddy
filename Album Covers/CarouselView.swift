//
//  CarouselView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI
import AudioToolbox

struct CarouselView<Content: View>: View {
    // number of cards we will house
    let cardCount: Int
    
    // binding to refer to currently selected / highlighted card
    @Binding var currentIndex: Int
    
    let action : ((Int) -> Void)?
    
    let content: Content

    @GestureState private var translation: CGFloat = 0
    
    

    init(cardCount: Int, currentIndex: Binding<Int>, action: ((Int) -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.cardCount = cardCount
        self._currentIndex = currentIndex
        self.action = action
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: -80) { // -80 spacing to show edges of prev/next cards
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * (geometry.size.width - 80))
            .offset(x: self.translation)
            .animation(.linear(duration: 0.125))
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
            .clipShape(Rectangle())
            
        }
    }
}
