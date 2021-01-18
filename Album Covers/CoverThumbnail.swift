//
//  CoverThumbnail.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct CoverThumbnail : View {
    var cover : ObservedObject<Cover>
    
    var rounding: CGFloat
    
    @Binding var isSelecting : Bool
    @Binding var isSelected : Bool
    @Binding var navigationItem : UUID?
    
    @State private var backgroundImageColor : Color = .white
    @State private var primaryImageColor : Color = .blue
    @State private var secondaryImageColor : Color = .white
    @State private var detailImageColor : Color = .green
    
    func loadImageColors() {
        // check cache first
        if let cacheColors = ImageColorCache.shared.get(forKey: self.cover.wrappedValue.backgroundImgURL!) {
            self.backgroundImageColor = Color(cacheColors.background)
            self.primaryImageColor = Color(cacheColors.primary)
            self.detailImageColor = Color(cacheColors.detail)
            self.secondaryImageColor = Color(cacheColors.secondary)
        } else {
            // get image colors
            UIImage(named: self.cover.wrappedValue.backgroundImgURL!)?.getColors { wrapped in
                if let colors = wrapped {
                    self.backgroundImageColor = Color(colors.background)
                    self.primaryImageColor = Color(colors.primary)
                    self.detailImageColor = Color(colors.detail)
                    self.secondaryImageColor = Color(colors.secondary)
                    
                    ImageColorCache.shared.set(colors, forKey: self.cover.wrappedValue.backgroundImgURL!)
                }
            }
        }
    }
    
    var body : some View {
        Button(action: {
            if (isSelecting) {
                withAnimation {
                    isSelected.toggle()
                }
            } else {
                navigationItem = cover.wrappedValue.id
            }
        }) {
            CoverPreview(cover: cover)
                .overlay(
                    HStack {
                        if (!isSelected) {
                            Spacer()
                        }
                        
                        VStack {
                            if (!isSelected) {
                                Spacer()
                            }
                            
                            ZStack {
                                if (isSelecting) {
                                    
                                    backgroundImageColor.opacity(isSelected ? 0.7 : 0.0)
                                        .clipShape(RoundedRectangle(cornerRadius: isSelected ? rounding + 5: 100, style: .continuous))
                                        
                                        .overlay(
                                            
                                                RoundedRectangle(cornerRadius: isSelected ? rounding - 2: 100, style: .continuous)
                                                    .inset(by: 2.5)
                                                    .stroke(detailImageColor, lineWidth: isSelected ? 5 : 0)
                                                
                                            
                                        )
                                        .frame(maxWidth: isSelected ? .infinity : 30, maxHeight: isSelected ? .infinity : 30)
                                        .zIndex(-1)
                                    
                                    Circle()
                                        .foregroundColor(secondaryImageColor.opacity(isSelected ? 0.7 : 0.5))
                                        .overlay(
                                            Circle()
                                                .stroke(isSelected ? Color.clear : primaryImageColor, lineWidth: isSelected ? 0 : 4)
                                                .overlay(
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(primaryImageColor)
                                                        .font(.system(size: 30, weight: .semibold))
                                                        .opacity(isSelected ? 1 : 0)
                                                )
                                                
                                        )
                                    .frame(width: isSelected ? 60: 30, height: isSelected ? 60 : 30)
                                    .shadow(color: Color(UIColor.systemGray2), radius: 7)
                                    .padding()
                                    .zIndex(0)
                                }
                            }
                        }
                    }
                    
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            loadImageColors()
        }
    }
}
