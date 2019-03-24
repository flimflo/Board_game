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
    @IBOutlet weak var tfAnswer: UITextField!
    @IBOutlet weak var btCheck: UIButton!
    
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
        buildProblem()
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
    
    @IBAction func checar(_ sender: UIButton) {
        if let ans = Int(tfAnswer.text!) {
            if ans == answer {
                //unwind? y mensaje de correcto
                let alerta = UIAlertController(title: "Respuesta Correcta", message: "mensaje de prueba", preferredStyle: .alert)
                let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alerta.addAction(accion)
                
                present(alerta, animated: true, completion: nil)
            }
            else {
                tfAnswer.shake()
            }
        }
        else {
            tfAnswer.shake()
        }
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

extension UITextField {
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
