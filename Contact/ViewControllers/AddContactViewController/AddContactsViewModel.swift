//
//  AddContactsViewModel.swift
//  Contact
//
//  Created by Pooyan J on 12/23/1403 AP.
//

import Foundation
import CoreData
import Combine

final class AddContactsViewModel: ObservableObject {

    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var imageData: Data?
    var context: NSManagedObjectContext
    var coreDataStack: CoreDataStack
    @Published var isContactSaved: Bool = false
    var contactToPass = PassthroughSubject<ContactModel, Never>()

    init(context: NSManagedObjectContext) {
        self.context = context
        self.coreDataStack = CoreDataStack(context: context)
    }
}

// MARK: - Action
extension AddContactsViewModel {

    func addContact() async {
        let contact = ContactModel(context: context)
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        contact.imageData = imageData
        contact.id = UUID()
        contactToPass.send(contact)
        do {
            try await coreDataStack.save()
            isContactSaved = true
        } catch {
            isContactSaved = false
            print(error)
        }
    }
}
