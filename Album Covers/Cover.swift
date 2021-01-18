//
//  CoverProperties.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/10/21.
//

import Foundation
import UIKit

struct CoverProperties : Hashable {
    // top and bottom text
    var topText : String = "My Dope"
    var botText : String = "Playlist"
    
    // a cover is 1500 x 1500 px
    // y - position of bottom and top text
    var topPos : CGFloat = 150
    var botPos : CGFloat = 374 //1350
    
    // text alignment (.right, .center, .left)
    var topTextAlignment : NSTextAlignment = .left
    var botTextAlignment : NSTextAlignment = .left

    var topFontName : String = "Helvetica Bold"
    var botFontName : String = "Helvetica"
    
    var topFontSize : CGFloat = 216
    var botFontSize : CGFloat = 216
    
    var topFontColor : UIColor = .white
    var botFontColor : UIColor = .white
    
    var topXOffset : CGFloat = 100
    var botXOffset : CGFloat = 100
    
    var textSidePadding : CGFloat = 100
    
    // background image for cover
    var backgroundImgDirectory : String = "Love"
    var backgroundImgURL : String = "alexandru-acea"
    var backgroundImgType : String = "png"
    
    // hold UIImages which must be updated if the above values change
    var renderedImage : UIImage?
}

func alignToInt(_ align: NSTextAlignment) -> Int16 {
    if (align == .left) {
        return 0
    }
    
    if (align == .center) {
        return 1
    }
    
    return 2
}

func intToAlign(_ num : Int16) -> NSTextAlignment {
    if (num == 0) {
        return .left
    }
    
    if (num == 1) {
        return .center
    }
    
    return .right
}

func unarchiveColor(_ colorData : NSObject?) -> UIColor {
    if (colorData != nil) {
        do {
            let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData as! Data) as! UIColor
            
            return unarchived
        } catch {
            // error unarchiving the data
        }
    }
    
    return UIColor.white // default value
}


func archiveColor(_ color : UIColor) -> NSObject? {
    do {
        let archived = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true) as NSObject
        
        return archived
    } catch {
        // error archiving the data
    }
    
    return nil
}

func PropertiesFromCover(_ cover : Cover) -> CoverProperties {
    var props = CoverProperties()
    
    props.topText = cover.topText ?? ""
    props.botText = cover.botText ?? ""
    props.topPos = CGFloat(cover.topPos)
    props.botPos = CGFloat(cover.botPos)
    props.topTextAlignment = intToAlign(cover.topTextAlignment)
    props.botTextAlignment = intToAlign(cover.botTextAlignment)
    props.topFontName = cover.topFontName ?? "Helvetica"
    props.botFontName = cover.botFontName ?? "Helvetica"
    props.topFontColor = unarchiveColor(cover.topFontColor)
    props.botFontColor = unarchiveColor(cover.botFontColor)
    props.topFontSize = CGFloat(cover.topFontSize)
    props.botFontSize = CGFloat(cover.botFontSize)
    props.textSidePadding = CGFloat(cover.textSidePadding)
    props.topXOffset = CGFloat(cover.topXOffset)
    props.botXOffset = CGFloat(cover.botXOffset)
    props.backgroundImgURL = cover.backgroundImgURL ?? "adrien-converse"
    props.backgroundImgType = cover.backgroundImgType ?? "png"
    props.backgroundImgDirectory = cover.backgroundImgDirectory ?? "Abstract"
    
    if (cover.renderedImageData != nil) {
        props.renderedImage = UIImage(data: cover.renderedImageData!)
    }
    
    return props
}

func CoverFromProperties(_ props : CoverProperties) -> Cover {
    let cover = Cover(context: PersistenceController.shared.container.viewContext)
    
    cover.topText = props.topText
    cover.botText = props.botText
    cover.topPos = Float(props.topPos)
    cover.botPos = Float(props.botPos)
    cover.topTextAlignment = alignToInt(props.topTextAlignment)
    cover.botTextAlignment = alignToInt(props.botTextAlignment)
    cover.topFontName = props.topFontName
    cover.botFontName = props.botFontName
    cover.topFontColor = archiveColor(props.topFontColor)
    cover.botFontColor = archiveColor(props.botFontColor)
    cover.topFontSize = Float(props.topFontSize)
    cover.botFontSize = Float(props.botFontSize)
    cover.textSidePadding = Float(props.textSidePadding)
    cover.topXOffset = Float(props.topXOffset)
    cover.botXOffset = Float(props.botXOffset)
    cover.backgroundImgURL = props.backgroundImgURL
    cover.backgroundImgType = props.backgroundImgType
    cover.backgroundImgDirectory = props.backgroundImgDirectory
    
    if (props.renderedImage != nil) {
        cover.renderedImageData = props.renderedImage!.pngData()
    }
    
    cover.dateEdited = Date()
    
    return cover
}

func loadCoverBackgroundImageSynch(_ backgroundImgURL: String, _ backgroundImgType : String, _ backgroundImgDirectory: String) -> UIImage? {
    if let imageFilePath = Bundle.main.path(forResource: backgroundImgURL, ofType: backgroundImgType, inDirectory: "Backgrounds/\(backgroundImgDirectory)") {
        
        if let image = UIImage(contentsOfFile: imageFilePath) {
            return image
        }
        
        return nil
    }
    
    return nil
}

func loadCoverBackgroundImage(_ cover: CoverProperties, synch : Bool = false, colorCompletion: LoadedImageHandler.ColorCompletionHandler? = nil, completionHandler: @escaping LoadedImageHandler.ImageCompletionHandler) {
    if (synch) {
        let img = loadCoverBackgroundImageSynch(cover.backgroundImgURL, cover.backgroundImgType, cover.backgroundImgDirectory)
        if (img != nil) {
            LoadedImageHandler.shared.storeImage(img!, forKey: "cover-background-\(cover.backgroundImgDirectory)-\(cover.backgroundImgURL)-\(cover.backgroundImgType)")
        }
        completionHandler( img)
    } else {
        LoadedImageHandler.shared.loadImage(
                forKey: "cover-background-\(cover.backgroundImgDirectory)-\(cover.backgroundImgURL)-\(cover.backgroundImgType)",
                fallback: {
                    return loadCoverBackgroundImageSynch(cover.backgroundImgURL, cover.backgroundImgType, cover.backgroundImgDirectory)
                }, colorCompletion: colorCompletion) { img in
                    if (img != nil) {
                        completionHandler( img )
                    }
            
        }
    }
    
}

func loadCoverBackgroundImage(_ cover: Cover, synch : Bool = false, colorCompletion: LoadedImageHandler.ColorCompletionHandler? = nil, completionHandler: @escaping LoadedImageHandler.ImageCompletionHandler) {
    if (synch) {
        let img = loadCoverBackgroundImageSynch(cover.backgroundImgURL!, cover.backgroundImgType!, cover.backgroundImgDirectory!)
        if (img != nil) {
            LoadedImageHandler.shared.storeImage(img!, forKey: "cover-background-\(cover.backgroundImgDirectory!)-\(cover.backgroundImgURL!)-\(cover.backgroundImgType!)")
        }
        completionHandler( img)
    } else {
        LoadedImageHandler.shared.loadImage(
                forKey: "cover-background-\(cover.backgroundImgDirectory!)-\(cover.backgroundImgURL!)-\(cover.backgroundImgType!)",
                fallback: {
                    return loadCoverBackgroundImageSynch(cover.backgroundImgURL!, cover.backgroundImgType!, cover.backgroundImgDirectory!)
                }, colorCompletion: colorCompletion) { img in
                    if (img != nil) {
                        completionHandler( img )
                    }
            
        }
    }
    
}

func cgDrawCoverImage(_ image : UIImage, _ cover : CoverProperties) -> UIImage? {
    let canvas = CGSize(width: 1500, height: 1500)
    
    // Create image context with size 1500 x 1500 and scaling 1.0
    UIGraphicsBeginImageContextWithOptions(canvas, true, 1.0)
    
    // Draw background image
    image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: canvas))
    
    // Set our text attributes
    
    
    if (cover.topText != "") {
        let topTextStyle = NSMutableParagraphStyle()
        topTextStyle.alignment = cover.topTextAlignment
        
        let topFont = UIFont(name: cover.topFontName, size: cover.topFontSize)!
        let topTextAttributes = [
            NSAttributedString.Key.font: topFont,
            NSAttributedString.Key.paragraphStyle: topTextStyle,
            NSAttributedString.Key.foregroundColor: cover.topFontColor
        ] as [NSAttributedString.Key : Any]
    
    
        // Draw top text
        let topTextRect = CGRect(x: cover.textSidePadding, y: cover.topPos - topFont.lineHeight / 2, width: canvas.width - cover.textSidePadding * 2, height: topFont.lineHeight)
        
        // Draw top string
        cover.topText.draw(in: topTextRect, withAttributes: topTextAttributes)
    }

    if (cover.botText != "") {
        
        let botTextStyle = NSMutableParagraphStyle()
        botTextStyle.alignment = cover.botTextAlignment
        
        let botFont = UIFont(name: cover.botFontName, size: cover.botFontSize)!
        let botTextAttributes = [
            NSAttributedString.Key.font: botFont,
            NSAttributedString.Key.paragraphStyle: botTextStyle,
            NSAttributedString.Key.foregroundColor: cover.botFontColor
        ] as [NSAttributedString.Key : Any]
        
        // Draw bottom text
        let botTextRect = CGRect(x: cover.textSidePadding, y: cover.botPos - botFont.lineHeight / 2, width: canvas.width - cover.textSidePadding * 2, height: botFont.lineHeight)
        
        cover.botText.draw(in: botTextRect, withAttributes: botTextAttributes)
    }

    // Get resulting image from context
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    
    // end the image context
    UIGraphicsEndImageContext()
    
    return result
}

// a cover is 1500 x 1500 px
func makeCoverImage(_ cover: CoverProperties, completionHandler: @escaping LoadedImageHandler.ImageCompletionHandler) {
    // Load cover background image
    loadCoverBackgroundImage(cover) { img in
        if let image = img {
            let result = cgDrawCoverImage(image, cover)
            
            // return cover image!
            completionHandler( result )
        } else {
            // couldnt load image
            completionHandler( nil )
        }
    }
}

func makeCoverImageSynchronously(_ cover: CoverProperties) -> UIImage? {
    // Load cover background image
    if let image = loadCoverBackgroundImageSynch(cover.backgroundImgURL, cover.backgroundImgType, cover.backgroundImgDirectory) {
        let result = cgDrawCoverImage(image, cover)
        
        // return cover image!
        return result
    }
    
    return nil
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)


    // Resize the image
    UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
}

// a cover is 1500 x 1500 px
// a thumbnail is smallest screen dimension square px
func convertToThumbnail(_ imgMaybe : UIImage?, scaleFactor : CGFloat = 0.8) -> UIImage? {
    if let img = imgMaybe {
        let bounds = UIScreen.main.bounds
        let minsize = min(bounds.width, bounds.height)
        let newsize = ( minsize * scaleFactor ) * UIScreen.main.scale
        print("THUMBNAIL WILL BE \(minsize * scaleFactor) x \(minsize * scaleFactor) @ \(UIScreen.main.scale) (\(newsize) x \(newsize))")
        
        return resizeImage(image: img, targetSize: CGSize(width: newsize, height: newsize))
    }
    
    return nil
}

func saveCoverImage(_ cover: Cover) {
    let imageSaver = ImageSaver()
    
    // try getting it from already made first
    if let imgData = cover.renderedImageData {
        if let coverImg = UIImage(data: imgData) {
            // try to write to photo album
            imageSaver.writeToPhotoAlbum(coverImg)
        } else {
                // failed to save cover image
                let alert = UIAlertController(title: "Image Save Failure", message: "Your custom cover failed the export to the Photo Library. Please check in Settings that you have granted the app appropriate permissions.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.windows.first!.rootViewController!.present(alert, animated: true)
        }
    }
}


