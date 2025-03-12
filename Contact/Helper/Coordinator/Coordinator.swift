//
//  Coordinator.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func startApp()
}
