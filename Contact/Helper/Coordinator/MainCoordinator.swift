//
//  MainCoordinator.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

final class MainCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startApp() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreData = CoreDataStack(context: context)
        Task { @MainActor in
            let contacts = try await coreData.fetch(ContactModel.self)
            let state: ContactsViewController.PageState = contacts.isEmpty ? .noContacts : .containsContracts
            showContactsViewController(pageState: state)
        }
    }
}

// MARK: - Navigating Functions
extension MainCoordinator {

    func showContactsViewController(pageState: ContactsViewController.PageState) {
        let vc = ContactsViewController.instantiate(for: .main)
        vc.pageState = pageState
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showAddContactViewController(onContactAdded: ((ContactModel) -> Void)?) {
        let vc = AddContactViewController.instantiate(for: .main)
        vc.coordinator = self
        vc.onContactAdded = onContactAdded
        navigationController.pushViewController(vc, animated: true)
    }
}
