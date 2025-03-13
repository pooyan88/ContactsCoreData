//
//  ContactsViewModel.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import Foundation
import UIKit
import Combine

final class ContactsViewModel {
    @Published var contacts = [ContactModel]()
    private var coreDataStack: CoreDataStack
    @Published var isLoading: Bool = false

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        Task { @MainActor in await getContacts()
        }
    }
}

// MARK: - Fetch
extension ContactsViewModel {

    private func getContacts() async {
        isLoading = true
        do {
            contacts = try await coreDataStack.fetch(ContactModel.self)
            isLoading = false
        } catch {
            isLoading = false
            print("Failed to get contacts")
        }
    }

    @MainActor
    func deleteContact(index: Int) async {
        let contact = contacts[index]
        guard let id = contact.id else { return }

        do {
            try await coreDataStack.deleteContact(contactID: id)
            contacts.remove(at: index)
        } catch {
            print("Error deleting contact: \(error)")
        }
    }
}
