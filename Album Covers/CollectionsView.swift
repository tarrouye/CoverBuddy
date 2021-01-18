//
//  CollectionsView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI

struct CollectionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var rootIsActive : Bool
    
    var body: some View {
        ScrollView (.vertical) {
            // LazyVStack with all CollectionCard s
            LazyVStack(alignment: .center, spacing: 0) {
                ForEach(allCollections.indices) { i in
                    NavigationLink(destination: PresetSelectionView(rootIsActive: $rootIsActive, collection: allCollections[i])) {
                        CollectionCard(collection: allCollections[i], rotationDegrees: Double(10 - (20 * (i % 2))))
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
        //.padding(.vertical, 1) // fix for scrollview glitchy when not filling whole screen
        .padding(.bottom) // since we will ignore bottom safe area
        .edgesIgnoringSafeArea(.bottom) // hide background on home indicator
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
           Text("Hello World")
        }
    }
}
