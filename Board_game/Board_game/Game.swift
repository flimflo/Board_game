import UIKit

class Game: NSObject {
    
    var players = [Player]()
    
    
    init(players: [Player]) {
        self.players = players
    }
    
    
}
