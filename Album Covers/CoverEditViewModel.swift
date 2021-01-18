//
//  CoverEditViewModel.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/17/21.
//

import SwiftUI
import Foundation

class ImageColorCache {
    public static let shared = ImageColorCache()
    
    var cache = NSCache<NSString, UIImageColors>()
    
    func get(forKey: String) -> UIImageColors? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(_ colors: UIImageColors, forKey: String) {
        cache.setObject(colors, forKey: NSString(string: forKey))
    }
}

class CoverEditViewModel : ObservableObject {
    
    
    private var withProperties : CoverProperties?
    private var existingManagedObject : ObservedObject<Cover>?
    
    @Published  var topText : String = ""
    @Published  var botText : String = ""
    
    @Published  var topCol : Color = .white
    @Published  var botCol : Color = .white
    
    @Published  var topFontName : String?
    @Published  var botFontName : String?
    @Published  var topFontDisplayName : String?
    @Published  var botFontDisplayName : String?
    
    @Published  var topFontSize : Int = 0
    @Published  var botFontSize : Int = 0
    
    @Published  var topTextAlignment : NSTextAlignment = .left
    @Published  var botTextAlignment : NSTextAlignment = .left
    
    @Published  var topPos : CGFloat = 0
    @Published  var botPos : CGFloat = 0
    
    @Published  var dominantImageColor : Color = .white
    @Published  var buttonLabelColor : Color = .blue
    
    var coverWidthPercentage : CGFloat = 0.85
    
    private var isExporting : Bool = false
    
    // Accessed properties
    public var loadedData : Bool {
        (withProperties != nil)
    }
    
    public var backgroundImage : String? {
        withProperties?.backgroundImgURL
    }
    
    public var topFrameAlignment : Alignment {
        textAlignToFrameAlign(topTextAlignment)
    }
    
    public var botFrameAlignment : Alignment {
        textAlignToFrameAlign(botTextAlignment)
    }
    
    public var isNew : Bool {
        (existingManagedObject == nil)
    }
    
    
    func initialize(withProperties : CoverProperties) {
        self.withProperties = withProperties
        
        initialSetup()
    }
    
    func initialize(withCover : ObservedObject<Cover>) {
        self.existingManagedObject = withCover
        
        if (self.existingManagedObject != nil) {
            self.withProperties = PropertiesFromCover(self.existingManagedObject!.wrappedValue)
        }
        
        initialSetup()
    }
    
    // perform initial setup after getting properties
    func initialSetup() {
        // set initial customizations based on properties
        resetToInitialCoverValues()
        
        
        loadImageColors()
        
        self.isExporting = false
    }
    
    func loadImageColors() {
        // check cache first
        if let cacheColors = ImageColorCache.shared.get(forKey: self.backgroundImage!) {
            self.dominantImageColor = Color(cacheColors.background)
            self.buttonLabelColor = Color(cacheColors.primary)
        } else {
            // get image colors
            UIImage(named: self.backgroundImage!)?.getColors { wrapped in
                if let colors = wrapped {
                    self.dominantImageColor = Color(colors.background)
                    self.buttonLabelColor = Color(colors.primary)
                    
                    ImageColorCache.shared.set(colors, forKey: self.backgroundImage!)
                }
            }
        }
    }
    
    
    
    
    func coverSize(_ geo : GeometryProxy) -> CGFloat {
        return min(geo.size.width, geo.size.height) * self.coverWidthPercentage
    }
    
    func scaled(_ num : CGFloat, _ geo : GeometryProxy) -> CGFloat {
        return num * (coverSize(geo) / 1500)
    }
    
    func sidePadding(_ geo : GeometryProxy) -> CGFloat {
        return scaled(withProperties!.textSidePadding, geo)
    }
    
    func fontHeight(_ name : String?, _ size : Int, _ geo : GeometryProxy) -> CGFloat {
        return UIFont(name: name ?? "Helvetica", size: scaled(CGFloat(size), geo))!.lineHeight
    }
    
    func topFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return fontHeight(topFontName, topFontSize, geo)
    }
    
    func botFontHeight(_ geo : GeometryProxy) -> CGFloat {
        return fontHeight(botFontName, botFontSize, geo)
    }
    
    func topPosition(_ geo : GeometryProxy) -> CGFloat {
        return scaled(topPos, geo)
    }
    
    func botPosition(_ geo : GeometryProxy) -> CGFloat {
        return scaled(botPos, geo)
    }
    
    func topFont(_ geo : GeometryProxy) -> Font {
        return Font(UIFont(name: topFontName ?? "Helvetica Bold", size: scaled(CGFloat(topFontSize), geo))!)
    }
    
    func botFont(_ geo : GeometryProxy) -> Font {
        return Font(UIFont(name: botFontName ?? "Helvetica", size: scaled(CGFloat(botFontSize), geo))!)
    }
    
    func textFieldWidth(_ geo : GeometryProxy) -> CGFloat {
        return (coverSize(geo) - sidePadding(geo) * 2)
    }
    
    func textAlignToFrameAlign(_ align : NSTextAlignment) -> Alignment {
        if (align == .left) {
            return .leading
        } else if (align == .right) {
            return .trailing
        }
        
        return .center
    }
    
    
    
    
    // Set all customizations to default values / empty where applicable
    func clearAllCustomizations() {
        self.topText = ""
        self.botText = ""
        
        self.topCol = Color.white
        self.botCol = Color.white
        
        self.topFontName = "Helvetica Bold"
        self.botFontName = "Helvetica"
        self.topFontDisplayName = "Helvetica"
        self.botFontDisplayName = "Helvetica"
        
        self.topFontSize = 216
        self.botFontSize = 216
        
        self.topTextAlignment = .left
        self.botTextAlignment = .left
        
        self.topPos = 150
        self.botPos = 375
    }
    
    // Sets all customizations to the value stored in withProperties
    // (so, whatever was passed in initially)
    func resetToInitialCoverValues() {
        self.topText = withProperties!.topText
        self.botText = withProperties!.botText
        
        self.topCol = Color(withProperties!.topFontColor)
        self.botCol = Color(withProperties!.botFontColor)
        
        self.topFontName = withProperties!.topFontName
        self.botFontName = withProperties!.botFontName
        self.topFontDisplayName = UIFont(name: withProperties!.topFontName, size: 17)?.familyName
        self.botFontDisplayName = UIFont(name: withProperties!.botFontName, size: 17)?.familyName
        
        self.topTextAlignment = withProperties!.topTextAlignment
        self.botTextAlignment = withProperties!.botTextAlignment
        
        self.topFontSize = Int(withProperties!.topFontSize)
        self.botFontSize = Int(withProperties!.botFontSize)
        
        self.topPos = withProperties!.topPos
        self.botPos = withProperties!.botPos
    }
    
    // Export cover with customizations
    func exportCover() {
        // prevent double clicking
        if (self.isExporting) {
            return
        }
        
        self.isExporting = true
        
        var copyOfProps = self.withProperties!
        copyOfProps.topText = self.topText
        copyOfProps.botText = self.botText
        copyOfProps.topFontColor = UIColor(self.topCol)
        copyOfProps.botFontColor = UIColor(self.botCol)
        copyOfProps.topFontName = self.topFontName!
        copyOfProps.botFontName = self.botFontName!
        copyOfProps.topFontSize = CGFloat(self.topFontSize)
        copyOfProps.botFontSize = CGFloat(self.botFontSize)
        copyOfProps.topTextAlignment = self.topTextAlignment
        copyOfProps.botTextAlignment = self.botTextAlignment
        copyOfProps.topPos = self.topPos
        copyOfProps.botPos = self.botPos
        
        // try to render image
        makeCoverImage(copyOfProps) { image in
            if let img = image {
                // create a new object if this was from properties
                if (self.existingManagedObject == nil) {
                    let newCover = CoverFromProperties(copyOfProps)
                    newCover.renderedImageData = img.pngData()
                } else {
                    // Else, Modify existing object
                    self.existingManagedObject!.wrappedValue.topText = copyOfProps.topText
                    self.existingManagedObject!.wrappedValue.botText = copyOfProps.botText
                    self.existingManagedObject!.wrappedValue.topFontColor = archiveColor(copyOfProps.topFontColor)
                    self.existingManagedObject!.wrappedValue.botFontColor = archiveColor(copyOfProps.botFontColor)
                    self.existingManagedObject!.wrappedValue.topFontName = copyOfProps.topFontName
                    self.existingManagedObject!.wrappedValue.botFontName = copyOfProps.botFontName
                    self.existingManagedObject!.wrappedValue.topFontSize = Float(copyOfProps.topFontSize)
                    self.existingManagedObject!.wrappedValue.botFontSize = Float(copyOfProps.botFontSize)
                    self.existingManagedObject!.wrappedValue.topTextAlignment = alignToInt(copyOfProps.topTextAlignment)
                    self.existingManagedObject!.wrappedValue.botTextAlignment = alignToInt(copyOfProps.botTextAlignment)
                    self.existingManagedObject!.wrappedValue.topPos = Float(copyOfProps.topPos)
                    self.existingManagedObject!.wrappedValue.botPos = Float(copyOfProps.botPos)
                    
                    self.existingManagedObject!.wrappedValue.dateEdited = Date()
                    
                    self.existingManagedObject!.wrappedValue.renderedImageData = img.pngData()
                    
                }

                // Save changes to persistent container
                withAnimation {
                    PersistenceController.shared.saveContainer()
                }
            }
        }
    }
    
    
    
}

