//
//  ViewController.swift
//  Board_game
//
//  Created by Fernando Limón Flores on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var dice = Dice.init()
    var levels = 8
    var cellsPerLevel = 5
    var cells = [Cell]()
    var buttonsAtCell = [Cell: [Button]]()
    var players = [Player]()
    var buttons = [Player: Button]()
    var isMapInitialized = Bool()
    var gameOver = Bool()
    var turnNumber = Int()
    var isGreenChallenge = Bool()
    var alert = UIAlertController()
    var storyboardIdentifiers = ["Motion1", "Motion2", "Math1", "Math2", "Math3", "Swipe1"]
    var disableMovePlayer = false
    
    // MARK: - Views
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    
    // MARK: - Layout constraints
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //players.append(Player(name: "test", color: .blue))
        initAttributes()
        mapScrollView.addSubview(contentView)
        displayPlayerName()
        blurVisualEffectView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        setMap()
        setMenuFrame()
        isMapInitialized = true
    }
    
    // MARK: - Game methods
    
    func initAttributes() {
        
        //remove previous data if any
        buttonsAtCell.removeAll()
        buttons.removeAll()
        cells.removeAll()
        isMapInitialized = false
        gameOver = false
        turnNumber = 0
        
        for cell in contentView.subviews {
            cell.removeFromSuperview()
        }
        
        for player in players {
            player.setPosition(0)
        }
        
        //Create cells
        let totalCells = levels * cellsPerLevel + levels - 1
        for indexCell in 0..<totalCells{
            let cell = Cell()
            cell.setAttributes(number: indexCell)
            cells.append(cell)
            buttonsAtCell[cell] = [Button]()
            contentView.addSubview(cell)
        }
        
        //select cells with challenges
        let numberOfChallenges = totalCells / 2

        for indexCell in 0...numberOfChallenges {
            let randomNumber = Int.random(in: 1...totalCells - 2)
            if indexCell % 2 == 0 {
                cells[randomNumber].backgroundColor = UIColor.green
            } else {
                cells[randomNumber].backgroundColor = UIColor.red
            }
        }
        
        //create buttons
        for indexPlayer in 0..<players.count {
            let player = players[indexPlayer]
            let button = Button()
            button.setArrivalNumber(arrivalNumber: indexPlayer + 1)
            buttons[player] = button
            buttonsAtCell[cells[0]]!.append(button)
            cells[0].incrementNumberOfPlayers()
            contentView.addSubview(button)
        }
        
        displayPlayerName()
    }
    
    func displayPlayerName() {
        let player = players[turnNumber]
        let button = Button()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setAttributes(color: player.getColor())
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        navigationItem.title = "Turno de \(players[turnNumber].getName())"
    }
    
    func incrementTurn() {
        if turnNumber == players.count - 1 {
            turnNumber = 0
        } else {
            turnNumber += 1
        }
    }
    
    func isAChallenge(cellNumber: Int) {
        let randomNumber = Int.random(in: 0..<storyboardIdentifiers.count)
        let vcIdentifier = storyboardIdentifiers[randomNumber]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: vcIdentifier)
        if cells[cellNumber].backgroundColor == UIColor.red {
            isGreenChallenge = false
            self.present(vc!, animated: true, completion: nil)
        } else if cells[cellNumber].backgroundColor == UIColor.green {
            isGreenChallenge = true
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func isChallengeCompleted(_ completed: Bool) {
        
        let player = players[turnNumber]
        let distance = Int.random(in: 1...6)
        
        if completed, isGreenChallenge {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.movePlayer(player: player, distance: distance, challengesActivated: false)
            }
        } else if !completed, !isGreenChallenge {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.movePlayer(player: player, distance: -distance, challengesActivated: false)
            }
        }
        
    }
    
    //Removes a button from a cell's button list
    func removeButtonFromCell(cellNumber: Int, button: Button) {
        let cell = cells[cellNumber]
        var buttons = buttonsAtCell[cell]!
        buttons.remove(at: button.arrivalNumber - 1)
        cell.decrementNumberOfPlayers()
        buttonsAtCell[cell] = buttons
        for button in buttons {
            button.decrementArrivalNumber()
        }
    }
    
    //add a button to a cell's button list
    func addButtonAtCell(cellNumber: Int, button: Button) {
        let cell = cells[cellNumber]
        var buttons = buttonsAtCell[cell]!
        buttons.append(button)
        cell.incrementNumberOfPlayers()
        button.setArrivalNumber(arrivalNumber: cell.numberOfPlayers())
        buttonsAtCell[cell] = buttons
    }
    
    func movePlayer(player: Player, distance: Int, challengesActivated: Bool) {
        
        let previousPosition = player.getPosition()
        let playerButton = buttons[player]!
        
        let nextPosition = previousPosition + distance
        
        //remove button from previous cell
        removeButtonFromCell(cellNumber: previousPosition, button: playerButton)
        
        //update player position
        if nextPosition >= cells.count {
            let lastCell = cells.count - 1
            addButtonAtCell(cellNumber: lastCell, button: playerButton)
            updateButtonsViewAt(cellNumber: lastCell)
            removeButtonFromCell(cellNumber: lastCell, button: playerButton)
            let offset = (previousPosition + distance) % lastCell
            let backwardsDistance = lastCell - offset - player.getPosition()
            player.movePosition(By: backwardsDistance)
        } else if nextPosition < 0 {
            player.movePosition(By: -previousPosition)
        } else {
            player.movePosition(By: distance)
        }
        
        let newPosition = player.getPosition()
        
        //add button to the new cell
        addButtonAtCell(cellNumber: newPosition, button: playerButton)
        
        //update view at previous cell
        updateButtonsViewAt(cellNumber: previousPosition)
        
        //update view at new cell
        if nextPosition < cells.count  {
            updateButtonsViewAt(cellNumber: newPosition)
        } else {
            //if the position is out of bounds, wait until the button moves to the last cell
            //and then update to the new position
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateButtonsViewAt(cellNumber: newPosition)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if challengesActivated {
                self.isAChallenge(cellNumber: newPosition)
            }
            self.disableMovePlayer = false
        }
        
        if nextPosition == cells.count - 1 {
            gameOver = true
        } else {
            incrementTurn()
            displayPlayerName()
        }
    }
    
    //MARK: Map view methods
    
    func buttonFrameOriginPoint(cellNumber: Int, arrivalNumber: Int) -> CGPoint {
        switch cells[cellNumber].numberOfPlayers() {
        case 1:
            return cells[cellNumber].getCenterOrigin()
        case 2:
            if arrivalNumber == 1 {
                return cells[cellNumber].getRightCenterOrigin()
            } else {
                return cells[cellNumber].getLeftCenterOrigin()
            }
        case 3:
            if arrivalNumber == 1 {
                return cells[cellNumber].getLowerRightOrigin()
            } else if arrivalNumber == 2 {
                return cells[cellNumber].getLowerLeftOrigin()
            } else {
                return cells[cellNumber].getUpperCenterOrigin()
            }
        default:
            if arrivalNumber == 1 {
                return cells[cellNumber].getUpperRightOrigin()
            } else if arrivalNumber == 2 {
                return cells[cellNumber].getLowerRightOrigin()
            } else if arrivalNumber == 3{
                return cells[cellNumber].getLowerLeftOrigin()
            } else {
                return cells[cellNumber].getUpperLeftOrigin()
            }
        }
    }
    
    //Update the origin frame for each button in the cell's button list
    func updateButtonsViewAt(cellNumber nextCell: Int) {
        
        let destination = cells[nextCell]
        
        UIView.animate(withDuration: 0.5, animations: {
            let buttons = self.buttonsAtCell[destination]!
            
            for indexButton in 0..<buttons.count {
                let xDifference = self.buttonFrameOriginPoint(cellNumber: nextCell, arrivalNumber: indexButton).x - buttons[indexButton].frame.origin.x
                let yDifference = self.buttonFrameOriginPoint(cellNumber: nextCell, arrivalNumber: indexButton).y - buttons[indexButton].frame.origin.y
                buttons[indexButton].frame.origin.x += xDifference
                buttons[indexButton].frame.origin.y += yDifference
                
            }
        })
    }
    
    func setButtonsFrame(cellWidth: CGFloat) {
        for indexPlayer in 0..<players.count {
            let player = players[indexPlayer]
            let button = buttons[player]!
            let origin = buttonFrameOriginPoint(cellNumber: player.getPosition(), arrivalNumber: button.getArrivalNumber())
            let newFrame = CGRect(x: origin.x, y: origin.y, width: cellWidth / 2, height: cellWidth / 2)
            button.frame = newFrame
            button.updateCornerRadius()
            
            if !isMapInitialized {
                button.setAttributes(color: player.getColor())
                self.contentView.addSubview(button)
            }
        }
    }
    
    func setCellFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, at index: Int) {
        cells[index].frame = CGRect(x: x, y: y, width: width, height: height)
        cells[index].updateLabelPosition()
    }

    //Move the scroll view so it shows the bottom of the map first
    func setScrollViewOffset(height mapHeight: CGFloat) {
        let windowSize = UIScreen.main.bounds
        let topAreaHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0)
        let topOffset = mapScrollView.contentSize.height + topAreaHeight + getBottomSafeAreaInsets() - windowSize.height
        mapScrollView.contentOffset = CGPoint(x: 0, y: topOffset)
    }
    
    func updateContentViewHeight(newHeight: CGFloat) {
        contentViewHeightConstraint.constant = newHeight
        self.contentView.layoutIfNeeded()
        mapScrollView.contentSize = contentView.frame.size
    }
    
    func setMap() {
        
        //Set the width of each cell according to the width of the safe area
        let safeAreaWidth = self.view.bounds.width - getLeftSafeAreaInsets() - getRightSafeAreaInsets()
        let cellWidth = safeAreaWidth /  CGFloat(cellsPerLevel)
        
        let mapHeight = CGFloat(levels + levels - 1) * cellWidth
        
        updateContentViewHeight(newHeight: mapHeight)
        setScrollViewOffset(height: mapHeight)
        
        let startYPosition = mapHeight - contentView.safeAreaInsets.bottom - cellWidth
        let startXPosition = getLeftSafeAreaInsets() - getRightSafeAreaInsets()
        var isCreatingPathToRightSide = true
        var currentYPosition = startYPosition
        var currentXPosition = startXPosition
        var cellNumber = 0
        
        for level in 0..<levels {
            for _ in 0..<cellsPerLevel {
                setCellFrame(x: currentXPosition, y: currentYPosition, width: cellWidth, height: cellWidth, at: cellNumber)
                cellNumber += 1
                
                currentXPosition = isCreatingPathToRightSide ? currentXPosition + cellWidth : currentXPosition - cellWidth
            }
            
            if level + 1 == levels { break }
            
            if isCreatingPathToRightSide {
                currentXPosition -= cellWidth
                isCreatingPathToRightSide = false
            } else {
                currentXPosition = startXPosition
                isCreatingPathToRightSide = true
            }
            
            //add the cell that connects each level
            currentYPosition -= cellWidth
            setCellFrame(x: currentXPosition, y: currentYPosition, width: cellWidth, height: cellWidth, at: cellNumber)
            
            cellNumber += 1
            currentYPosition -= cellWidth
        }
        setButtonsFrame(cellWidth: cellWidth)
        
    }
    
    //MARK: - Menu methods
    @IBAction func optionsButtonPressed(_ sender: Any) {
        optionsButton.isEnabled = false
        disableMovePlayer = true
        blurVisualEffectView.isHidden = false
        menuView.alpha = 0
        view.addSubview(menuView)
        setMenuButtonsAttributes()
        UIView.animate(withDuration: 0.3) {
            self.blurVisualEffectView.alpha = 1
            self.menuView.alpha = 1
        }
        menuView.clipsToBounds = true
        optionsButton.isEnabled = false
    }
    
    func displayAlert(title: String, optionType: String) {
        alert = UIAlertController(title: title, message: "¿Quieres continuar?", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(action)
        
        action = UIAlertAction(title: "Continuar", style: .default, handler: { action in
            if optionType == "reset" {
                self.initAttributes()
                self.cancelButtonPressed(self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetGame(_ sender: Any) {
        displayAlert(title: "¿Estas seguro de reiniciar el juego?", optionType: "reset")
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        displayAlert(title: "¿Estas seguro de salir del juego?", optionType: "exit")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.menuView.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.menuView.removeFromSuperview()
        }
        optionsButton.isEnabled = true
        disableMovePlayer = false
    }
    
    func setMenuFrame() {
        menuView.frame.size = CGSize(width: view.frame.width * 0.8, height: view.frame.height * 0.6)
        menuView.center = view.center
        setMenuButtonsAttributes()
    }
    
    func setMenuButtonsAttributes() {
        let viewHeight = menuView.frame.height
        restartButton.setAttributes(Height: viewHeight)
        exitButton.setAttributes(Height: viewHeight)
        cancelButton.setAttributes(Height: viewHeight)
    }
    
    //MARK: Safe area insets methods
    
    func getLeftSafeAreaInsets() -> CGFloat {
        return self.view.safeAreaInsets.left
    }
    
    func getRightSafeAreaInsets() -> CGFloat {
        return self.view.safeAreaInsets.right
    }
    
    func getBottomSafeAreaInsets() -> CGFloat {
        return self.view.safeAreaInsets.bottom
    }
    
    // MARK: - Motion methods
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake, !gameOver, !disableMovePlayer {
            disableMovePlayer = true
            dice.roll()
            animateDie()
            let player = players[turnNumber]
            movePlayer(player: player, distance: dice.number, challengesActivated: true)
        }
    }
    
    // MARK: - ScrollView Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    // MARK: - Animation for dice roll
    func animateDie() {
        let width = self.view.bounds.width - getLeftSafeAreaInsets() - getRightSafeAreaInsets()
        let height = self.view.bounds.height
        let side = width/3
        let xPos = width/2 - side/2
        let yPos = height/2 - side/2
        print(width, height)
        let imgDie = UIImageView(frame: CGRect(x: xPos, y: yPos, width: side, height: side))
        view.addSubview(imgDie)
        imgDie.image = dice.animatedDie
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
            imgDie.image = self.dice.curSide
        })
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            imgDie.removeFromSuperview()
        })
        
    }

}

extension UIButton {
    func setAttributes(Height: CGFloat) {
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3.0
        self.titleLabel?.font = self.titleLabel?.font.withSize(getFontSize(height: Height))
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func getFontSize(height: CGFloat) -> CGFloat {
        if height < 250 {
            return 30
        } else if height < 500 {
            return 45
        }
        return 70
    }
}
