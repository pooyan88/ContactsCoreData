//
//  UIViewControllerExtension.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

extension UIViewController {

    enum Storyboard: String {
        case main = "Main"
    }

    static var identifier: String {
        return String(describing: self)
    }

    static func instantiate(for storyboard: Storyboard) -> Self {
          let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
          return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
