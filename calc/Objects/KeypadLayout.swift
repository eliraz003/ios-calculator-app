//
//  KeypadLayout.swift
//  calc
//
//  Created by Eliraz Atia on 25/06/2022.
//

import Foundation
import UIKit

/**
 Rules used to determain action by special characters
 */
struct SpecialCharacterRule {
    enum Placement {
        case anywhere
        case start
        case end
    }
    
    var placement: Placement
    var representable: String
    var togglable: Bool = true
    var perform: SpecialCharacterPerformer?
}



/**
 Possible actions that can be called using the keypad
 */
enum KeypadAction: String {
    case openMenu
    case answer
    case backspace
    case clear
}

/**
 Special characters that can be created using the keypad
 */
enum KeypadSpecial: String {
    case decimal
    case plusMinus
    
    case fraction
    
    // POTENTIAL
    case pi
    case sqrRoot
    case power
    case log
    case percentage
    case trig_sin
    case trig_cos
    case trig_tan
}

typealias SpecialCharacterPerformer = (Double?, Double?) -> (Double?, Error?)

private func ksR(_ val: Double? , err: Error?) -> (Double?, Error?) { return (val, err) }

enum UserEntryError: Error {
    case MissingValueA
    case MissingValueB
    case ValueANotAllowed
    case ValueBNotAllowed
    
    case InfiniteResult
}

extension KeypadSpecial {
    static var rules: [KeypadSpecial : SpecialCharacterRule] = [
        .decimal:.init(placement: .anywhere, representable: ".", togglable: false, perform: nil),
        .plusMinus:.init(placement: .start, representable: "-", togglable: true, perform: {(a,b) in
            return ksR(-(b ?? 0), err: nil)
        }),
        .power:.init(placement: .anywhere, representable: "^", togglable: false, perform: {(a,b) in
            return ksR(pow(a ?? 0, b ?? 1), err: nil)
        }),
        .sqrRoot:.init(placement: .anywhere, representable: "√", togglable: true, perform: {(a,b) in
            return ksR((a ?? 1) * sqrt(b ?? 0), err: nil)
        }),
        .fraction:.init(placement: .anywhere, representable: "/", togglable: false, perform: {(a,b) in
            return ksR((a ?? 0) / (b ?? 0), err: nil)
        }),
        .pi:.init(placement: .anywhere, representable: "π", togglable: false, perform: {(a,b) in
            print("a", "b", a, b)
            if (b != nil) { return ksR(nil, err: UserEntryError.ValueBNotAllowed) }
            return ksR(((a ?? 1) * Double.pi), err: nil)
        }),
        .trig_tan:.init(placement: .anywhere, representable: "tan", togglable: false, perform: {(a,b) in
            return ksR(tan((Double.pi / 180) * (a ?? 1)), err: nil)
        }),
        .trig_cos:.init(placement: .anywhere, representable: "cos", togglable: false, perform: {(a,b) in
            return ksR(cos((Double.pi / 180) * (a ?? 1)), err: nil)
        }),
        .trig_sin:.init(placement: .anywhere, representable: "sin", togglable: false, perform: {(a,b) in
            return ksR(sin((Double.pi / 180) * (a ?? 1)), err: nil)
        }),
    ]
    
    static func getRuleFor(_ character: String) -> SpecialCharacterRule? {
        return rules.first(where: { return $0.value.representable == character })?.value
    }
        
    func rule() -> SpecialCharacterRule {
        return KeypadSpecial.rules[self] ?? .init(placement: .anywhere, representable: "", perform: nil)
    }
}

/**
 Possible operations
 */
enum KeypadOperation: String {
    case plus
    case minus
    case multiply
    case divide
}

/**
 Generic type of interaction
 */
enum KeypadInteraction {
    case empty
    case number(number: String)
    case operation(operation: KeypadOperation)
    case action(action: KeypadAction)
    case special(special: KeypadSpecial)
}

extension KeypadInteraction {
    func accessibilityLabel() -> String {
        switch(self) {
        case .number(let number):
            return number
        case .special(let special):
            return special.rawValue
        case .operation(let operation):
            return operation.rawValue
        case .action(let action):
            return action.rawValue
        case .empty:
            return ""
        }
    }
}

/**
 Extend the KeypadInteraction enum to provide additional helpers
 */
extension KeypadInteraction {
    /**
    Get the ColorController name for the given interaction to properly style the keypad
     */
    func colorControllerPattern() -> (String, (UIColor) -> UIColor) {
        func returnEmptyPatternHandler(_ val: String) -> (String, (UIColor) -> UIColor) { return (val, { return $0 }) }
        
        switch(self) {
        case .number(_):
            return returnEmptyPatternHandler(ColorController.StandardKeyBackground)
        case .special(let special):
            if (special == .plusMinus) { return returnEmptyPatternHandler(ColorController.OperationKeyBackground) }
            return returnEmptyPatternHandler(ColorController.StandardKeyBackground)
        case .empty:
            return (ColorController.StandardKeyBackground, { return $0.withAlphaComponent(0.3) })
        default:
            return returnEmptyPatternHandler(ColorController.OperationKeyBackground)
        }
    }
    
    /**
    Get the renderer for the view (Icon or label)
     */
    func getRenderer() -> UIView {
        switch(self) {
        case .number(let number):
            return UIKeypadButtonLabel(text: number)
        case .special(let special):
            switch(special) {
                case .decimal: return UIKeypadButtonLabel(text: ".")
                case .plusMinus: return UIKeypadButtonIcon(icon: UIImage(systemName: "plus.forwardslash.minus", withConfiguration: iconConfiguration)!)
                
                case .pi: return UIKeypadButtonLabel(text: "π")
                case .sqrRoot: return UIKeypadButtonIcon(icon: UIImage(systemName: "x.squareroot", withConfiguration: iconConfiguration)!)
                case .power: return UIKeypadButtonIcon(icon: UIImage(systemName: "textformat.superscript", withConfiguration: iconConfiguration)!)
                
                case .fraction: return UIKeypadButtonIcon(icon: UIImage(systemName: "line.diagonal", withConfiguration: iconConfiguration)!)
                case .percentage: return UIKeypadButtonIcon(icon: UIImage(systemName: "percent", withConfiguration: iconConfiguration)!)
                case .log: return UIKeypadButtonIcon(icon: UIImage(systemName: "chart.line.uptrend.xyaxis", withConfiguration: iconConfiguration)!)
                
                case .trig_tan: return UIKeypadButtonLabel(text: "tan", useMonoFont: true)
                case .trig_cos: return UIKeypadButtonLabel(text: "cos", useMonoFont: true)
                case .trig_sin: return UIKeypadButtonLabel(text: "sin", useMonoFont: true)
            }
        case .operation(let operation):
            switch(operation) {
                case .divide: return UIKeypadButtonIcon(icon: UIImage(systemName: "divide", withConfiguration: iconConfiguration)!)
                case .multiply: return UIKeypadButtonIcon(icon: UIImage(systemName: "multiply", withConfiguration: iconConfiguration)!)
                case .minus: return UIKeypadButtonIcon(icon: UIImage(systemName: "minus", withConfiguration: iconConfiguration)!)
                case .plus: return UIKeypadButtonIcon(icon: UIImage(systemName: "plus", withConfiguration: iconConfiguration)!)
            }
        case .action(let action):
            switch(action) {
                case .backspace: return UIKeypadButtonIcon(icon: UIImage(systemName: "delete.backward", withConfiguration: iconConfiguration)!)
                case .clear: return UIKeypadButtonIcon(icon: UIImage(systemName: "scribble", withConfiguration: iconConfiguration)!)
                case .openMenu: return UIKeypadButtonIcon(icon: UIImage(systemName: "ellipsis.circle", withConfiguration: iconConfiguration)!)
                case .answer: return UIKeypadButtonLabel(text: "ANS", useMonoFont: true)
            }
        default:
            return UIView()
        }
    }
}


class KeypadLayout {
    /**
     A keypad the provides advanced actions
     */
    static var Special: KeypadLayout = KeypadLayout().row([
        .empty,
        .empty,
        .empty,
        .empty
    ]).row([
        .special(special: .sqrRoot),
        .special(special: .power),
        .special(special: .pi),
        .empty
    ]).row([
        .special(special: .trig_tan),
        .special(special: .trig_cos),
        .special(special: .trig_tan),
        .empty
    ]).row([
        .special(special: .log),
        .special(special: .percentage),
        .special(special: .fraction),
        .empty
    ]).row([
        .action(action: .openMenu),
        .action(action: .clear),
        .special(special: .plusMinus),
        .empty
    ])
    
    /**
    A keypad that is numerical only
     */
    static var NumericalOnly: KeypadLayout = KeypadLayout()
    
    /**
    The standard keypad that includes the numric keypad, operartions, and actions
     */
    static var Standard: KeypadLayout = KeypadLayout().row([
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
        .special(special: .plusMinus),
        .operation(operation: .divide)
    ])
    
    private var rows: [[KeypadInteraction]] = []
    
    @discardableResult func row(_ items: [KeypadInteraction]) -> KeypadLayout {
        rows.append(items)
        return self
    }
    
    func row(at: Int) -> [KeypadInteraction] { return rows[at] }
    
    func numberOfRows() -> Int { return rows.count }
}
