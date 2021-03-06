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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @StateObject var libraryStore : LibraryStorage
    
    // Establish UI settings
    var spacing : CGFloat = 25
    var rounding: CGFloat = 15
    
    // Vars to control various states
    @State var isSelecting : Bool = false
    @State var selections : [UUID] = []
    @State var showCollections : Bool = false
    @State var selectedNavigationItem : UUID?
    @State var collectionsIsActive : Bool = false
    @State var showingExportInstructions : Bool = false
    
    func numColumns(_ geo : GeometryProxy) -> Int {
        return columnLayout(geo, horizontalSizeClass) == .wide ? 3 : 2
    }
    
    func columns(_ geo : GeometryProxy) -> [GridItem] {
        let three = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        let two = [GridItem(.flexible()), GridItem(.flexible())]
        return columnLayout(geo, horizontalSizeClass) == .wide ? three : two
    }
    
    func thumbnailSize(_ geo : GeometryProxy) -> CGFloat {
        return (geo.size.width - (spacing * CGFloat(self.numColumns(geo)))) / CGFloat(self.numColumns(geo))
    }
    
    func toggleEditMode() {
        if (self.isSelecting) {
            // clear selections
            selections.removeAll()
        }
        
        withAnimation(.easeOut(duration: 0.125)) {
            self.isSelecting.toggle()
        }
    }
    
    func deleteItems(_ items : [UUID]) {
        withAnimation {
            libraryStore.deleteItems(items)
        }
    }
    
    func deleteSelections() {
        deleteItems(selections)
        
        toggleEditMode()
    }
    
    func exportItems(_ items : [UUID]) {
        if !libraryStore.exportItems(items) { ImageSaver.shared.latestSaveSuceeded = false }
    
        self.showingExportInstructions = true
    }
    
    func exportSelections() {
        if (!showingExportInstructions && selections.count > 0) {
            exportItems(selections)
            
            toggleEditMode()
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
            ZStack {
                // Empty Navlink to trigger programatically for instructions view
                NavigationLink(destination: SetPlaylistInstructionsView(rootIsActive: self.$showingExportInstructions), isActive: self.$showingExportInstructions) {}
                .isDetailLink(false)
                .buttonStyle(PlainButtonStyle())
                
            
                ScrollView (.vertical) {
                    LazyVGrid(columns: self.columns(geometry), alignment: .center, spacing: spacing / 1.5) {
                        // Create new button
                        NavigationLink(destination: CollectionsView(rootIsActive: self.$collectionsIsActive), isActive: self.$collectionsIsActive) {
                            Color(UIColor.tertiarySystemGroupedBackground)
                                .frame(width: thumbnailSize(geometry), height: thumbnailSize(geometry))
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
                                    
                                    if (!cover.isFault) {
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
                                        .frame(width: thumbnailSize(geometry), height: thumbnailSize(geometry))
                                        .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                                        .contextMenu {
                                            Button(action: {
                                                self.exportItems([cover.id!])
                                            }) {
                                                Label("Export", systemImage: "square.and.arrow.up.fill")
                                            }
                                            
                                            Button(action: {
                                                self.deleteItems([cover.id!])
                                            }) {
                                                Label("Delete", systemImage: "trash.fill")
                                            }
                                        }
                                    }
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
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
