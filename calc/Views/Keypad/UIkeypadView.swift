//
//  UIkeypadView.swift
//  calc
//
//  Created by Eliraz Atia on 30/03/2022.
//

import Foundation
import AVFoundation
import UIKit


/**
 The layout of the keypad buttons
 */
let keypadLabels: [[String]] = [
    ["0",".","ANS","<"],
    ["1","2","3","+"],
    ["4","5","6","-"],
    ["7","8","9","*"],
    ["THEME","CA","+/-","/"],
]


let iconConfiguration = UIImage.SymbolConfiguration(pointSize: Dimensions.keyFontsize.pointSize - 4, weight: .light)

/**
 If a key entered in the keypad label should use an icon instead of a UILabel than enter them in this list
 */
let keypadLabelIcons: [String:UIImage] = [
    "CA":UIImage(systemName: "scribble", withConfiguration: iconConfiguration)!,
    "THEME":UIImage(systemName: "ellipsis.circle", withConfiguration: iconConfiguration)!,
    "<":UIImage(systemName: "delete.backward", withConfiguration: iconConfiguration)!,
    "+":UIImage(systemName: "plus", withConfiguration: iconConfiguration)!,
    "-":UIImage(systemName: "minus", withConfiguration: iconConfiguration)!,
    "*":UIImage(systemName: "multiply", withConfiguration: iconConfiguration)!,
    "/":UIImage(systemName: "divide", withConfiguration: iconConfiguration)!,
    "+/-":UIImage(systemName: "plus.forwardslash.minus", withConfiguration: iconConfiguration)!
]


class UIkeypadView: UIView {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init() {
        super.init(frame: CGRect.zero)
        
        var previousAnchor: NSLayoutYAxisAnchor?
        
        var index = 0
        while (index < 5) {
            let row = UIKeypadRow(labels: keypadLabels[index], action: didPressKeyButton(action:), supersizedFirst: false)
            addSubview(row)
            row.translatesAutoresizingMaskIntoConstraints = false
            row.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Dimensions.keypadPadding).isActive = true
            row.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Dimensions.keypadPadding).isActive = true
            row.bottomAnchor.constraint(equalTo: previousAnchor ?? self.bottomAnchor, constant: (previousAnchor == nil) ? 0 : -Dimensions.keypadKeySpacing).isActive = true
            
            previousAnchor = row.topAnchor
            index += 1
        }
                
        self.topAnchor.constraint(equalTo: previousAnchor!, constant: 0).isActive = true
    }
    
    /**
     Called when a keypad button is pressed, check if the operation should do something other than enter a character to the current calculation row
     */
    func didPressKeyButton(action: String) {
        guard let number = NumberFormatter().number(from: action)?.intValue else {
            switch(action) {
            case "<":
                ViewController.controlDelegate.backspace()
                break
            case "CA":
                ViewController.controlDelegate.clear()
                break
            case "+/-":
                ViewController.controlDelegate.setValueForSelected(value: CalculatorEntryController.reverseCalculatorValue(current: ViewController.controlDelegate.selected().getRawValue()))
                break
            case "-":
                ViewController.controlDelegate.setOperationForSelected(operation: .minus)
                break
            case "+":
                ViewController.controlDelegate.setOperationForSelected(operation: .add)
                break
            case "*":
                ViewController.controlDelegate.setOperationForSelected(operation: .multiply)
                break
            case "/":
                ViewController.controlDelegate.setOperationForSelected(operation: .divide)
                break
            case "ANS":
                ViewController.controlDelegate.setAnswerToResult()
                break
            case "THEME":
                ViewController.interfaceDelegate.openViewModally(MenuViewController())//.openThemeSelector()
                break
            case ".":
                ViewController.controlDelegate.setValueForSelected(value: CalculatorEntryController.appendCharacter(character: ".", to: ViewController.controlDelegate.selected().getRawValue()))
            default:
                print("----NO ACTION----")
                break
            }
            
            return
        }
        
        ViewController.controlDelegate.setValueForSelected(value: CalculatorEntryController.appendCharacter(character: String(number), to: ViewController.controlDelegate.selected().getRawValue()))
        return
    }
}
