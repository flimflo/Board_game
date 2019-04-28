//
//  MathViewController.swift
//  Board_game
//
//  Created by Juan De Leon on 3/24/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class MathViewController: UIViewController {
    
    @IBOutlet weak var lbProblem: UILabel!
    @IBOutlet weak var btA: UIButton!
    @IBOutlet weak var btB: UIButton!
    @IBOutlet weak var lbInstructions: UILabel!
    
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
        btA.titleLabel?.adjustsFontSizeToFitWidth = true
        btA.titleLabel?.lineBreakMode = .byClipping
        //crea problema sin resultado negativo
        repeat {
            buildProblem()
        } while (answer < 0)
        
        setOptions()
        
        lbProblem.text = problem
    }
    
    func buildProblem() {
        a = Int.random(in: MIN...MAX)
        b = Int.random(in: MIN...MAX)
        sign = signs.randomElement();
        
        problem = "\(String(a)) "
        problem += sign
        problem += " \(String(b)) = ?"
        
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
    }
    
    func setOptions() {
        //random int similar to answer
        var faux = Int()
        repeat {
            faux = answer + Int.random(in: -10...10)
        } while(faux == answer && faux > 0)
        
        //sets the correct answer on a random button
        if (Bool.random()) {
            btA.setTitle(String(answer), for: .normal)
            btB.setTitle(String(faux), for: .normal)
        }
        else {
            btB.setTitle(String(answer), for: .normal)
            btA.setTitle(String(faux), for: .normal)
        }
    }
    
    @IBAction func checar(_ sender: UIButton) {
        //checks if the text in the button matches the answer
        if (sender.titleLabel?.text == String(answer)){
            let alerta = UIAlertController(title: "Respuesta Correcta", message: "mensaje de prueba", preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alerta.addAction(accion)
            
            present(alerta, animated: true, completion: nil)
        }
            //shakes the button if theres no match
        else {
            sender.shake()
        }
        
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.layoutIfNeeded()
    }
    
}

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
