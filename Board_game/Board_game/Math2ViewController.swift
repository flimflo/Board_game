//
//  MathViewController.swift
//  Board_game_S5
//
//  Created by Juan De Leon on 4/18/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import AudioToolbox

class Math2ViewController: UIViewController {
    
    @IBOutlet weak var lbProblem: UILabel!
    @IBOutlet weak var btA: UIButton!
    @IBOutlet weak var btB: UIButton!
    @IBOutlet weak var btC: UIButton!
    
    let MIN = 0
    let MAX = 10
    let signs = ["+", "-", "x"]
    var a: Int!
    var b: Int!
    var sign: String!
    var problem: String!
    var answer: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates problem with positive answer
        repeat {
            buildProblem()
        } while (answer < 0)
        
        lbProblem.text = problem
    }
    
    func buildProblem() {
        a = Int.random(in: MIN...MAX)
        b = Int.random(in: MIN...MAX)
        sign = signs.randomElement();
        
        switch sign {
        case "+":
            answer = a + b
        case "-":
            answer = a - b
        case "x":
            answer = a * b
        default:
            break
        }
        
        problem = "\(String(a)) ? \(String(b)) = \(String(answer))"
    }
    
    @IBAction func checar(_ sender: UIButton) {
        var alertTitle: String!
        var msg: String!
        
        //checks if the text in the button matches the answer
        let wins = sender.titleLabel?.text == sign
        if (wins){
            alertTitle = "¡Respuesta Correcta!"
            msg = ""
            let systemSoundID: SystemSoundID = 1331
            AudioServicesPlaySystemSound (systemSoundID)
        }
            //shakes the button if theres no match
        else {
            sender.shake()
            alertTitle = "¡Respuesta Incorrecta!"
            msg = ""
            let systemSoundID: SystemSoundID = 1324
            AudioServicesPlaySystemSound (systemSoundID)
        }
        
        let alerta = UIAlertController(title: alertTitle, message: msg, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: {action in
            let navigationVC = self.presentingViewController as! UINavigationController
            let gameVC = navigationVC.topViewController as! GameViewController
            gameVC.isChallengeCompleted(wins)
            self.dismiss(animated: true, completion: nil)
        })
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
}
