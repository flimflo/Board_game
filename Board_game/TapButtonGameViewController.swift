import UIKit

class TapButtonGameViewController: UIViewController {
    
    var topLabel = TopLabel()
    let button = Button()
    var counter = Int()
    var gameStarted = Bool()
    var timer: Timer!
    var points = Int()
    @IBOutlet weak var startLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAttributes()
        view.addSubview(topLabel)
        view.addSubview(button)
    }
    
    func initAttributes() {
        topLabel.text = "Toque la mayor cantidad de fichas"
        topLabel.setAttributes()
        topLabel.layer.backgroundColor = UIColor.white.cgColor
        topLabel.textColor = UIColor.black
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.initGame))
        startLabel.addGestureRecognizer(tap)
        startLabel.isUserInteractionEnabled = true
        startLabel.font = startLabel.font.withSize(100)
        startLabel.adjustsFontSizeToFitWidth = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.addPoint))
        button.addGestureRecognizer(tap)
        let width = view.frame.width / 6
        button.frame.size = CGSize(width: width, height: width)
        button.setAttributes(color: UIColor.cyan)
        button.isHidden = true
        gameStarted = false
    }
    
    func displayButtonAtRandomPosition(){
        let upperLimitY = topLabel.frame.height + view.safeAreaInsets.top
        let lowerLimitY = view.frame.height - button.frame.width - view.safeAreaInsets.bottom
        let leftStart = view.safeAreaInsets.left
        let rightLimitX = view.frame.width - view.safeAreaInsets.right - button.frame.width
        
        let randomY = Int.random(in: Int(upperLimitY)...Int(lowerLimitY))
        let randomX = Int.random(in: Int(leftStart) ... Int(rightLimitX))
        
        button.frame.origin = CGPoint(x: randomX, y: randomY)
    }
    
    func startGame() {
        points = 0
        topLabel.text = "Puntos:\(points)"
        button.isHidden = false
        displayButtonAtRandomPosition()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.incrementCounter), userInfo: nil, repeats: true)
    }
    
    @objc func addPoint() {
        points += 1
        topLabel.text = "Puntos: \(points)"
        print(points)
        displayButtonAtRandomPosition()
    }
    
    
    @objc func incrementCounter() {
        counter += 1
        
        if counter == 10 {
            timer.invalidate()
            endGame()
        }
    }
    
    @objc func endGame() {
        
        var wins = false
        var alertTitle = String()
        
        if points >= 8 {
            wins = true
            alertTitle = "¡Completaste el reto!"
        } else {
            alertTitle = "Intentalo de nuevo"
        }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let messageFont = [kCTFontAttributeName: UIFont.systemFont(ofSize: 40)]
        let messageAttrString = NSMutableAttributedString(string: alertTitle, attributes: messageFont as [NSAttributedString.Key : Any])
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: {action in
            let navigationVC = self.presentingViewController as! UINavigationController
            let gameVC = navigationVC.topViewController as! GameViewController
            gameVC.isChallengeCompleted(wins)
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func initGame() {
        if !gameStarted {
            counter = 3
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayStartGameCounter), userInfo: nil, repeats: true)
        }
        gameStarted = true
    }
    
    @objc func displayStartGameCounter() {
        if counter < 4, counter > 0 {
            startLabel.font = startLabel.font.withSize(200)
            startLabel.text = String(counter)
        } else {
            startLabel.isHidden = true
            timer.invalidate()
            topLabel.setAttributes()
            counter = 0
            startGame()
        }
        counter -= 1
    }
    
    override func viewDidLayoutSubviews() {
        topLabel.updateFrame()
        topLabel.frame.origin.y = view.safeAreaInsets.top
    }
}
