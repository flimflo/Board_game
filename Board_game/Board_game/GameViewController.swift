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
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    var inactivityTimer: Timer!
    var inactivityTimerCounter = Int()
    var imageShakeTimer: Timer!
    var imageShakeTimerCounter = Int()
    var diceView = UIImageView()
    let topLabel = TopLabel()
    let initShakeImageView = UIImageView()
    
    // MARK: - Layout constraints
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAttributes()
        initViews()
        displayPlayerName()
    }
    
    override func viewDidLayoutSubviews() {
        setMap()
        updateViewsFrame()
        if !isMapInitialized {
            displayShakePopUp()
        }
        isMapInitialized = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setInactivityTimer()
    }
    
    // MARK: - Initialize attributes
    func initViews() {
        mapScrollView.addSubview(contentView)
        topLabel.setAttributes()
        blurVisualEffectView.isHidden = true
        diceView.isHidden = true
        view.addSubview(diceView)
        view.addSubview(topLabel)
        view.addSubview(initShakeImageView)
    }
    
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
    
    // MARK: - Game methods

    func displayPlayerName() {
        let player = players[turnNumber]
        let button = Button()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setAttributes(color: player.getColor())
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        navigationItem.title = "Turno de \(players[turnNumber].getName())"
    }
    
    func incrementTurn() {
        
        if players[turnNumber].getPosition() == cells.count - 1 {
            gameOver = true
        } else {
            if turnNumber == players.count - 1 {
                turnNumber = 0
            } else {
                turnNumber += 1
            }
            displayPlayerName()
            disableMovePlayer = false
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
        } else {
            incrementTurn()
        }
    }
    
    func isChallengeCompleted(_ completed: Bool) {
        
        resetInactivityTimer()
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
        incrementTurn()
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
        
        if challengesActivated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isAChallenge(cellNumber: newPosition)
            }
        }
    }
    
    func updateViewsFrame() {
        topLabel.frame = CGRect(x: view.frame.width / 8, y: view.frame.height / 6, width: view.frame.width * 0.8, height: view.frame.height * 0.2)
        initShakeImageView.frame = CGRect(x: topLabel.frame.origin.x, y: topLabel.frame.origin.y + topLabel.frame.height + 20, width: topLabel.frame.width, height: view.frame.height * 0.5 )
        menuView.frame.size = CGSize(width: view.frame.width * 0.8, height: view.frame.height * 0.6)
        menuView.center = view.center
    }
    
    //MARK: Pop Up methods
    
    func displayTopLabel(text: String, textColor: UIColor, backgroundColor: UIColor) {
        topLabel.text = text
        topLabel.layer.backgroundColor = backgroundColor.cgColor
        topLabel.isHidden = false
    }
    
    func hideTopLabel() {
        topLabel.isHidden = true
    }
    
    func displayShakePopUp() {
        displayTopLabel(text: "Agite el dispositivo para lanzar el dado", textColor: .white, backgroundColor: .blue)
        changeShakeImage()
        setImageShakeTimer()
        initShakeImageView .contentMode = .scaleAspectFit
        initShakeImageView.isHidden = false
        blurVisualEffectView.isHidden = false
        blurVisualEffectView.alpha = 0.3
    }
    
    func hideShakePopUp() {
        blurVisualEffectView.alpha = 0
        blurVisualEffectView.isHidden = true
        hideTopLabel()
        initShakeImageView.isHidden = true
        blurVisualEffectView.alpha = 0
        imageShakeTimer.invalidate()
        imageShakeTimerCounter = 0
    }
    
    func displayOptionsMenu() {
        view.addSubview(menuView)
        hideShakePopUp()
        optionsButton.isEnabled = false
        disableMovePlayer = true
        blurVisualEffectView.isHidden = false
        menuView.alpha = 0
        setMenuButtonsAttributes()
        UIView.animate(withDuration: 0.3) {
            self.blurVisualEffectView.alpha = 1
            self.menuView.alpha = 1
        }
        menuView.clipsToBounds = true
        optionsButton.isEnabled = false
    }
    
    func hideOptionsMenu() {
        UIView.animate(withDuration: 0.3) {
            self.menuView.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.menuView.removeFromSuperview()
        }
        optionsButton.isEnabled = true
        disableMovePlayer = false
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
        displayOptionsMenu()
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
        hideOptionsMenu()
    }
    
    func setMenuButtonsAttributes() {
        let viewHeight = menuView.frame.height
        restartButton.setAttributes(Height: viewHeight)
        exitButton.setAttributes(Height: viewHeight)
        cancelButton.setAttributes(Height: viewHeight)
        creditsButton.setAttributes(Height: viewHeight)
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
            resetInactivityTimer()
            disableMovePlayer = true
            dice.roll()
            animateDie()
            let player = players[turnNumber]
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                self.movePlayer(player: player, distance: self.dice.number, challengesActivated: true)
            }
        }
    }
    
    // MARK: - ScrollView Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetY =  max(mapScrollView.bounds.width - mapScrollView.contentSize.width * 0.5, self.view.frame.width / 4)
        let offsetX = self.view.frame.width / 8
        mapScrollView.contentInset = UIEdgeInsets(top: offsetX, left: offsetY, bottom: offsetX, right: offsetY)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        resetInactivityTimer()
    }
    
    // MARK: - Timer
    func setInactivityTimer() {
        inactivityTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementInactivityTimer), userInfo: nil, repeats: true)
    }
    
    @objc func incrementInactivityTimer() {
        inactivityTimerCounter += 1
        
        if inactivityTimerCounter == 25 {
            displayShakePopUp()
        }
    }
    
    func resetInactivityTimer(){
        inactivityTimerCounter = 0
        hideShakePopUp()
    }
    
    func setImageShakeTimer() {
        imageShakeTimerCounter = 0
        imageShakeTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(changeShakeImage), userInfo: nil, repeats: true)
    }
    
    @objc func changeShakeImage() {
        let imageName = ["Motion_Ex2_1", "Motion_Ex2_2"]
        if imageShakeTimerCounter % 2 == 0 {
            initShakeImageView.image = UIImage(named: imageName[0])
        } else{
            initShakeImageView.image = UIImage(named: imageName[1])
        }
        imageShakeTimerCounter += 1
    }
    
    // MARK: - Animation for dice roll
    
    func animateDie() {
        let width = self.view.bounds.width - getLeftSafeAreaInsets() - getRightSafeAreaInsets()
        let height = self.view.bounds.height
        let side = width/3
        let xPos = width/2 - side/2
        let yPos = height/2 - side/2
        print(width, height)
        diceView.frame = CGRect(x: xPos, y: yPos, width: side, height: side)
        diceView.isHidden = false
        diceView.image = dice.animatedDie
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.diceView.image = self.dice.curSide
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.diceView.isHidden = true
        }
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
