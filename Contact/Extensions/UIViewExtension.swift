//
//  UIViewExtension.swift
//  Contact
//
//  Created by Pooyan J on 12/22/1403 AP.
//

import UIKit

extension UIView {
    func applyLightGradient(colors: [UIColor] = [UIColor(hex: "#FFDEE9"), UIColor(hex: "#B5FFFC")],
                            startPoint: CGPoint = CGPoint(x: 0, y: 0),
                            endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
