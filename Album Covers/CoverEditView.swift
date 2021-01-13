//
//  CoverEditView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

// TODO: Separate model and view logic better (everywhere..)
// TODO: Localize strings .. everywhere

import SwiftUI

struct MyTextField : View {
    var placeholder : String
    @Binding var text : String
   
    @Binding var alignment: NSTextAlignment
    
    var body : some View {
        HStack {
            if (alignment == .right || alignment == .center) {
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .multilineTextAlignment((alignment == .left) ? .leading : ((alignment == .right) ? .trailing : .center))
                .background(text.isEmpty ? Color.white.opacity(0.5) : Color.clear)
                //.fixedSize()
            
            if (alignment == .left || alignment == .center) {
                Spacer()
            }
        }
    }
}

struct CoverEditView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var withProperties : CoverProperties?
    var existingManagedObject : Cover?
    
    @Binding var rootIsActive : Bool
    
    var rounding : CGFloat = 20
    
    var coverWidthPercentage : CGFloat = 0.85
    
    @State var topText : String = ""
    @State var botText : String = ""
    @State var topCol : Color = .white
    @State var botCol : Color = .white
    @State private var isShowingFontPicker1 : Bool = false
    @State private var topFontName : String? = nil
    @State private var botFontName : String? = nil
    @State private var topFontDisplayName : String? = nil
    @State private var botFontDisplayName : String? = nil
    @State private var topFontSize : Int = 17
    @State private var botFontSize : Int = 17
    @State private var topTextAlignment : NSTextAlignment = .left
    @State private var botTextAlignment : NSTextAlignment = .left
    @State private var topPos : CGFloat = 150
    @State private var botPos : CGFloat = 375
    
    @State private var backgroundImg : UIImage?
    @State private var dominantImageColor : Color = Color(UIColor.systemBlue)
    @State private var buttonLabelColor : Color = .white
    
    @State private var isExporting : Bool = false
    
    
    
    func coverSize(_ geo : GeometryProxy) -> CGFloat {
        return min(geo.size.width, geo.size.height) * self.coverWidthPercentage
    }
    
    func scaleAgainstWidth(_ num : CGFloat, _ geo : GeometryProxy) -> CGFloat {
        return num * (coverSize(geo) / 1500)
    }
    
    func topFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return UIFont(name: topFontName ?? "Helvetica Bold", size: scaleAgainstWidth(CGFloat(topFontSize), geo))!.lineHeight
    }
    
    func botFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return UIFont(name: botFontName ?? "Helvetica", size: scaleAgainstWidth(CGFloat(botFontSize), geo))!.lineHeight
    }
    
    func textAlignToFrameAlign(_ align : NSTextAlignment) -> Alignment {
        if (align == .left) {
            return .leading
        } else if (align == .right) {
            return .trailing
        }
        
        return .center
    }
    
    func resetTextToInitialCoverValues() {
        topText = withProperties!.topText
        botText = withProperties!.botText
        
        topCol = Color(withProperties!.topFontColor)
        botCol = Color(withProperties!.botFontColor)
        
        topFontName = withProperties!.topFontName
        botFontName = withProperties!.botFontName
        topFontDisplayName = UIFont(name: withProperties!.topFontName, size: 17)?.familyName
        botFontDisplayName = UIFont(name: withProperties!.botFontName, size: 17)?.familyName
        
        topTextAlignment = withProperties!.topTextAlignment
        botTextAlignment = withProperties!.botTextAlignment
        
        topFontSize = Int(withProperties!.topFontSize)
        botFontSize = Int(withProperties!.botFontSize)
        
        topPos = withProperties!.topPos
        botPos = withProperties!.botPos
    }
    
    func clearAllCustomizations() {
        topText = ""
        botText = ""
        
        topCol = Color.white
        botCol = Color.white
        
        topFontName = "Helvetica Bold"
        botFontName = "Helvetica"
        topFontDisplayName = "Helvetica"
        botFontDisplayName = "Helvetica"
        
        topTextAlignment = .left
        botTextAlignment = .left
        
        topFontSize = 216
        botFontSize = 216
        
        topPos = 150
        botPos = 375
    }
    
    func initialSetup() {
        if (existingManagedObject != nil && withProperties == nil) {
            withProperties = PropertiesFromCover(existingManagedObject!)
        }
        
        resetTextToInitialCoverValues()
        
        
        loadCoverBackgroundImage(withProperties!, colorCompletion: { wrapped in
                if let colors = wrapped {
                    dominantImageColor = Color(colors.background)
                    buttonLabelColor = Color(colors.primary)
                }
            }) { img in
        
                if (img != nil) {
                    backgroundImg = img
                }
        }
        
        
        isExporting = false
    }
    
    func exportCover() {
        // prevent double clicking
        if (isExporting) {
            return
        }
        
        isExporting = true
        
        var copyOfProps = withProperties!
        copyOfProps.topText = topText
        copyOfProps.botText = botText
        copyOfProps.topFontColor = UIColor(topCol)
        copyOfProps.botFontColor = UIColor(botCol)
        copyOfProps.topFontName = topFontName!
        copyOfProps.botFontName = botFontName!
        copyOfProps.topFontSize = CGFloat(topFontSize)
        copyOfProps.botFontSize = CGFloat(botFontSize)
        copyOfProps.topTextAlignment = topTextAlignment
        copyOfProps.botTextAlignment = botTextAlignment
        copyOfProps.topPos = topPos
        copyOfProps.botPos = botPos
        
        // try to render image
        makeCoverImage(copyOfProps) { image in
            if let img = image {
                //let thumbnail = convertToThumbnail(img, scaleFactor: 0.5)!
                
                var uuidString = ""
                
                // create a new object if this was from properties
                if (existingManagedObject == nil) {
                    let newCover = CoverFromProperties(copyOfProps)
                    newCover.renderedImageData = img.pngData()
                    
                    uuidString = newCover.id!.uuidString
                } else {
                    // Modify existing object
                    existingManagedObject!.topText = copyOfProps.topText
                    existingManagedObject!.botText = copyOfProps.botText
                    existingManagedObject!.topFontColor = archiveColor(copyOfProps.topFontColor)
                    existingManagedObject!.botFontColor = archiveColor(copyOfProps.botFontColor)
                    existingManagedObject!.topFontName = copyOfProps.topFontName
                    existingManagedObject!.botFontName = copyOfProps.botFontName
                    existingManagedObject!.topFontSize = Float(copyOfProps.topFontSize)
                    existingManagedObject!.botFontSize = Float(copyOfProps.botFontSize)
                    existingManagedObject!.topTextAlignment = alignToInt(copyOfProps.topTextAlignment)
                    existingManagedObject!.botTextAlignment = alignToInt(copyOfProps.botTextAlignment)
                    existingManagedObject!.topPos = Float(copyOfProps.topPos)
                    existingManagedObject!.botPos = Float(copyOfProps.botPos)
                    
                    existingManagedObject!.dateEdited = Date()
                    
                    existingManagedObject!.renderedImageData = img.pngData()
                    
                    uuidString = existingManagedObject!.id!.uuidString
                }
                
                // store/update rendered image for other views
                //LoadedImageHandler.shared.storeImage(thumbnail, forKey: "cover-rendered-thumbnail-image-\(uuidString)")
                
                PersistenceController.shared.saveContainer()
            }
        }
        
        // dismiss this view
        rootIsActive = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.systemBackground)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                if (backgroundImg != nil && withProperties != nil) {
                    VStack(alignment: .center) {
                        // Preview
                        ZStack {
                            // background image
                            Image(uiImage: backgroundImg!)
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
                                            .frame(height: scaleAgainstWidth(topPos, geometry))
                                        
                                        MyTextField(placeholder: "Text One", text: $topText, alignment: $topTextAlignment)
                                            .font(Font(UIFont(name: topFontName ?? "Helvetica Bold", size: scaleAgainstWidth(CGFloat(topFontSize), geometry))!))
                                            .foregroundColor(topCol)
                                            .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.textSidePadding, geometry) * 2, height: topFontHeight(geometry), alignment: textAlignToFrameAlign(topTextAlignment))
                                            .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                                topPos = min(max(CGFloat(topFontSize / 2), topPos + gesture.translation.height), 1500 - CGFloat(topFontSize / 2))
                                            })
                                        
                                        Spacer()
                                            .frame(height: scaleAgainstWidth(1500 - topPos, geometry))
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
                                            .frame(height: scaleAgainstWidth(botPos, geometry))
                                        
                                        MyTextField(placeholder: "Text Two", text: $botText, alignment: $botTextAlignment)
                                            .font(Font(UIFont(name: botFontName ?? "Helvetica", size: scaleAgainstWidth(CGFloat(botFontSize), geometry))!))
                                            .foregroundColor(botCol)
                                            .frame(width: coverSize(geometry) - scaleAgainstWidth(withProperties!.textSidePadding, geometry) * 2, height: botFontHeight(geometry), alignment: textAlignToFrameAlign(botTextAlignment))
                                            .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                                botPos = min(max(CGFloat(botFontSize / 2), botPos + gesture.translation.height), 1500 - CGFloat(botFontSize / 2))
                                            })
                                        
                                        Spacer()
                                            .frame(height: scaleAgainstWidth(1500 - botPos, geometry))
                                            
                                    }
                                    
                                    // Simulate sidePadding
                                    Spacer()
                                        .frame(width: scaleAgainstWidth(withProperties!.textSidePadding, geometry))
                                }
                                
                            }
                            .frame(width: coverSize(geometry), height: coverSize(geometry), alignment: .center)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                        .shadow(radius: 35)
                        .padding(.top, 25)
                        
                        
                        // Editing tools
                        
                        HStack {
                            
                            TextToolsView(colPickTitle: $topText, colPickDefaultTitle: "Text one", colPicked: $topCol, fontDisplayName: $topFontDisplayName, fontPostscriptName: $topFontName, fontSize: $topFontSize, textAlignment: $topTextAlignment, rounding: rounding)
                                .frame(width: coverSize(geometry) / 2 - 10)
                                .padding(.trailing, 5)
                            
                            Divider()
                            
                            TextToolsView(colPickTitle: $botText, colPickDefaultTitle: "Text two", colPicked: $botCol, fontDisplayName: $botFontDisplayName, fontPostscriptName: $botFontName, fontSize: $botFontSize, textAlignment: $botTextAlignment, rounding: rounding)
                                .frame(width: coverSize(geometry) / 2 - 10)
                                .padding(.leading, 5)
                            
                        }
                        
                        .frame(width: coverSize(geometry))

                        
                        Spacer()
                    
                        // Export button
                        Button(action: exportCover) {
                            Label((existingManagedObject != nil) ? "Update Cover" : "Add to Library", systemImage: "arrow.2.circlepath.circle.fill")
                                .foregroundColor(buttonLabelColor)
                                .font(.headline)
                                .padding()
                                .frame(width: coverSize(geometry))
                                .background(dominantImageColor)
                                .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous).inset(by: 1))
                                .padding(1)
                                .background(buttonLabelColor)
                                .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom)
                            
                        
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        PillButton(systemImage: "trash.fill") {
                            clearAllCustomizations()
                        }
                        
                        PillButton(label: "Reset") {
                            resetTextToInitialCoverValues()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard) // avoid getting pushed up by keyboard
        .onAppear {
            initialSetup()
        }
    }
}

struct CoverEditView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
    }
}
