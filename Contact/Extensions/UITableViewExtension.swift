//
//  UITableViewExtension.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

extension UITableView {

    func register(_ cellType: UITableViewCell) {
        register(UINib(nibName: cellType.identifier, bundle: nil), forCellReuseIdentifier: cellType.identifier)
    }
}
