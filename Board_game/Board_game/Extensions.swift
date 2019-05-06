//
//  Extensions.swift
//  Board_game
//
//  Created by Juan De Leon on 5/6/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

//give format to a UIbutton, and adjust text size
extension UIButton {
    func setAttributes(Height: CGFloat) {
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3.0
        self.titleLabel?.font = self.titleLabel?.font.withSize(getFontSize(height: Height))
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func getFontSize(height: CGFloat) -> CGFloat {
        if height < 250 {
            return 30
        } else if height < 500 {
            return 45
        }
        return 70
    }
}

//shake a view
extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
