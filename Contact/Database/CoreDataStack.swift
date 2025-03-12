//
//  CoreDataStack.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import Foundation
import CoreData

actor CoreDataStack {

    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - Functions
extension CoreDataStack {

    func fetch<T: NSManagedObject>(_ type: T.Type) async throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            return try context.fetch(request)
        } catch {
            print("fetch error: \(error)")
            return []
        }
    }

    func save() async throws {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }

    func deleteContact(contactID: UUID) async throws {
        let contacts = try await fetch(ContactModel.self)

        do {
            if let contactToDelete = contacts.first(where: { $0.id == contactID }) {
                context.delete(contactToDelete)
                try await save()
            }
        } catch {
            print("Failed to delete contact: \(error.localizedDescription)")
        }
    }
}
