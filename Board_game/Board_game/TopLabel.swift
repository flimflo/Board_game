//
//  TopLabel.swift
//  Board_game
//
//  Created by PO on 5/3/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class TopLabel: UILabel {

    func setAttributes() {
        self.isHidden = true
        self.font = self.font.withSize(40)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.layer.backgroundColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 20.0
        self.textColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4.0
        self.adjustsFontSizeToFitWidth = true
    }
 

}
