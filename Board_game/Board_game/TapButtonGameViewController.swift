//
//  TapButtonGameViewController.swift
//  Board_game
//
//  Created by PO on 5/3/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class TapButtonGameViewController: UIViewController {

    var label = TopLabel()
    var gameStarted = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        gameStarted = false
        label.text = "Toque la mayor cantidad de fichas para ganar puntos"
        label.setAttributes()
        label.textColor = UIColor.blue
        label.layer.backgroundColor = UIColor.blue.cgColor
        view.addSubview(label)
        label.updateFrame()
        label.frame = CGRect(x: 30, y: 30, width: 500, height: 500)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
