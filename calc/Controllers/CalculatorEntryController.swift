//
//  CalculatorEntryController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

extension RangeReplaceableCollection {
    func splice(range: Range<Int>) -> [Element] where Index == Int {
        var current: [Element] = []
        var i = range.lowerBound
        while (i <= range.upperBound) {
            print("IS COUNT LARGER", self.count > i)
            if (i <= self.count-1) { current.append(self[i]) }
            

            i += 1
        }
        
        return current
    }
}

typealias SpecialCharacterPerformer = (Double, Double) -> Double

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



class CalculatorEntryController {
    private static var rules: [KeypadSpecial : SpecialCharacterRule] = [
        .decimal:.init(placement: .anywhere, representable: ".", togglable: false, perform: nil),
        .plusMinus:.init(placement: .start, representable: "-", togglable: true, perform: nil),
        .power:.init(placement: .anywhere, representable: "^", togglable: false, perform: {(a,b) in return pow(a, b) }),
        .sqrRoot:.init(placement: .start, representable: "√", togglable: true, perform: {(a,b) in return sqrt(a)})
    ]
    
    static func getRuleFor(_ character: KeypadSpecial) -> SpecialCharacterRule {
        return rules[character] ?? .init(placement: .anywhere, representable: "", perform: nil)
    }

    static func getRuleFor(_ character: String) -> SpecialCharacterRule? {
        return rules.first(where: { return $0.value.representable == character })?.value
    }

    
    static func shouldAdhereToRule(wholeString: String) -> [String:SpecialCharacterRule.Placement] {
        var current: [String : SpecialCharacterRule.Placement] = [:]
        rules.forEach({ rule in
            if (rule.value.placement == .anywhere) { return }
            if (wholeString.contains(rule.value.representable)) {
                current[rule.value.representable] = rule.value.placement
            }
        })
        
        return current
    }
    
    
    
    static func getComponentsOfEntry(entry: String) -> [String] {
        var components: [String] = []
        var isLastEntrySpecial = false
        for char in entry {
            if let rule = getRuleFor(String(char)), rule.perform != nil {
                components.append(String(char))
                isLastEntrySpecial = true
            } else {
                if (components.count == 0 || isLastEntrySpecial) { components.append("") }
                
                components[components.count - 1].append(String(char))
                isLastEntrySpecial = false
            }
        }
        
        if (components.count == 0) { return [""] }
        return components
    }
    
    static func renderedValue(entry: String) -> Double {
        let components = getComponentsOfEntry(entry: entry)
        
        func toNumber(value: String) -> Double {
            let formatter = NumberFormatter()
            return Double(truncating: formatter.number(from: value) ?? 0)
        }
        
        if (components.count == 1) {
            return toNumber(value: components[0])
        } else {
            print("========")
            func evaluateOperation(array: [String], holdingValue: Double, callOperation: SpecialCharacterPerformer?) -> Double {
                if (array.count == 0) { return 0 }
                if (array.count == 1) { return toNumber(value: array[0]) }
                    
                if let rule0 = getRuleFor(array[0]) {
                    let result = evaluateOperation(array: array.splice(range: 1..<components.count), holdingValue: 0, callOperation: rule0.perform)
                    print("RESULT WHERE 0 IS RULE", result)
                    let handledResult = rule0.perform?(result, 1) ?? 0
                    return handledResult
                } else if let rule1 = getRuleFor(array[1])  {
                    let result = evaluateOperation(array: array.splice(range: 2..<components.count), holdingValue: 0, callOperation: rule1.perform)
                    print("RESULT WHERE 1 IS RULE", result, toNumber(value: array[0]))
                    let handledResult = rule1.perform?(toNumber(value: array[0]), result) ?? toNumber(value: array[0])
                    return handledResult
                }

                return 0
            }
            
            return evaluateOperation(array: components, holdingValue: 0, callOperation: { (a,b) in
                return a
            })
            
//            func evaluateOperation(before: [String], after: [String]) -> NSNumber {
                // pass operation
                // call evaluate operation on after strings
//                return 0
//            }
            
            
//            if let rule0 = getRuleFor(components[0]) {
//                let result = evaluateOperation(before: [], after: components.splice(range: 1..<components.count))
//                print("RESULT WHERE 0 IS RULE", result)
//            } else if let rule1 = getRuleFor(components[1])  {
//                print("RESULT WHERE 1 IS RULE", 0)
//            }
//
//            return 0
            
//            var isSustaining = false
//            var i = 0
//            while (i < components.count && !isSustaining) {
//                if let isRule = getRuleFor(components[i]) {
//                    isSustaining = true
//                }
//
//                i += 1
//            }
//
//
//            for component in components {
//                if let rule = getRuleFor(component) {
//
//                } else {
//
//                }
//            }
        }
//        print("COMPONENTS", getComponentsOfEntry(entry: entry))
        
    }
    
    
    
    /**
     Call before returning any value created below to check for input errors and remove leading zeros
     */
    static func prepareForFinalReturn(_ string: String) -> String {
        var index = 0
        var finalString = string
        
        /** Call SpecialCharacterRules.shouldAdhereToRule to determain what parts of the current input are special characters */
        let toAdhere = shouldAdhereToRule(wholeString: finalString)
        toAdhere.forEach({ val in
            /** remove all special characters */
            finalString = finalString.replacingOccurrences(of: val.key, with: "")
        })
      
        /** Remove leading 0's in the current input */
        while (finalString.first == "0" && index < string.count && string.count > 1) {
            finalString = String(finalString.dropFirst())
            index += 1
        }
        
        /** If input is empty after removing all leading 0's then add a 0 */
        if (finalString.count == 0) { finalString = "0" }
    
        /** Now that the input has been cleaned, add the special charcaters back in their correct placement */
        toAdhere.forEach({ val in
            if (val.value == .start) { finalString = val.key + finalString }
            else if (val.value == .end) { finalString = finalString + val.key }
        })
        
        return finalString
    }

    /**
     Add special character
     */
    static func appendCharacter(character: KeypadSpecial, to current: String) -> String {
        if (current.count >= 8) { return current }
        
        let char = getRuleFor(character) //specialCharacterList[character] ?? .init(placement: .anywhere, representable: "")
        
        if (current == "0" || current == "") {
            return CalculatorEntryController.prepareForFinalReturn(char.representable)
        } else {
            var components = getComponentsOfEntry(entry: current)
            let doesContainCharacter = (char.placement == .anywhere)
                ? components[components.count-1].contains(char.representable)
                : current.contains(char.representable)
            
            if (doesContainCharacter) {
                if (char.togglable) {
                    if (char.placement == .anywhere) {
                        components[components.count-1] = components[components.count-1].replacingOccurrences(of: char.representable, with: "")
                        return CalculatorEntryController.prepareForFinalReturn(components.joined(separator: ""))
                    } else { return CalculatorEntryController.prepareForFinalReturn(current.replacingOccurrences(of: char.representable, with: "")) }
                } else { return CalculatorEntryController.prepareForFinalReturn(current) }
            } else {
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
            return CalculatorEntryController.prepareForFinalReturn(character)
        } else {
            return CalculatorEntryController.prepareForFinalReturn(current + character)
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

//    /**
//     Reverse the value for the current entry
//     i.e.
//     4 -> -4
//     16 -> -16
//     -42.4 -> 42.4
//     */
//    static func reverseCalculatorValue(current: String) -> String {
//        var numberValue = current
//        var wasNegative = false
//        if (current.first == "-") {
//            wasNegative = true
//            numberValue = String(numberValue.dropFirst())
//        }
//
//        if (numberValue == "") { numberValue = "0" }
//
//        return CalculatorEntryController.prepareForFinalReturn((wasNegative ? "" : "-") + numberValue)
//    }
}
