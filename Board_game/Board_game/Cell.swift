//
//  Cell.swift
//  Board_game
//
//  Created by PO on 4/17/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class Cell: UIView {

    private var numberPlayers = Int()
    
    func setAttributes(number: Int) {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        let numberLabel = UILabel(frame: CGRect(x: self.frame.width / 2, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height))
        numberLabel.text = String(number)
        numberLabel.textAlignment = .center
        numberLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addSubview(numberLabel)
    }
    
    func numberOfPlayers() -> Int {
        return numberPlayers
    }
    
    func incrementNumberOfPlayers() {
        numberPlayers += 1
    }
    
    func decrementNumberOfPlayers() {
        numberPlayers -= 1
    }
    
    func setNumberOfPlayers(number: Int) {
        self.numberPlayers = number
    }
    
    func updateLabelPosition() {
       self.subviews[0].frame = CGRect(x: self.frame.width / 2, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height)
       self.subviews[0].center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    func getUpperLeftOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
    }
    
    func getUpperRightOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 2, y: self.frame.origin.y)
    }
    
    func getLowerLeftOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.width / 2)
    }
    
    func getLowerRightOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 2, y: self.frame.origin.y + self.frame.width / 2)
    }
    
    func getCenterOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 4, y: self.frame.origin.y + self.frame.width / 4)
    }
    
    func getLeftCenterOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.width / 4)
    }
    
    func getRightCenterOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 2, y: self.frame.origin.y + self.frame.width / 4)
    }
    
    func getUpperCenterOrigin() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 4, y: self.frame.origin.y)
    }

}
