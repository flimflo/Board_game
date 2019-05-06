import UIKit

class TopLabel: UILabel {

    func setAttributes() {
        self.isHidden = false
        self.font = self.font.withSize(40)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.layer.backgroundColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 20.0
        self.textColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4.0
        self.adjustsFontSizeToFitWidth = true
    }
    
    func updateFrame() {
        self.frame = CGRect(x: self.superview!.frame.width / 8, y: self.superview!.frame.height / 6, width: self.superview!.frame.width - self.superview!.frame.width / 4, height: self.superview!.frame.height * 0.2)
    }
 

}
