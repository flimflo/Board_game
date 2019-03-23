//
//  Dice.swift
//  Board_game
//
//  Created by Juan De Leon on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class Dice: NSObject {
    var number: Int!
    var curSide: UIImage!
    var sides = [UIImage(named: "dice1"), UIImage(named: "dice2"), UIImage(named: "dice3"),
                 UIImage(named: "dice4"), UIImage(named: "dice5"), UIImage(named: "dice6")]
    
    override init() {
        number = 1
        curSide = sides[1]
    }
    
    func roll () {
        number = Int.random(in: 1...6)
        curSide = sides[number-1]
    }

}
