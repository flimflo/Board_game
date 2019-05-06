import UIKit
import AudioToolbox

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
        } while(faux == answer && faux >= 0)
        
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
        var alertTitle: String!
        
        //checks if the text in the button matches the answer
        let wins = sender.titleLabel?.text == String(answer)
        if (wins){
            alertTitle = "¡Respuesta Correcta!"
            let systemSoundID: SystemSoundID = 1331
            AudioServicesPlaySystemSound (systemSoundID)
        }
            //shakes the button if theres no match
        else {
            sender.shake()
            alertTitle = "¡Respuesta Incorrecta!"
            let systemSoundID: SystemSoundID = 1324
            AudioServicesPlaySystemSound (systemSoundID)
        }
        
        let alerta = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        //font for title text
        let messageFont = [kCTFontAttributeName: UIFont.systemFont(ofSize: 40)]
        let messageAttrString = NSMutableAttributedString(string: alertTitle, attributes: messageFont as [NSAttributedString.Key : Any])
        alerta.setValue(messageAttrString, forKey: "attributedMessage")
        
        //alert button
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: {action in
            let navigationVC = self.presentingViewController as! UINavigationController
            let gameVC = navigationVC.topViewController as! GameViewController
            gameVC.isChallengeCompleted(wins)
            self.dismiss(animated: true, completion: nil)
        })
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.layoutIfNeeded()
    }
    
}
