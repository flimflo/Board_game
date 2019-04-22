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
    var levels = 5
    var cellsPerLevel = 5
    var cells = [Cell]()
    var buttonsAtCell = [Cell: [Button]]()
    var players = [Player]()
    var buttons = [Player: Button]()
    var isMapInitialized = false
    var gameOver = false
    var turnNumber = 0
    
    // MARK: - Views
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Layout constraints
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAttributes()
        mapScrollView.addSubview(contentView)
        displayPlayerName()
    }
    
    override func viewDidLayoutSubviews() {
        setMap()
        isMapInitialized = true
    }
    
    // MARK: - Game methods
    
    func initAttributes() {
        
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
        let numberOfChallenges = 11

        for indexCell in 0...numberOfChallenges {
            let randomNumber = Int.random(in: 1...totalCells - 1)
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
        self.title = "Turno de \(players[turnNumber].getName())"
    }
    
    func incrementTurn() {
        if turnNumber == players.count - 1 {
            turnNumber = 0
        } else {
            turnNumber += 1
        }
    }
    
    func isAChallenge(cellNumber: Int) {
        if cells[cellNumber].backgroundColor == UIColor.red {
            print("red challenge")
        } else if cells[cellNumber].backgroundColor == UIColor.green {
            print("green challenge")
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
    
    func movePlayer(player: Player, distance: Int) {
        
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
        
        isAChallenge(cellNumber: newPosition)
        
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
        let newFrame = CGRect(x: x, y: y, width: width, height: height)
        cells[index].frame = newFrame
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
        if motion == .motionShake && !gameOver {
            dice.roll()
            let player = players[turnNumber]
            print(dice.number)
            movePlayer(player: player, distance: dice.number)
        }
    }
    
    // MARK: - ScrollView Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }

}
