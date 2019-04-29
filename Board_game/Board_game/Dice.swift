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
    var animatedDie: UIImage!
    
    override init() {
        number = 1
        curSide = sides[1]
        animatedDie = UIImage.animatedImage(with: sides as! [UIImage], duration: 1.0)
    }
    
    func roll () {
        number = Int.random(in: 1...6)
        curSide = sides[number-1]
    }

}
