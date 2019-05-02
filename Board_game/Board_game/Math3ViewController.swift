//
//  Math3ViewController.swift
//  Board-Game-S5
//
//  Created by Juan De Leon on 4/26/19.
//  Copyright © 2019 Juan De Leon. All rights reserved.
//

import UIKit

class Math3ViewController: UIViewController {
    
    @IBOutlet weak var lbInstructions: UILabel!
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var bt2: UIButton!
    @IBOutlet weak var bt3: UIButton!
    @IBOutlet weak var top1: UIButton!
    @IBOutlet weak var top2: UIButton!
    @IBOutlet weak var top3: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    let MIN = 0
    let MAX = 20
    
    var index = 0
    var ans = [Int]()
    var nums = [Int](repeating: 0, count: 3)
    var originalFrame: [CGRect]!
    var type: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //guardar posiciones de los botones
        setupGame()
    }
    
    override func viewDidLayoutSubviews() {
        let font: UIFont!
        if view.frame.width < 500 {
            font = UIFont(name: "AppleSDGothicNeo-Bold", size: 50)
        }
        else {
            font = UIFont(name: "AppleSDGothicNeo-Bold", size: 80)
        }
        bt1.titleLabel?.font = font
        bt2.titleLabel?.font = font
        bt3.titleLabel?.font = font
        top1.titleLabel?.font = font
        top2.titleLabel?.font = font
        top3.titleLabel?.font = font
    }
    
    func setupGame() {
        //crear juego random
        nums[0] = Int.random(in: MIN...MAX)
        repeat {
            nums[1] = Int.random(in: MIN...MAX)
        } while(nums[0] == nums[1])
        
        repeat {
            nums[2] = Int.random(in: MIN...MAX)
        } while(nums[0] == nums[2] || nums[1] == nums[2])
        
        bt1.setTitle(String(nums[0]), for: .normal)
        bt2.setTitle(String(nums[1]), for: .normal)
        bt3.setTitle(String(nums[2]), for: .normal)
        
        if (Bool.random()){
            type = "<"
            lbInstructions.text = "Ordena los números de\nMENOR a MAYOR"
        }
        else {
            type = ">"
            lbInstructions.text = "Ordena los números de\nMAYOR a MENOR"
        }
        
    }
    
    func checkOrder() {
        var color: UIColor!
        var alertTitle: String!
        var msg: String!
        //checks order of the numbers
        let wins = type == "<" && ans[0] < ans[1] && ans[1] < ans[2] ||
                   type == ">" && ans[0] > ans[1] && ans[1] > ans[2]
        if (wins) {
            alertTitle = "¡Respuesta Correcta!"
            msg = ""
            color = UIColor.init(red: 0.2, green: 0.6, blue: 0.01, alpha: 1.0)
        }
        else {
            color = .red
            alertTitle = "¡Respuesta Incorrecta!"
            msg = ""
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {_ in self.reset()})
        }
        
        top1.backgroundColor = color
        top2.backgroundColor = color
        top3.backgroundColor = color
        
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
    
    func reset() {
        viewContainer.shake()
        //regresar a las posiciones originales con animacion
        let color = UIColor(red:0.08, green:0.47, blue:0.96, alpha:1.0)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
            UIView.animate(withDuration: 1.5) {
                self.bt1.isHidden = false
                self.bt2.isHidden = false
                self.bt3.isHidden = false
                self.top1.isHidden = true
                self.top2.isHidden = true
                self.top3.isHidden = true
                self.top1.setTitle("", for: .normal)
                self.top2.setTitle("", for: .normal)
                self.top3.setTitle("", for: .normal)
                self.bt1.backgroundColor = color
                self.bt2.backgroundColor = color
                self.bt3.backgroundColor = color
            }
        })
        
        bt1.isEnabled = true
        bt2.isEnabled = true
        bt3.isEnabled = true
        top1.isEnabled = false
        top2.isEnabled = false
        top3.isEnabled = false
        
        ans.removeAll()
        index = 0
    }
    
    @IBAction func moveBt(_ sender: UIButton) {
        let num = Int((sender.titleLabel?.text)!)
        ans.append(num!)
        
        UIView.animate(withDuration: 1) {
            switch self.index {
            case 0:
                self.top1.setTitle(sender.titleLabel?.text, for: .normal)
                self.top1.isHidden = false
                sender.isHidden = true
            case 1:
                self.top2.setTitle(sender.titleLabel?.text, for: .normal)
                self.top2.isHidden = false
                sender.isHidden = true
            case 2:
                self.top3.setTitle(sender.titleLabel?.text, for: .normal)
                self.top3.isHidden = false
                sender.isHidden = true
            default: break
            }
        }
        sender.isEnabled = false
        index += 1;
        
        if(index == 3){
            checkOrder()
        }
    }
    
}
