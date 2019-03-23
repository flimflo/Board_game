//
//  Game.swift
//  Board_game
//
//  Created by PO on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    var players = [Player]()
    
    
    init(players: [Player]) {
        self.players = players
    }
    
    
}
