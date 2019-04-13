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
    var levels = 10
    var cellsPerLevel = 5
    var cells = [UIView]()
    var isMapInitialized = false
    
    // MARK: - Views
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Layout constraints
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScrollView.addSubview(contentView)
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
            contentView.addSubview(cell)
        } else {
            cells[index].frame = newFrame
            cells[index].setLabelPosition()
        }
    }
    
    func setMap() {
        
        let leftSafeAreaInsets = self.view.safeAreaInsets.left
        let rightSafeAreaInsets = self.view.safeAreaInsets.right
        let bottomSafeAreaInsets = self.view.safeAreaInsets.bottom
        
        //Set the width of each cell according to the width of the safe area
        let widthOfView = self.view.bounds.width - leftSafeAreaInsets - rightSafeAreaInsets
        let widthOfCell = widthOfView /  CGFloat(cellsPerLevel)
        
        //Update the height of the content view
        let mapHeight = CGFloat(levels + levels - 1) * widthOfCell
        heightConstraint.constant = mapHeight
        self.contentView.layoutIfNeeded()
        
        //Change the content view origin at Y position so the scroll view
        //shows first the bottom of the map
        let windowSize = UIScreen.main.bounds
        let difference = abs(mapHeight - windowSize.height)
        contentView.frame.origin.y -= difference
        mapScrollView.contentSize = contentView.frame.size
    
        let topAreaHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0)
        
        
        let offset = mapScrollView.contentSize.height + topAreaHeight + bottomSafeAreaInsets - windowSize.height
        mapScrollView.contentOffset = CGPoint(x: 0, y: offset)
        
        
        let startYPosition = mapHeight - contentView.safeAreaInsets.bottom - widthOfCell
        let startXPosition = leftSafeAreaInsets - rightSafeAreaInsets
        var isCreatingPathToRightSide = true
        var currentYPosition = startYPosition
        var currentXPosition = startXPosition
        var cellNumber = 0
                
        for level in 0..<levels {
            for _ in 0..<cellsPerLevel {
                
                setView(x: currentXPosition, y: currentYPosition, width: widthOfCell, height: widthOfCell, at: cellNumber)
                cellNumber += 1
                
                currentXPosition = isCreatingPathToRightSide ? currentXPosition + widthOfCell : currentXPosition - widthOfCell
            }
            
            if level + 1 == levels { break }
            
            if isCreatingPathToRightSide {
                currentXPosition -= widthOfCell
                isCreatingPathToRightSide = false
            } else {
                currentXPosition = startXPosition
                isCreatingPathToRightSide = true
            }
            
            //add the cell that connects each level
            currentYPosition -= widthOfCell
            setView(x: currentXPosition, y: currentYPosition, width: widthOfCell, height: widthOfCell, at: cellNumber)
            
            cellNumber += 1
            currentYPosition -= widthOfCell
        }
    }
    
    // MARK: - Motion methods
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            dice.roll()
            print(dice.number)
        }
    }
    
    // MARK: - ScrollView Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }

}

// MARK: - Extensions

extension UIView {
    func setAttributes(labelText: String) {
        
        //add background and border attributes
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        
        //add number label and it's attributes
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
