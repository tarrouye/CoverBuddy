//
//  ContentView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Cover.id, ascending: true)],
        animation: .default)
    private var library: FetchedResults<Cover>

    var body: some View {
        NavigationView {
            List {
                ForEach(library) { item in
                    Text("Item at \(item.backgroundImgURL ?? "missing value")")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                #if os(iOS)
                HStack {
                    PillButton(systemImage: "plus") {
                        addItem()
                    }
                    
                EditButton()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color(UIColor.secondarySystemFill))
                    .foregroundColor(Color(UIColor.label))
                    .cornerRadius(15)
                }
                #endif
            }
            .navigationBarTitle("Covers")
        }
    }

    private func addItem() {
        withAnimation {
            // Create new item
            let coverItem = CoverFromProperties(allCollections[0].templates[Int.random(in: 0...10)])


            // save managedObjectContext
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { library[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
