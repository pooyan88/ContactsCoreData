//
//  ViewController.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit
import Combine

class ContactsViewController: BaseViewController {

    enum PageState { case noContacts, containsContracts }

    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var pageState: PageState!
    var viewModel: ContactsViewModel?
    var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupViews()
    }
}

// MARK: - Setup Functions
extension ContactsViewController {

    private func setupViewModel() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataStack = CoreDataStack(context: context)
        viewModel = ContactsViewModel(coreDataStack: coreDataStack)
    }

    private func setupViews() {
        setupTableView()
        setupBarButton()
    }

    private func setupTableView() {
        contactsTableView.register(ContactTableViewCell.self)
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
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

// MARK: - Bindings
extension ContactsViewController {

    private func setupBindings() {
        bindTableViewReload()
    }

    private func bindTableViewReload() {
        viewModel?.$contacts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contactsTableView.reloadData()
            }
            .store(in: &cancellable)
    }
}

// MARK: - Actions
extension ContactsViewController {

    @objc func barButtonDidTapped() {
        coordinator?.showAddContactViewController(onContactAdded: { [weak self] newContact in
            guard let self else { return }
            viewModel?.contacts.append(newContact)
            updatePageState(contacts: viewModel?.contacts)
        })
    }

    func updatePageState(contacts: [ContactModel]?) {
        if let contacts {
            pageState = contacts.isEmpty ? .noContacts : .containsContracts
        }
    }
}

// MARK: - TableView Functions
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contacts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let contact = viewModel?.contacts[indexPath.row]
        let imageData = contact?.imageData ?? Data()
        let config: ContactTableViewCell.Config = ContactTableViewCell.Config(imageData: imageData, firstName: contact?.firstName ?? "", lastName: contact?.lastName ?? "", phoneNumber: contact?.phoneNumber ?? "")
        cell.setup(config: config)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }

            Task { @MainActor in
                await self.viewModel?.deleteContact(index: indexPath.row)
                if indexPath.row < self.viewModel?.contacts.count ?? 0 {
                    self.viewModel?.contacts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    completionHandler(true)
                }
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

