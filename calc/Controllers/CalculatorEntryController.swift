//
//  CalculatorEntryController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

class SpecialCharacterRules {
    private static var rules: [KeypadSpecial : SpecialCharacterRule] = [
        .decimal:.init(placement: .anywhere, representable: "."),
        .percentage:.init(placement: .end, representable: "%"),
        .power:.init(placement: .anywhere, representable: "^"),
        .sqrRoot:.init(placement: .start, representable: "√"),
    ]
    
    static func getRuleFor(_ character: KeypadSpecial) -> SpecialCharacterRule {
        return rules[character] ?? .init(placement: .anywhere, representable: "")
    }
    
    static func shouldAdhereToRule(wholeString: String) -> Bool {
        return false
    }
    
    struct SpecialCharacterRule {
        enum Placement {
            case anywhere
            case start
            case end
        }
        
        var placement: Placement
        var representable: String
    }
}

class CalculatorEntryController {
    /**
     Call before returning any value created below to check for input errors and remove leading zeros
     */
    static func prepareForFinalReturn(_ string: String) -> String {
        var index = 0
        var finalString = string
        let isNegativeString = (string.first == "-")
        if (isNegativeString) { finalString = String(finalString.dropFirst()) }
        
        while (finalString.first == "0" && index < string.count && string.count > 1) {
            finalString = String(finalString.dropFirst())
            index += 1
        }
        
        if (finalString.count == 0) { finalString = "0" }
        
        return ((isNegativeString) ? "-" : "") + finalString
    }

    /**
     Add special character
     */
    static func appendCharacter(character: KeypadSpecial, to current: String) -> String {
        if (current.count >= 8) { return current }
        
        let char = SpecialCharacterRules.getRuleFor(character) //specialCharacterList[character] ?? .init(placement: .anywhere, representable: "")
        
        if (current == "0" || current == "") {
            return "0"+char.representable
        } else {
            if (current.contains(char.representable)) {
                return CalculatorEntryController.prepareForFinalReturn(current)
            } else {
                if (char.placement == .start) {
                    return CalculatorEntryController.prepareForFinalReturn(char.representable + current)
                }
                
                return CalculatorEntryController.prepareForFinalReturn(current + char.representable)
            }
        }
    }
    
    /**
     Add character 'character' to current string and return the new value
     */
    static func appendCharacter(character: String, to current: String) -> String {
        if (current.count >= 8) { return current }
        
        if (current == "0" || current == "") {
            return character
        } else {
            return CalculatorEntryController.prepareForFinalReturn(current + character)
//            if (character == ".")
//                if (current.contains(".")) {
//                    return CalculatorEntryController.prepareForFinalRet2urn(current)
//                } else {
//                    return CalculatorEntryController.prepareForFinalReturn(current + ".")
//                }
//            } else {
//
//            }
        }
    }

    /**
     Remove the last character in currency
     (From the backsapce button or from the swipe back gesture)
     */
    static func removingLastCharacter(current: String) -> String {
        if (current.count <= 1) {
            return "0"
        } else {
            var newString = current
            if let lastIndex = current.lastIndex(of: current.last!) {
                newString.remove(at: lastIndex)
            }
            
            return CalculatorEntryController.prepareForFinalReturn(newString)
        }
    }

    /**
     Reverse the value for the current entry
     i.e.
     4 -> -4
     16 -> -16
     -42.4 -> 42.4
     */
    static func reverseCalculatorValue(current: String) -> String {
        var numberValue = current
        var wasNegative = false
        if (current.first == "-") {
            wasNegative = true
            numberValue = String(numberValue.dropFirst())
        }
        
        if (numberValue == "") { numberValue = "0" }
        
        return CalculatorEntryController.prepareForFinalReturn((wasNegative ? "" : "-") + numberValue)
    }
}
