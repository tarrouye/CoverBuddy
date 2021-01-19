//
//  LibraryStorage.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/12/21.
//

import Foundation
import CoreData

class LibraryStorage: NSObject, ObservableObject {
    static let shared = LibraryStorage(PersistenceController.shared.container.viewContext)
    
    @Published var library: [Cover] = []
    private let libController: NSFetchedResultsController<Cover>

    init(_ managedObjectContext: NSManagedObjectContext) {
        let request : NSFetchRequest<Cover> = Cover.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Cover.dateEdited, ascending: false)]

        libController = NSFetchedResultsController(fetchRequest: request,
                                                   managedObjectContext: managedObjectContext,
                                                   sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        libController.delegate = self

        do {
            try libController.performFetch()
            library = libController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch items from Core Data")
        }
    }
    
    func deleteItems(_ selections : [UUID]) {
        for s in selections {
            if let ind = self.library.firstIndex(where: { $0.id == s }) {
                PersistenceController.shared.container.viewContext.delete(self.library[ind])
            }
        }
        
        PersistenceController.shared.saveContainer()
    }
    
    func exportItems(_ selections : [UUID]) {
        for s in selections {
            if let ind = self.library.firstIndex(where: { $0.id == s }) {
                saveCoverImage(self.library[ind])
            }
        }
    }
}

extension LibraryStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let libItems = controller.fetchedObjects as? [Cover] else { return }
        
        library = libItems
    }
}
