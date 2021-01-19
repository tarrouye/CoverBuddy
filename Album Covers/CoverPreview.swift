//
//  CoverPreview.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import SwiftUI

struct CoverPreview: View {
    var cover : ObservedObject<Cover>?
    @State var withProperties : CoverProperties?
    
    @State private var coverImage : UIImage?
    @State private var backgroundImage : UIImage?
    
    var coverWidthPercentage : CGFloat = 1.0
    
    func coverSize(_ geo : GeometryProxy) -> CGFloat {
        return min(geo.size.width, geo.size.height) * self.coverWidthPercentage
    }
    
    func scaleAgainstWidth(_ num : CGFloat, _ geo : GeometryProxy) -> CGFloat {
        return num * (coverSize(geo) / 1500)
    }
    
    func topFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return UIFont(name: withProperties!.topFontName, size: scaleAgainstWidth(withProperties!.topFontSize, geo))!.lineHeight
    }
    
    func botFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return UIFont(name: withProperties!.botFontName, size: scaleAgainstWidth(withProperties!.botFontSize, geo))!.lineHeight
    }
    
    func textAlignToFrameAlign(_ align : NSTextAlignment) -> Alignment {
        if (align == .left) {
            return .leading
        } else if (align == .right) {
            return .trailing
        }
        
        return .center
    }

    func initialSetup() {
        if (cover != nil && !cover!.wrappedValue.isFault) {
            withProperties = PropertiesFromCover(cover!.wrappedValue)
        }
        
        // start loading image colors if not already when preview is displayed so that they are ready
        // for edit view
        loadImageColors()
    }
    
    func loadImageColors() {
        // check cache first
        if ImageColorCache.shared.get(forKey: withProperties!.backgroundImgURL) == nil {
            UIImage(named: withProperties!.backgroundImgURL)?.getColors { wrapped in
                if let colors = wrapped {
                    ImageColorCache.shared.set(colors, forKey: withProperties!.backgroundImgURL)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .onAppear() {
                    initialSetup()
                }
            
            
        
            if (withProperties != nil) {
                GeometryReader { geometry in
                    ZStack {
                        // background image
                        Image(withProperties!.backgroundImgURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: coverSize(geometry), height: coverSize(geometry), alignment: .center)
                            
                        
                        // text boxes
                        ZStack {
                            
                            HStack(spacing: 0) {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: scaleAgainstWidth(withProperties!.topLeftSidePadding, geometry))
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: scaleAgainstWidth(withProperties!.topPos, geometry))
                                    
                                    Text(withProperties!.topText)
                                        .font(Font(UIFont(name: withProperties!.topFontName, size: scaleAgainstWidth(withProperties!.topFontSize, geometry))!))
                                        .fixedSize()
                                        .foregroundColor(Color(withProperties!.topFontColor))
                                        .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.topRightSidePadding + withProperties!.topLeftSidePadding, geometry), height: topFontHeight(geometry), alignment: textAlignToFrameAlign(withProperties!.topTextAlignment))
                                    
                                    Spacer()
                                        .frame(height: scaleAgainstWidth(1500 - withProperties!.topPos, geometry))
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: scaleAgainstWidth(withProperties!.topRightSidePadding, geometry))
                            }
                            .frame(width: coverSize(geometry))
                        
                        
                        
                            HStack(spacing: 0) {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: scaleAgainstWidth(withProperties!.botLeftSidePadding, geometry))
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: scaleAgainstWidth(withProperties!.botPos, geometry))
                                    
                                    Text(withProperties!.botText)
                                        .multilineTextAlignment((withProperties!.botTextAlignment == .left) ? .leading : ((withProperties!.botTextAlignment == .right) ? .trailing : .center))
                                        .fixedSize()
                                        .font(Font(UIFont(name: withProperties!.botFontName, size: scaleAgainstWidth(withProperties!.botFontSize, geometry))!))
                                        .foregroundColor(Color(withProperties!.botFontColor))
                                        .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.botRightSidePadding + withProperties!.botLeftSidePadding, geometry), height: botFontHeight(geometry), alignment: textAlignToFrameAlign(withProperties!.botTextAlignment))
                                    
                                    Spacer()
                                        .frame(height: scaleAgainstWidth(1500 - withProperties!.botPos, geometry))
                                        
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: scaleAgainstWidth(withProperties!.botRightSidePadding, geometry))
                            }
                            .frame(width: coverSize(geometry))
                            
                        }
                        .frame(width: coverSize(geometry), height: coverSize(geometry), alignment: .center)
                    }
                }
            }
        }
    }
    
}
