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
    
    @State var selectedCard : Int = 0
    
    @State var selectedNavigationItem : Int? = nil
    
    @State var buttonBackgroundColor : [Color?] = [nil]
    @State var buttonForegroundColor : [Color?] = [nil]
    
    func loadImageColors() {
        
        for card in collection.templates.indices {
            if (buttonForegroundColor.count <= card) {
                buttonForegroundColor.append(nil)
                buttonBackgroundColor.append(nil)
            }
            
            // check cache first
            if let cacheColors = ImageColorCache.shared.get(forKey: collection.templates[card].backgroundImgURL) {
                buttonBackgroundColor[card] = Color(cacheColors.background)
                buttonForegroundColor[card] = Color(cacheColors.primary)
            } else {
                UIImage(named: collection.templates[card].backgroundImgURL)?.getColors { wrapped in
                    if let colors = wrapped {
                        ImageColorCache.shared.set(colors, forKey: collection.templates[card].backgroundImgURL)
                        
                        buttonBackgroundColor[card] = Color(colors.background)
                        buttonForegroundColor[card] = Color(colors.primary)
                    }
                }
            }
        }
        
        
        
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                Spacer()
                
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
                CarouselView(cardCount: collection.templates.count, currentIndex: $selectedCard, spacingOffset: 80) {
                    ForEach(collection.templates.indices) { i in
                        ZStack {
                            // Empty NavLink to trigger programmatically
                            NavigationLink(destination: CoverEditView(withProperties: collection.templates[i], rootIsActive: $rootIsActive),
                                           tag: i,
                                           selection: $selectedNavigationItem) {}.isDetailLink(false)
                        
                            // Cover Preview
                            VStack {
                                // Thumbnail
                                CoverPreview(withProperties: collection.templates[i])
                                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                                    .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                                
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
                            .scaleEffect(selectedCard == i ? 1.0 : 0.8)
                            .padding(.vertical)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(EmptyView())
                
                Spacer()
                
                // Select button
                Button(action: {
                    selectedNavigationItem = selectedCard
                }) {
                    Label("Create Cover", systemImage: "plus.circle")
                        .foregroundColor(buttonForegroundColor[selectedCard] ?? .white)
                        .font(.headline)
                        .padding()
                        .frame(width: min(geometry.size.width, geometry.size.height) * 0.8)
                        .background(buttonBackgroundColor[selectedCard] ?? .blue)
                        .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous).inset(by: 1))
                        .padding(1)
                        .background(buttonForegroundColor[selectedCard] ?? .white)
                        .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom)
                
                Spacer()
                
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if (buttonBackgroundColor.count < collection.templates.count ) {
                    loadImageColors()
                }
            }
        }
    }
}

