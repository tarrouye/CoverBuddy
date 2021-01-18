//
//  CollectionCard.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct CollectionCard : View {
    @State var collection : Collection!
    
    var rotationDegrees : Double
    
    var body: some View {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                
                
                Image("combined-album-cover-collection-\(collection.title.lowercased())")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 0, y: 25)
                    .rotationEffect(.degrees(rotationDegrees))
                    .scaleEffect(1.55)

            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
            .overlay(
                VStack {
                    Spacer()
                    ZStack {
                        BackgroundBlurView()
                    
                        HStack {
                            VStack (alignment: .leading) {
                                Text(collection.title)
                                    .font(.headline)
                                
                                Text(collection.tagline)
                                    .font(.caption)
                            }
                        
                            Spacer()
                        }
                        .padding(.horizontal, 25)
                    }
                    .frame(height: 60)
                }
                
            )
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}


struct CollectionCard_Previews: PreviewProvider {
    static var previews: some View {
        CollectionCard(collection: allCollections[0], rotationDegrees: 5)
    }
}
