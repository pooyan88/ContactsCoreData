//
//  ContactTableViewCell.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    struct Config {
        var imageData: Data?
        var firstName: String
        var lastName: String
        var phoneNumber: String
    }

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
}

// MARK: - Setup Functions
extension ContactTableViewCell {

    func setup(config: Config) {
        setupProfileImageView(imageData: config.imageData)
        setupLabels(firstName: config.firstName, lastName: config.lastName, phoneNumber: config.phoneNumber)
    }

    private func setupProfileImageView(imageData: Data?) {
        guard let imageData else { return }
        profileImageView.image = UIImage(data: imageData)
    }

    private func setupLabels(firstName: String, lastName: String, phoneNumber: String) {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        phoneNumberLabel.text = phoneNumber
    }
}
