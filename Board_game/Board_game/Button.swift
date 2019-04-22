//
//  Button.swift
//  Board_game
//
//  Created by PO on 4/17/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class Button: UIView {
    
    var arrivalNumber = Int()
    
    func setAttributes(color: UIColor) {
        self.backgroundColor = color
        self.layer.borderWidth = 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 4.0
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func decrementArrivalNumber() {
        arrivalNumber -= 1
    }
    
    func setArrivalNumber(arrivalNumber: Int) {
        self.arrivalNumber = arrivalNumber
    }
    
    func getArrivalNumber() -> Int{
        return arrivalNumber
    }
}
