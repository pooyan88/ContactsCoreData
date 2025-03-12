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
        let coreData = CoreDataStack()
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
        navigationController.pushViewController(vc, animated: true)
    }
}
