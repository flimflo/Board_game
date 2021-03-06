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
        
        var playerAns = Int()
        switch sender.tag {
        case 1:
            playerAns = a + b
        case 2:
            playerAns = a - b
        case 3:
            playerAns = a * b
        default:
            break
        }
        
        let wins = (answer == playerAns)
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
