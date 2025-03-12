//
//  ViewController.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

class ContactsViewController: BaseViewController {

    enum PageState { case noContacts, containsContracts }

    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var pageState: PageState!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupViews()
    }
}

// MARK: - Setup Functions
extension ContactsViewController {

    private func setupViewModel() {

    }

    private func setupViews() {
        setupTableView()
        setupBarButton()
    }

    private func setupTableView() {
        contactsTableView.backgroundColor = .clear
        contactsTableView.backgroundView = pageState == .noContacts ? createNoContactsView() : nil
        contactsTableView.tableHeaderView = createTableHeaderView()
    }

    private func createNoContactsView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "Nothing to show"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let containerView = UIView()
        containerView.addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        return containerView
    }

    private func createTableHeaderView() -> UIView {
        let headerLabel = UILabel()
        headerLabel.text = "Contacts"
        headerLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: contactsTableView.frame.width, height: 60))
        headerView.backgroundColor = .clear
        headerView.addSubview(headerLabel)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }

    private func setupBarButton() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(barButtonDidTapped))
        navigationItem.rightBarButtonItem = barButton
    }
}

// MARK: - Actions
extension ContactsViewController {

    @objc func barButtonDidTapped() {
        print("tapped")
    }
}
