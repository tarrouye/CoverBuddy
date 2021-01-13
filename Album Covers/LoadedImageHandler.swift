//
//  LoadedImageHandler.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import Foundation
import UIKit

class LoadedImageHandler {
    static var shared = LoadedImageHandler()
    
    private var cache : [UIImage]
    private var color_cache : [UIImageColors?]
    private var keys : [String]
    
    private let loadQueue = DispatchQueue(label: "loaded_image_handler")
    private let colorQueue = DispatchQueue(label: "loaded_image_color_handler")

    init() {
        cache = []
        color_cache = []
        keys = []
    }
    
    func saveImageToDisk(_ image : UIImage, forKey : String) {
        // get document directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // get a url for the file
        let fileURL = documentsDirectory.appendingPathComponent(forKey)
        
        // convert the image to data
        guard let data = image.pngData() ?? image.jpegData(compressionQuality: 1) else { return }

        // Check for if file already exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("failed to remove file at path", removeError)
            }

        }
        
        // Try to write to disk
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDisk(forKey: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let path = paths.first {
            let imageUrl = URL(fileURLWithPath: path).appendingPathComponent(forKey)
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image
        }

        return nil
    }
    
    public func storeImage(_ img : UIImage, forKey : String, toDisk : Bool = false) {
        if let ind = keys.firstIndex(where: { $0 == forKey}) {
            self.cache[ind] = img
            
            print("UPDATED STORED IMAGE \(forKey)")
        } else {
            self.cache.append(img)
            self.color_cache.append(nil)
            self.keys.append(forKey)
        
            print("STORED IMAGE \(forKey)")
        }
        
        if (toDisk) {
            print("SAVING IMAGE TO DISK \(forKey)")
            self.saveImageToDisk(img, forKey: forKey)
        }
    }
    
    public func storeColors(_ colors : UIImageColors?, forKey: String) {
        if let ind = keys.firstIndex(where: { $0 == forKey}) {
            self.color_cache[ind] = colors
            
            print("UPDATED STORED COLORS \(forKey)")
        }
    }
    
    
    
    public func loadImageSynchronously(forKey : String, fallback : (() -> UIImage?)? = nil, fromDisk: Bool = false) -> UIImage? {
        // Try cache first
        if let ind = self.keys.firstIndex(where: { $0 == forKey}) {
            print("RETURNING LOADED IMAGE \(forKey)")
            return self.cache[ind]
        }
        
        // Then try disk if it is from disk
        if (fromDisk) {
            print("LOADING IMAGE FROM DISK \(forKey)")
            if let img = self.loadImageFromDisk(forKey: forKey) {
                self.storeImage(img, forKey: forKey, toDisk: false)
                return img
            } else {
                print("ERROR LOADING IMAGE FROM DISK \(forKey)")
            }
        }
        
            
        // Then try provided fallback method
        if (fallback != nil) {
            if let img = fallback!() {
                print("GOT IMG FROM FALLBACK METHOD \(forKey)")
                self.storeImage(img, forKey: forKey, toDisk: fromDisk)
                return img
            }
        }
        
        
        return nil
    }
    
    public func loadColors(forKey : String, fallbackImg: UIImage?) -> UIImageColors? {
        // check color_cache first
        if let ind = self.keys.firstIndex(where: { $0 == forKey}) {
            if let cols = self.color_cache[ind] {
                print("LOADED COLOR FROM CACHE \(forKey)")
                return cols
            }
        }
        
        // load from UIImageColors
        if fallbackImg != nil {
            let wrappedCols = fallbackImg!.getColors()
            
            print("LOADED COLORS FROM SCRATCH \(forKey)")
            
            self.storeColors(wrappedCols, forKey: forKey)
        
            return wrappedCols
        }
        
        return nil
    }
    
    typealias ImageCompletionHandler = (UIImage?) -> Void
    typealias ColorCompletionHandler = (UIImageColors?) -> Void
    
    public func loadImage(forKey : String, fallback : (() -> UIImage?)? = nil, fromDisk: Bool = false, colorCompletion: ColorCompletionHandler? = nil, completionHandler: @escaping ImageCompletionHandler) -> Void {
        self.loadQueue.async {
            let img = self.loadImageSynchronously(forKey: forKey, fallback: fallback, fromDisk: fromDisk)
            
            if (colorCompletion != nil) {
                DispatchQueue.main.async {
                    completionHandler( img )
                }
                
                
                
                self.colorQueue.async {
                    let wrappedCols = self.loadColors(forKey: forKey, fallbackImg: img)
                    DispatchQueue.main.async {
                        colorCompletion!( wrappedCols )
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completionHandler( img )
                }
            }
            
                
            
            
        }
        
        
    }
}
