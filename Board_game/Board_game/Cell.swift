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
        addLabel(number: number)
    }
    
    func addLabel(number: Int) {
        let numberLabel = UILabel(frame: CGRect(x: self.frame.width / 4, y: self.frame.width / 4, width: self.frame.width - self.frame.width / 4, height: self.frame.width - self.frame.width / 4))
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
       let numberLabel = self.subviews[0] as! UILabel
        numberLabel.frame = CGRect(x: 0, y: self.frame.width / 4, width: self.frame.width - self.frame.width / 4, height: self.frame.width - self.frame.width / 4)
        numberLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let fontSize = getFontSize()
        numberLabel.font = numberLabel.font.withSize(fontSize)
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
    
    private func getFontSize() -> CGFloat {
        if self.frame.width < 100.0 {
            return 30
        } else {
            return 65
        }
    }

}
