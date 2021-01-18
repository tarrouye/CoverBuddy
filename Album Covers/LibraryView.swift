//
//  LibraryView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI

struct LibraryView: View {
    // Get CoreData managedObjectContext
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @StateObject var libraryStore : LibraryStorage
    
    // Establish UI settings
    var columnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    var spacing : CGFloat = 25
    var rounding: CGFloat = 15
    
    // Vars to control various states
    @State var isSelecting : Bool = false
    @State var selections : [UUID] = []
    @State var showCollections : Bool = false
    @State var selectedNavigationItem : UUID?
    @State var collectionsIsActive : Bool = false
    
    func toggleEditMode() {
        if (self.isSelecting) {
            // clear selections
            selections.removeAll()
        }
        
        withAnimation(.easeOut(duration: 0.125)) {
            self.isSelecting.toggle()
        }
    }
    
    func deleteSelections() {
        withAnimation {
            libraryStore.deleteItems(selections)
        }
        
        toggleEditMode()
    }
    
    func exportSelections() {
        libraryStore.exportItems(selections)
        
        let alert = UIAlertController(title: "Designs Saved", message: "Your custom covers have been saved to your Photo Library!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first!.rootViewController!.present(alert, animated: true)
        
        toggleEditMode()
    }
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical) {
                LazyVGrid(columns: columnGrid, alignment: .center, spacing: spacing / 1.5) {
                    // Create new button
                    NavigationLink(destination: CollectionsView(rootIsActive: self.$collectionsIsActive), isActive: self.$collectionsIsActive) {
                        Color(UIColor.tertiarySystemGroupedBackground)
                            .frame(width: (UIScreen.main.bounds.width - spacing * 2) / 2, height: (UIScreen.main.bounds.width - spacing * 2) / 2)
                            .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 35, weight: .bold))
                            )
                            .opacity(self.isSelecting ? 0.4 : 1.0)
                    }
                    .isDetailLink(false)
                    .buttonStyle(PlainButtonStyle())
                    .disabled(self.isSelecting)
                    
                    
                    // Loop through library and display thumbnails
                    ForEach(libraryStore.library) { cover in
                        
                        if (cover.isFault) {
                            EmptyView()
                        } else {
                            ZStack {
                                // Empty Navlink to trigger programatically
                                NavigationLink(
                                    destination: CoverEditView(existingManagedObject: ObservedObject<Cover>(wrappedValue: cover), rootIsActive:
                                                Binding(get: {
                                                    return (selectedNavigationItem == cover.id)
                                                }, set: {
                                                    if !$0 {
                                                        selectedNavigationItem = nil
                                                    }
                                                })
                                    ),
                                    tag: cover.id!,
                                    selection: $selectedNavigationItem) {}.isDetailLink(false)
                                
                            
                                CoverThumbnail(cover: ObservedObject<Cover>(wrappedValue: cover), rounding: rounding, isSelecting: $isSelecting, isSelected: Binding(get: {
                                    if(cover.id != nil) {
                                        return self.selections.contains(cover.id!)
                                    }
                                    
                                    return false
                                }, set : {
                                    if (cover.id != nil) {
                                        if $0 {
                                            self.selections.append(cover.id!)
                                        } else {
                                            self.selections.removeAll(where: { $0 == cover.id! } )
                                        }
                                    }
                                }), navigationItem: $selectedNavigationItem)
                                    .frame(width: (UIScreen.main.bounds.width - spacing * 2) / 2, height: (UIScreen.main.bounds.width - spacing * 2) / 2)
                                    .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                            }
                        }
                    }
                }
                .padding(spacing / 2)
                .navigationTitle("My Designs")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        if (self.isSelecting) {
                            HStack {
                                PillButton(/*label: "Delete", */systemImage: "trash.fill") { //, bgCol: (self.selections.count > 0) ? Color.red : Color(UIColor.tertiarySystemGroupedBackground)) {
                                    self.deleteSelections()
                                }
                                
                                PillButton(/*label: "Export", */systemImage: "square.and.arrow.up.fill") { //, bgCol: (self.selections.count > 0) ? Color.blue : Color(UIColor.tertiarySystemGroupedBackground)) {
                                    self.exportSelections()
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // Edit button
                        PillButton(label: self.isSelecting ? "Done" : "Select", bgCol: self.isSelecting ? Color.blue : Color(UIColor.tertiarySystemGroupedBackground)) {
                            self.toggleEditMode()
                        }
                    }
                }
            }
            .padding(.vertical, (libraryStore.library.count < 6) ? 1 : 0) // fix for scrollview glitchy when not filling whole screen
            .padding(.bottom) // since we will ignore bottom safe area
            .edgesIgnoringSafeArea(.bottom) // hide background on home indicator
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
