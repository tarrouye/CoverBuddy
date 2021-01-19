//
//  ImageSaver.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import Foundation
import UIKit

class ImageSaver: NSObject, ObservableObject {
    public static let shared = ImageSaver()
    
    @Published public var latestSaveSuceeded : Bool = true
    
    func writeToPhotoAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCallback), nil)
    }

    // Handle errors
    @objc func saveCallback(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // failed to save cover image
            /*
            let alert = UIAlertController(title: "Image Save Failure", message: "Your custom cover failed the export to the Photo Library. Please check in Settings that you have granted the app appropriate permissions. If the issue persists, please contact Support or file Feedback.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)(*/ // Commented out bc handle error message in SetPlaylistInstructionView now
            
            self.latestSaveSuceeded = false
        } else {
            self.latestSaveSuceeded = true
        }
    }
}
