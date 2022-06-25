//
//  UIkeypadView.swift
//  calc
//
//  Created by Eliraz Atia on 30/03/2022.
//

import Foundation
import AVFoundation
import UIKit



enum KeypadAction {
    case openMenu
    case answer
    case plusMinus
    case backspace
    case clear
}

enum KeypadSpecial {
    case decimal
}

enum KeypadOperation {
    case plus
    case minus
    case multiply
    case divide
}

enum KeypadInteraction {
    case number(number: String)
    case operation(operation: KeypadOperation)
    case action(action: KeypadAction)
    case special(special: KeypadSpecial)
}

extension KeypadInteraction {
    func colorControllerPattern() -> String {
        switch(self) {
        case .number(_):
            return ColorController.StandardKeyBackground
        case .special(_):
            return ColorController.StandardKeyBackground
        default:
            return ColorController.OperationKeyBackground
        }
    }
    
    func getRenderer() -> UIView {
        switch(self) {
        case .number(let number):
            return UIKeypadButtonLabel(text: number)
        case .special(let special):
            if (special == .decimal) { return UIKeypadButtonLabel(text: ".") }
            return UIView()
        case .operation(let operation):
            switch(operation) {
                case .divide: return UIKeypadButtonIcon(icon: UIImage(systemName: "divide", withConfiguration: iconConfiguration)!)
                case .multiply: return UIKeypadButtonIcon(icon: UIImage(systemName: "multiply", withConfiguration: iconConfiguration)!)
                case .minus: return UIKeypadButtonIcon(icon: UIImage(systemName: "plus", withConfiguration: iconConfiguration)!)
                case .plus: return UIKeypadButtonIcon(icon: UIImage(systemName: "minus", withConfiguration: iconConfiguration)!)
            }
        case .action(let action):
            switch(action) {
                case .backspace: return UIKeypadButtonIcon(icon: UIImage(systemName: "delete.backward", withConfiguration: iconConfiguration)!)
                case .plusMinus: return UIKeypadButtonIcon(icon: UIImage(systemName: "plus.forwardslash.minus", withConfiguration: iconConfiguration)!)
                case .clear: return UIKeypadButtonIcon(icon: UIImage(systemName: "scribble", withConfiguration: iconConfiguration)!)
                case .openMenu: return UIKeypadButtonIcon(icon: UIImage(systemName: "ellipsis.circle", withConfiguration: iconConfiguration)!)
                case .answer: return UIKeypadButtonLabel(text: "ANS")
            }
        }
    }
}


class KeypadLayout {
    static var Special: KeypadLayout = KeypadLayout()
    static var NumericalOnly: KeypadLayout = KeypadLayout()
    
    static var Standard: KeypadLayout = {
        return KeypadLayout().row([
            .number(number: "0"),
            .special(special: .decimal),
            .action(action: .answer),
            .action(action: .backspace)
        ]).row([
            .number(number: "1"),
            .number(number: "2"),
            .number(number: "3"),
            .operation(operation: .plus)
        ]).row([
            .number(number: "4"),
            .number(number: "5"),
            .number(number: "6"),
            .operation(operation: .minus)
        ]).row([
            .number(number: "7"),
            .number(number: "8"),
            .number(number: "9"),
            .operation(operation: .multiply)
        ]).row([
            .action(action: .openMenu),
            .action(action: .clear),
            .action(action: .plusMinus),
            .operation(operation: .divide)
        ])
    }()
    
    private var rows: [[KeypadInteraction]] = []
    
    @discardableResult func row(_ items: [KeypadInteraction]) -> KeypadLayout {
        rows.append(items)
        return self
    }
    
    func row(at: Int) -> [KeypadInteraction] { return rows[at] }
    
    func numberOfRows() -> Int { return rows.count }
}

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
    init(layout: KeypadLayout) {
        super.init(frame: CGRect.zero)
        
        var previousAnchor: NSLayoutYAxisAnchor?
            
        var index = 0
        while (index < layout.numberOfRows()) {
            let row = UIKeypadRow(actions: layout.row(at: index), { interaction in
                print("DID CLICK")
            }) //UIKeypadRow(labels: keypadLabels[index], action: didPressKeyButton(action:), supersizedFirst: false)
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
