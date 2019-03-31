//
//  ViewController.swift
//  Board_game
//
//  Created by Fernando Limón Flores on 3/23/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    var dice = Dice.init()
    var levels = 5
    var cellsPerLevel = 4
    var cells = [UIView]()
    var isMapInitialized = false
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setMap()
        isMapInitialized = true
    }
    
    // MARK: - Map creation methods
    
    func setView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, at index: Int) {
        
        let newFrame = CGRect(x: x, y: y, width: width, height: height)
        
        if !isMapInitialized {
            let cell = UIView()
            cell.frame = newFrame
            cell.setAttributes(labelText: String(index))
            cells.append(cell)
            view.addSubview(cell)
        } else {
            cells[index].frame = newFrame
            cells[index].setLabelPosition()
        }
    }
    
    func setMap() {
        let heightOfView = self.view.bounds.height
        let widthOfView = self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        let sizeOfCellSide = widthOfView /  CGFloat(cellsPerLevel)
        let startXPosition = self.view.safeAreaInsets.left
        let startYPosition = heightOfView - self.view.safeAreaInsets.bottom  - sizeOfCellSide
        
        var isCreatingPathToRightSide = true
        var currentYPosition = startYPosition
        var currentXPosition = startXPosition
        var cellNumber = 0
        
        for level in 0..<levels {
            for _ in 0..<cellsPerLevel {
                
                setView(x: currentXPosition, y: currentYPosition, width: sizeOfCellSide, height: sizeOfCellSide, at: cellNumber)
                cellNumber += 1
                
                currentXPosition = isCreatingPathToRightSide ? currentXPosition + sizeOfCellSide : currentXPosition - sizeOfCellSide
            }
            
            if level + 1 == levels { break }
            
            if isCreatingPathToRightSide {
                currentXPosition -= sizeOfCellSide
                isCreatingPathToRightSide = false
            } else {
                currentXPosition = startXPosition
                isCreatingPathToRightSide = true
            }
            
            //add the cell that connects each level
            currentYPosition -= sizeOfCellSide
            setView(x: currentXPosition, y: currentYPosition, width: sizeOfCellSide, height: sizeOfCellSide, at: cellNumber)
            
            cellNumber += 1
            currentYPosition -= sizeOfCellSide
        }
    }
    
    // MARK: - Motion methods
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            dice.roll()
            print(dice.number)
        }
    }

}

// MARK: - Extensions

extension UIView {
    func setAttributes(labelText: String) {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        let numberLabel = UILabel(frame: CGRect(x: self.frame.width / 2, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height))
        numberLabel.text = labelText
        numberLabel.textAlignment = .center
        self.addSubview(numberLabel)
        setLabelPosition()
    }
    
    func setLabelPosition() {
        self.subviews[0].center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
}
