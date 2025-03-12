//
//  BaseViewController.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

class BaseViewController: UIViewController {

    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientView()
    }
}

// MARK: - Setup Views
extension BaseViewController {

    private func setupGradientView() {
        view.applyLightGradient(colors: [
            UIColor(hex: "#FFDEE9"), // Light Pink
            UIColor(hex: "#B5FFFC")  // Soft Cyan
        ])
    }
}
