import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

class MotionEx2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lbBackground.layer.cornerRadius = 20
        AppUtility.lockOrientation(.portrait)
        tiempo_img = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MotionEx2ViewController.Rotar_img), userInfo: nil, repeats: true)
    }
    
    var motionManager = CMMotionManager()
    @IBOutlet weak var lbBackground: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var Counter: UILabel!
    @IBOutlet var viewController: UIView!
    
    var comenzargesto = true
    var time = 3
    var veces = 0
    var completar = Bool()
    var timer = Timer()
    var arrimg = [#imageLiteral(resourceName: "Motion_Ex2_2"),#imageLiteral(resourceName: "Motion_Ex2_1")]
    var tiempo_img = Timer()
    var index_img = 0
    var barrera = true
    
    @IBAction func Tap(_ sender: Any) {
        if(comenzargesto && barrera){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MotionEx2ViewController.action), userInfo: nil, repeats: true)
            Counter.text = "3"
            Counter.font = Counter.font.withSize(200)
        }
        barrera = false
    }
    
    @objc func action(){
        time -= 1
        Counter.text = String(time)
        
        if(time == 0 && comenzargesto){
            time = 10
            Counter.text = String(time)
            lbBackground.isHidden = true
            comenzargesto = false
        }else if(time == 0){
            Counter.isHidden = true
            timer.invalidate()
            comenzargesto = false
            Finalizar()
            time = -1 //pausar
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){(data, error) in
            if let mydata = data{
                if (mydata.acceleration.x > 1 && !self.comenzargesto){
                    self.veces += 1
                    self.viewController.backgroundColor = #colorLiteral(red: 0.353527844, green: 0.7516983747, blue: 0.2216552496, alpha: 1)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }else{
                    self.viewController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
        }
    }
    
    func Finalizar(){
        
        motionManager.stopAccelerometerUpdates()
        
        var respuesta = String()
        
        if(veces > 13){
            completar = true
        }else{
            completar = false
        }
        
        if(completar){
            respuesta = "¡Completaste el reto!"
            let systemSoundID: SystemSoundID = 1331
            AudioServicesPlaySystemSound (systemSoundID)
        }else{
            respuesta = "Intentalo de nuevo"
            let systemSoundID: SystemSoundID = 1324
            AudioServicesPlaySystemSound (systemSoundID)
        }
        let alerta = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        ///Font para el texto del titulo
        let messageFont = [kCTFontAttributeName: UIFont.systemFont(ofSize: 40)]
        let messageAttrString = NSMutableAttributedString(string: respuesta, attributes: messageFont as [NSAttributedString.Key : Any])
        alerta.setValue(messageAttrString, forKey: "attributedMessage")
        
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: {action in
            let navigationVC = self.presentingViewController as! UINavigationController
            let gameVC = navigationVC.topViewController as! GameViewController
            gameVC.isChallengeCompleted(self.completar)
            self.dismiss(animated: true, completion: nil)
        })
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    @objc func Rotar_img(){
        imgBackground.image = arrimg[index_img]
        index_img += 1
        if(index_img == 2){
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
