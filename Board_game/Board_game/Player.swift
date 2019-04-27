//
//  Player.swift
//  Board_game
//
//  Created by PO on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name: String
    var position: Int
    var color: UIColor
    
    init(name: String, position: Int, color: UIColor) {
        self.name = name
        self.position = position
        self.color = color
    }
}
