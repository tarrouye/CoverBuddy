//
//  CollectionsView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI

struct CollectionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Binding var rootIsActive : Bool
    
    @State var columnGrid = [GridItem(.flexible())]
    
    func numColumns(_ geo : GeometryProxy) -> Int {
        return columnLayout(geo, horizontalSizeClass) == .wide ? 2 : 1
    }
    
    func columns(_ geo : GeometryProxy) -> [GridItem] {
        let one = [GridItem(.flexible())]
        let two = [GridItem(.flexible()), GridItem(.flexible())]
        return columnLayout(geo, horizontalSizeClass) == .wide ? two : one
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView (.vertical) {
            // LazyVStack with all CollectionCard s
            LazyVGrid(columns: self.columns(geometry), alignment: .center, spacing: 0) {
                ForEach(allCollections.indices) { i in
                    NavigationLink(destination: PresetSelectionView(rootIsActive: $rootIsActive, collection: allCollections[i])) {
                        CollectionCardView(collection: allCollections[i], rotationDegrees: Double(10 - (20 * (i % 2))))
                            .padding(.horizontal)
                            .padding(.vertical, 7.5)
                            .animation(nil)
                            .shadow(radius: 10, x: 0, y: 10)
                    }
                    .isDetailLink(false)
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(UIDevice.current.userInterfaceIdiom == .phone)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Dismiss button
                    if (UIDevice.current.userInterfaceIdiom == .phone) {
                        PillButton(label: "Cancel") {
                            withAnimation {
                                rootIsActive = false
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            .animation(nil)
        }
        .padding(.bottom) // since we will ignore bottom safe area
        .edgesIgnoringSafeArea(.bottom) // hide background on home indicator
        }
    }
}
