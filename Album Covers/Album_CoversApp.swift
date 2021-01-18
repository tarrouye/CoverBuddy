//
//  Album_CoversApp.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

import SwiftUI

@main
struct Album_CoversApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LibraryView(libraryStore: LibraryStorage.shared)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
