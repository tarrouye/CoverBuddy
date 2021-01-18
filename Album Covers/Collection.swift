//
//  Collection.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import Foundation
import UIKit

struct Collection : Hashable {
    var title : String
    var tagline : String
    
    var templates : [CoverProperties]
    
    init(_ title : String, _ tag : String, _ presets : [CoverProperties]) {
        self.title = title
        self.tagline = tag
        self.templates = presets
    }
}


/*
 
This is used in dev environment to make the combined cover for a collection.
It is not used in production.
 
func makeCombinedCover(_ collect : Collection) -> UIImage? {
    // get all the cover thumbnails
    var coverImages : [UIImage] = []
    for c in collect.templates.indices {
        if let img = LoadedImageHandler.shared.loadImageSynchronously(forKey: "collection-\(collect.title)-preset-thumbnail-\(collect.templates[c].backgroundImgURL).\(collect.templates[c].backgroundImgType)", fallback: { convertToThumbnail(makeCoverImageSynchronously(collect.templates[c]))
        }, fromDisk: true) {
            coverImages.append(img)
        }
    }
    
    // display them in a grid with 3 rows
    let canvas = CGSize(width: 1350, height: 1020)
    
    // Create image context with canvas size
    UIGraphicsBeginImageContextWithOptions(canvas, false, 1.0)
    
    // Load cover background images
    for i in coverImages.indices {
        // Calculate dimensions and position
        let w : CGFloat = 300
        let margin = (canvas.width - (w * 4)) / CGFloat(5)
        let bx = margin + (w + margin) * CGFloat( i % 4 )
        
        let row = i / 4
        if (row > 2) {
            break // we only need to show 3 rows so dont waste any more resources
        }
        let by = margin + (w + margin) * CGFloat(row)
        
        // create CGRect with our image position and dimensions
        let imRect = CGRect(origin: CGPoint(x: bx, y: by), size: CGSize(width: w, height: w))
        
        // create a clipping path rounded rect
        let path = UIBezierPath(roundedRect: imRect, cornerRadius: 35.0)
        
        // push current context before adding clip
        UIGraphicsGetCurrentContext()!.saveGState()
        
        // add clip mask
        path.addClip()
        // draw cover image
        coverImages[i].draw(in: imRect)
        
        // pop current context before we added clip
        UIGraphicsGetCurrentContext()!.restoreGState()
    }
    
    // Get resulting image from context
    let result = UIGraphicsGetImageFromCurrentImageContext()!
        
    // end the image context
    UIGraphicsEndImageContext()
    
    // return cover image!
    return result
}
 


func makeAllCollectionCovers() {
    for i in allCollections.indices {
        makeCombinedCover(allCollections[i])
    }
}
 
 */
