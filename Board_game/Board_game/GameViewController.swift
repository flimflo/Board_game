//
//  ViewController.swift
//  Board_game
//
//  Created by Fernando Limón Flores on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var dice = Dice.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            dice.roll()
            print(dice.number)
        }
    }

}

