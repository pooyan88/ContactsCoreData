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

    func createContact(newContact: ContactModel) async throws {
        let contact = ContactModel(context: context)
        contact.firstName = newContact.firstName
        contact.lastName = newContact.lastName
        contact.phoneNumber = newContact.phoneNumber
        contact.imageData = newContact.imageData
        contact.id = UUID()

        try await save()
    }

    func save() async throws {
        do {
            if context.hasChanges {
                try context.save()
            }
            print("Saved")
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }

    func deleteContact(contactID: UUID) async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ContactModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", contactID as CVarArg)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try await save()
    }
}
