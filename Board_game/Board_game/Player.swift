import UIKit

class Player: NSObject {
    private var name: String
    private var position: Int
    private var color: UIColor
    
    func movePosition(By number: Int) {
        position += number
    }
    
    func setPosition(_ position: Int) {
        self.position = position
    }
    
    func getPosition() -> Int {
        return position
    }
    
    func getName() -> String {
        return name
    }
    
    func getColor() -> UIColor {
        return color
    }
    
    init(name: String, color: UIColor) {
        self.name = name
        self.position = 0
        self.color = color
    }
}
