//
//  PresetSelectionView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/10/21.
//

import SwiftUI

func nameFromImgFileName(_ imgName : String) -> String {
    var imgPieces : [String] = []
    
    // split file name by dashes
    for piece in imgName.split(separator: "-") {
        // filter out numbers (used when an artist is featured twice)
        if (Int(piece) != nil) {
            continue
        }
        
        // capitalize first letter of each word (name)
        imgPieces.append(String(piece.prefix(1).capitalized + piece.dropFirst()))
    }
    
    // put the pieces back together
    return imgPieces.joined(separator: " ")
}

struct PresetSelectionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var rootIsActive : Bool
    
    var collection : Collection!
    
    var rounding: CGFloat = 20
    
    //@State private var presetImages : [UIImage?] = []
    
    func initialSetup() {
        
        /*if (presetImages.count < 1) {
            // load all preset images
            for i in collection.templates.indices {
                LoadedImageHandler.shared.loadImage(forKey: "collection-\(collection.title)-preset-thumbnail-\(collection.templates[i].backgroundImgURL).\(collection.templates[i].backgroundImgType)", fallback: { convertToThumbnail(makeCoverImage(collection.templates[i])) }, fromDisk: true) { img in
                    if (img != nil) {
                        presetImages.append(img)
                    }
                }
               
            }
        }*/
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                // Collection title
                Text(collection.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Collection tagline
                Text(collection.tagline)
                    .font(.none)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                    .padding(.bottom)
                
                
                Spacer()
                
                // Previews
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(collection.templates.indices) { i in
                            //if (presetImages.count > i && presetImages[i] != nil) {
                                NavigationLink(destination: CoverEditView(withProperties: collection.templates[i], rootIsActive: $rootIsActive)) {
                                    VStack {
                                        // Thumbnail
                                        CoverPreview(withProperties: collection.templates[i])
                                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                                            .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                                            .shadow(radius: 5)
                                        
                                        // Artist credit
                                        HStack(spacing: 0) {
                                            Text("Artwork by ")
                                                .font(.caption)
                                                .italic()
                                            
                                            Text(nameFromImgFileName(collection.templates[i].backgroundImgURL))
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.top)
                                        
                                    }
                                    .padding()
                                }
                                .isDetailLink(false)
                                .buttonStyle(PlainButtonStyle())
                            //}
                        }
                    }
                }
                .background(EmptyView())
                
                Spacer()
                
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            //.frame(width: .infinity, height: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                initialSetup()
            }
        }
    }
}

struct PresetSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PresetSelectionView(rootIsActive: .constant(false))
    }
}
