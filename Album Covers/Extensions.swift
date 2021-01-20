//
//  Extensions.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import Foundation
import UIKit
import SwiftUI

// For responsive layout

enum LayoutType {
    case compact
    case wide
}

func columnLayout(_ geo : GeometryProxy, _ horizontalSizeClass : UserInterfaceSizeClass?) -> LayoutType {
    return ((UIDevice.current.userInterfaceIdiom == .pad || geo.size.width > geo.size.height) && horizontalSizeClass != .compact) ? .wide : .compact
}

// extend Cover to always assign a UUID and date on creation
extension Cover {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        dateEdited = Date()
    }
}

// extend UIImage to add function to return average color of the image
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

// extend UIApplication to add function to dismiss the keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
