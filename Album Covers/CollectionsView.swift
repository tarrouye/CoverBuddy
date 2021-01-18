//
//  CollectionsView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
            view.backgroundColor = .clear
            view.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct CollectionImage : View {
    @Binding var collection : Collection!
    
    var body : some View {
        VStack {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
            ForEach(collection.templates, id: \.backgroundImgURL) { props in
                CoverPreview(withProperties: props)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        
        Spacer()
        }
    }
    
}

struct CollectionCard : View {
    @State var collection : Collection!
    
    var rotationDegrees : Double
    
    var body: some View {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                
                //if (collection.allImg != nil) {
                    Image("combined-album-cover-collection-\(collection.title.lowercased())")
                        .resizable()
                        .scaledToFit()
                        .offset(x: 0, y: 25)
                        .rotationEffect(.degrees(rotationDegrees))
                        .scaleEffect(1.55)
                //}
                
                /*CollectionImage(collection: $collection)
                    .offset(x: 0, y: 25)
                    .rotationEffect(.degrees(rotationDegrees))
                    //.scaleEffect(1.55)*/
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
