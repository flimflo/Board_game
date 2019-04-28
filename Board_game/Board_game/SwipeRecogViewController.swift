//
//  MotionEx1ViewController.swift
//  Board_game
//
//  Created by Fernando Limón Flores on 4/4/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class SwipeRecogViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbBackground.layer.cornerRadius = 20
        AppUtility.lockOrientation(.portrait)
        tiempo_img = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SwipeRecogViewController.Rotar_img), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var lbBackground: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var Counter: UILabel!
    @IBOutlet var viewController: UIView!
    
    var comenzargesto = true
    var time = 3
    var veces = 0
    var completar = Bool()
    var timer = Timer()
    var arrimg = [#imageLiteral(resourceName: "dice1"),#imageLiteral(resourceName: "dice2"),#imageLiteral(resourceName: "dice3")]
    var tiempo_img = Timer()
    var index_img = 0
    var mydirection = [(#imageLiteral(resourceName: "Left"),UISwipeGestureRecognizer.Direction.left),(#imageLiteral(resourceName: "Down"),UISwipeGestureRecognizer.Direction.down),(#imageLiteral(resourceName: "Right"),UISwipeGestureRecognizer.Direction.right),(#imageLiteral(resourceName: "Up"),UISwipeGestureRecognizer.Direction.up)]
    var tapbarrer = true
    
    @IBAction func Tap(_ sender: Any) {
        if(comenzargesto && tapbarrer){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SwipeRecogViewController.action), userInfo: nil, repeats: true)
            Counter.isHidden = false
        }
        Counter.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tapbarrer = false
    }
    
    @objc func action(){
        
        time -= 1
        
        Counter.text = String(time)
        
        if(time == 0 && comenzargesto){
            time = 16
            tiempo_img.invalidate()
            imgBackground.image = mydirection[0].0
            veces = 0
            comenzargesto = false
        }else if(time == 0){
            Counter.isHidden = true
            timer.invalidate()
            comenzargesto = false
            Finalizar()
            time = -1 //pausar
            lbBackground.isHidden = true
            imgBackground.isHidden = true
        }
    }
    
    @IBAction func Gesture(_ sender: UISwipeGestureRecognizer) {
        
        let actual = veces
        
        if(!comenzargesto){
            
            switch(sender.direction){
            case UISwipeGestureRecognizer.Direction.left:
                swipe_detect(Gesture: UISwipeGestureRecognizer.Direction.left)
                
            case UISwipeGestureRecognizer.Direction.down:
                swipe_detect(Gesture: UISwipeGestureRecognizer.Direction.down)
            case UISwipeGestureRecognizer.Direction.right:
                swipe_detect(Gesture: UISwipeGestureRecognizer.Direction.right)
            case UISwipeGestureRecognizer.Direction.up:
                swipe_detect(Gesture: UISwipeGestureRecognizer.Direction.up)
            default:
                print("")
            }
        }
        
        if(veces > actual){
            let systemSoundID: SystemSoundID = 1052
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func swipe_detect(Gesture: UISwipeGestureRecognizer.Direction){
        if(mydirection[0].1 == Gesture){
            veces+=1
            mydirection.shuffle()
            imgBackground.image = mydirection[0].0
            viewController.isUserInteractionEnabled = false
            imgBackground.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.imgBackground.isHidden = false
                self.viewController.isUserInteractionEnabled = true
            }
        }else{
            AudioServicesPlaySystemSound(1053)
        }
    }
    
    func Finalizar(){
        
        var respuesta = String()
        
        if(veces > 10){
            completar = true
        }else{
            completar = false
        }
        
        if(completar){
            respuesta = "Felicidades!!! Completaste el reto"
            let systemSoundID: SystemSoundID = 1331
            AudioServicesPlaySystemSound (systemSoundID)
        }else{
            respuesta = "Intentalo de nuevo"
            let systemSoundID: SystemSoundID = 1324
            AudioServicesPlaySystemSound (systemSoundID)
        }
        let alerta = UIAlertController(title: respuesta, message: "mensaje de prueba", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    @objc func Rotar_img(){
        
        imgBackground.image = arrimg[index_img]
        index_img += 1
        if(index_img == 3){
            index_img = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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

