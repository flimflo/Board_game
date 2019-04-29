//
//  StartViewController.swift
//  Board_game
//
//  Created by Fernando Limón Flores on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var actualcolors = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
    var colordidchange = true
    var Jugadoresact = Int()
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colbtColor[0].backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        colbtColor[1].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        colbtColor[2].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        colbtColor[3].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        for coltfNombre in coltfNombre{
            coltfNombre.layer.borderWidth = 3
            coltfNombre.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    @IBOutlet var stvJugadores: [UIView]!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet var coltfNombre: [UITextField]!
    
    @IBOutlet var colbtColor: [UIButton]!
    
    @IBAction func BTChangecolor(_ sender: UIButton) {

        if(sender.backgroundColor != #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)){
            actualcolors.append(sender.backgroundColor!)
        }
        sender.backgroundColor = actualcolors[0]
        actualcolors.remove(at: 0)
    }
    
    @IBAction func TFChangecolor(_ sender: UIButton) {
        for index in 0...3{
            coltfNombre[index].layer.borderColor = colbtColor![index].backgroundColor!.cgColor
        }
    }
    
    @IBAction func stepperAgregar(_ sender: UIStepper) {
        
        Jugadoresact = Int(sender.value)
        
        switch Jugadoresact{
        case 1:
            stackView.frame.size.height = 199
            stvJugadores[0].isHidden = false
            stvJugadores[1].isHidden = false
            stvJugadores[2].isHidden = true
            stvJugadores[3].isHidden = true
            coltfNombre[2].text = ""
            if(colordidchange){
                BTChangecolor(colbtColor[1])
            }
            
            if(colbtColor![2].backgroundColor! != #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)){
                actualcolors.append(colbtColor![2].backgroundColor!)
            }
            colbtColor![2].backgroundColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            coltfNombre[1].layer.borderColor = colbtColor![1].backgroundColor!.cgColor
            
        case 2:
            stackView.frame.size.height = 272
            stvJugadores[0].isHidden = false
            stvJugadores[1].isHidden = false
            stvJugadores[2].isHidden = false
            stvJugadores[3].isHidden = true
            coltfNombre[3].text = ""
            BTChangecolor(colbtColor[2])
            if(colbtColor![3].backgroundColor! != #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)){
                actualcolors.append(colbtColor![3].backgroundColor!)
            }
            colbtColor![3].backgroundColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            colordidchange = false
            coltfNombre[2].layer.borderColor = colbtColor![2].backgroundColor!.cgColor
            
        case 3:
            stackView.frame.size.height = 345
            stvJugadores[0].isHidden = false
            stvJugadores[1].isHidden = false
            stvJugadores[2].isHidden = false
            stvJugadores[3].isHidden = false
            BTChangecolor(colbtColor[3])
            coltfNombre[3].layer.borderColor = colbtColor![3].backgroundColor!.cgColor
            
        default:
            stackView.frame.size.height = 126
            stvJugadores[0].isHidden = false
            stvJugadores[1].isHidden = true
            stvJugadores[2].isHidden = true
            stvJugadores[3].isHidden = true
            coltfNombre[1].text = ""
            if(colbtColor![1].backgroundColor! != #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)){
                actualcolors.append(colbtColor![1].backgroundColor!)
            }
            colbtColor![1].backgroundColor! = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            colordidchange = true
            coltfNombre[0].layer.borderColor = colbtColor![0].backgroundColor!.cgColor
        }
    }
    
    @IBAction func btJugar(_ sender: UIButton) {
        
        players.removeAll()
        
        for i in 0...Jugadoresact{
            let tmpplayer = Player(name: coltfNombre[i].text!, color: colbtColor[i].backgroundColor!)
            players.append(tmpplayer)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let navigationVC = segue.destination as! UINavigationController
        let gameVC = navigationVC.topViewController as! GameViewController
        gameVC.players = players
    }
 
}
