//
//  AddContactViewController.swift
//  Contact
//
//  Created by Pooyan J on 12/23/1403 AP.
//

import UIKit
import Combine

final class AddContactViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var viewModel: AddContactsViewModel?
    var cancellable: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupViews()
        setupBindings()
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()

        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
    }
}

// MARK: - Setup Functions
extension AddContactViewController {

    private func setupViewModel() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        viewModel = AddContactsViewModel(context: context)
    }

    private func setupViews() {
        setupImageView()
        setupBarButton()
        setupTextFields()
    }

    private func setupBarButton() {
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveContactTapped))
        navigationItem.rightBarButtonItem = barButton
    }

    private func setupImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }

    private func setupTextFields() {
        for textfield in [firstNameTextField, lastNameTextField, phoneNumberTextField] {
            textfield?.layer.cornerRadius = 8
            textfield?.layer.masksToBounds = true
            textfield?.layer.borderWidth = 1
            textfield?.layer.borderColor = UIColor.lightGray.cgColor
        }
        setupFirstNameTextField()
        setupLastNameTextField()
        setupPhoneNumberTextField()
    }

    private func setupFirstNameTextField() {
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.delegate = self
    }

    private func setupLastNameTextField() {
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.delegate = self
    }

    private func setupPhoneNumberTextField() {
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.delegate = self
    }
}

// MARK: - Bindings
extension AddContactViewController {

    private func setupBindings() {
        viewModel?.$isContactSaved.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] isContactSaved in
            if isContactSaved {
                self?.navigationController?.popViewController(animated: true)
            }
        }).store(in: &cancellable)
    }
}

// MARK: - Actions
extension AddContactViewController {

    @objc private func saveContactTapped() {
        Task { @MainActor in
           await viewModel?.saveContact()
        }
    }
}

// MARK: - Image Picker Functions
extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc private func profileImageTapped() {
        openImagePicker()
    }

    private func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            viewModel?.imageData = pickedImage.jpegData(compressionQuality: 0.8)  // Convert UIImage to Data
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - Other Delegates
extension AddContactViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == firstNameTextField {
            viewModel?.firstName = text
        } else if textField == lastNameTextField {
            viewModel?.lastName = text
        } else if textField == phoneNumberTextField {
            viewModel?.phoneNumber = text
        }
    }
}
