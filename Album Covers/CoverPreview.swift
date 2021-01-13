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
    
    @State var topText = ""
    
    func initialSetup() {
        if (cover != nil && !cover!.wrappedValue.isFault) {
            //if (withProperties == nil) {
                withProperties = PropertiesFromCover(cover!.wrappedValue)
            //}
            
            // load images when first appear
            
            /*LoadedImageHandler.shared.loadImage(forKey: "cover-rendered-thumbnail-image-\(cover.id!.uuidString)", fallback: {
                if (cover.renderedImageData != nil) {
                    if let img = UIImage(data: cover.renderedImageData!) {
                        return convertToThumbnail(img, scaleFactor: 0.5)
                    }
                }
                
                return nil
            }) { img in
                coverImage = img
            }*/
            
            if (backgroundImage == nil) {
                loadCoverBackgroundImage(cover!.wrappedValue, colorCompletion: { wrapped in }) { img in
                    backgroundImage = img
                }
            }
        } else {
            if (withProperties != nil) {
                if (backgroundImage == nil) {
                    loadCoverBackgroundImage(withProperties!, colorCompletion: { wrapped in }) { img in
                        backgroundImage = img
                    }
                }
            }
        }
    }
    
    var body: some View {
        if (withProperties != nil && backgroundImage != nil) {
            GeometryReader { geometry in
                ZStack {
                    // background image
                    Image(uiImage: backgroundImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: coverSize(geometry), height: coverSize(geometry), alignment: .center)
                        
                    
                    // text boxes
                    ZStack {
                        
                        HStack {
                            // Simulate sidePadding
                            Spacer()
                                .frame(width: scaleAgainstWidth(withProperties!.textSidePadding, geometry))
                            
                            VStack {
                                // Use spacers to position text as it would be from parameters
                                Spacer()
                                    .frame(height: scaleAgainstWidth(withProperties!.topPos, geometry))
                                
                                Text(withProperties!.topText)
                                    .font(Font(UIFont(name: withProperties!.topFontName, size: scaleAgainstWidth(withProperties!.topFontSize, geometry))!))
                                    .foregroundColor(Color(withProperties!.topFontColor))
                                    .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.textSidePadding, geometry) * 2, height: topFontHeight(geometry), alignment: textAlignToFrameAlign(withProperties!.topTextAlignment))
                                
                                Spacer()
                                    .frame(height: scaleAgainstWidth(1500 - withProperties!.topPos, geometry))
                            }
                            
                            // Simulate sidePadding
                            Spacer()
                                .frame(width: scaleAgainstWidth(withProperties!.textSidePadding, geometry))
                        }
                    
                    
                    
                        HStack {
                            // Simulate sidePadding
                            Spacer()
                                .frame(width: scaleAgainstWidth(withProperties!.textSidePadding, geometry))
                            
                            VStack {
                                // Use spacers to position text as it would be from parameters
                                Spacer()
                                    .frame(height: scaleAgainstWidth(withProperties!.botPos, geometry))
                                
                                Text(withProperties!.botText)
                                    .multilineTextAlignment((withProperties!.botTextAlignment == .left) ? .leading : ((withProperties!.botTextAlignment == .right) ? .trailing : .center))
                                    .fixedSize()
                                    .font(Font(UIFont(name: withProperties!.botFontName, size: scaleAgainstWidth(withProperties!.botFontSize, geometry))!))
                                    .foregroundColor(Color(withProperties!.botFontColor))
                                    .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.textSidePadding, geometry) * 2, height: botFontHeight(geometry), alignment: textAlignToFrameAlign(withProperties!.botTextAlignment))
                                
                                Spacer()
                                    .frame(height: scaleAgainstWidth(1500 - withProperties!.botPos, geometry))
                                    
                            }
                            
                            // Simulate sidePadding
                            Spacer()
                                .frame(width: scaleAgainstWidth(withProperties!.textSidePadding, geometry))
                        }
                        
                    }
                    .frame(width: coverSize(geometry), height: coverSize(geometry), alignment: .center)
                }
            }
            .onAppear() {
                initialSetup()
            }
        } else {
            Color(UIColor.systemBackground)
                .onAppear() {
                    initialSetup()
                }
        }
    }
    
}
