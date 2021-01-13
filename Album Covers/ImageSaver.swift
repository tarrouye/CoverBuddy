//
//  ImageSaver.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        // TODO : Handle errors
    }
}
