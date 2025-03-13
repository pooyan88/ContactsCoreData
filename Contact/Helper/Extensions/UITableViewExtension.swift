//
//  UITableViewExtension.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
}
