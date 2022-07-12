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
            if (i <= self.count-1) { current.append(self[i]) }
            i += 1
        }
        
        return current
    }
}



class CalculatorEntryController {
    
    
    static func shouldAdhereToRule(wholeString: String) -> [String:SpecialCharacterRule.Placement] {
        var current: [String : SpecialCharacterRule.Placement] = [:]
        KeypadSpecial.rules.forEach({ rule in
            if (rule.value.placement == .anywhere) { return }
            if (wholeString.contains(rule.value.representable)) {
                current[rule.value.representable] = rule.value.placement
            }
        })
        
        return current
    }
    
    
    
    static func getComponentsOfEntry(entry: String) -> [String] {
        var components: [String] = []
        var lastComponentNumeric: Bool?
        var latestComponent: String = ""
        
        for char in entry {
            let isNumeric = (char == "." || char.isNumber)
            let isSpecial = (!isNumeric)
            let ignorePrevious = (lastComponentNumeric == nil)
            let wasComponentNumberic = (!ignorePrevious) ? lastComponentNumeric! : false
        
            if (isNumeric) {
                lastComponentNumeric = true
                
                if (components.count == 0 || !wasComponentNumberic) { components.append("") }
                components[components.count-1] += String(char)
            } else if (isSpecial) {
                lastComponentNumeric = false
                latestComponent += String(char)
                if (KeypadSpecial.getRuleFor(latestComponent) != nil) {
                    components.append(latestComponent)
                    latestComponent = ""
                }
            }
        }
        
        if (components.count == 0) { components.append("") }
        return components
    }
        
    static func renderedValue(entry: String) -> (Double?, [SpecialCharacterRule.CalculationApplicableRule], Error?) {
        let components = getComponentsOfEntry(entry: entry)
        var foundIssue: Error?
        var rules: [SpecialCharacterRule.CalculationApplicableRule] = []
        
        func performAndEvaluateRule(_ rule: SpecialCharacterRule, a: Double?, b: Double?, _ defaultValue: Double?) -> Double? {
            let val = rule.dispatchPerform(a: a, b: b) //rule.perform?(a,b)
            rules.append(contentsOf: rule.calculationRules)
            if (val.0 != nil) { return val.0 }
            else { foundIssue = val.1; return nil }
        }
        
        func toNumber(value: String) -> Double {
            let formatter = NumberFormatter()
            return Double(truncating: formatter.number(from: value) ?? 0)
        }
        
        func evaluateOperation(array: [String], holdingValue: Double, callOperation: SpecialCharacterPerformer?) -> Double? {
            if (array.count == 0) { return nil }
            if (array.count == 1) {
                if let rule0 = KeypadSpecial.getRuleFor(array[0]) { return performAndEvaluateRule(rule0, a: nil, b: nil, 0) }
                else { return toNumber(value: array[0]) }
            }
                
            if let rule0 = KeypadSpecial.getRuleFor(array[0]) {
                let result = evaluateOperation(array: array.splice(range: 1..<components.count), holdingValue: 0, callOperation: rule0.perform)
                let handledResult = performAndEvaluateRule(rule0, a: nil, b: result, nil) // rule0.perform?(nil, result)
                return handledResult ?? 0
            } else if let rule1 = KeypadSpecial.getRuleFor(array[1])  {
                let result = evaluateOperation(array: array.splice(range: 2..<components.count), holdingValue: 0, callOperation: rule1.perform)
                let handledResult = performAndEvaluateRule(rule1, a: toNumber(value: array[0]), b: result, toNumber(value: array[0])) //rule1.perform?(toNumber(value: array[0]), result) ?? toNumber(value: array[0])
                return handledResult
            }

            return 0
        }
        
        let result = evaluateOperation(array: components, holdingValue: 0, callOperation: { (a,b) in
            return (a ?? 0, nil)
        }) ?? 0
        
        if (foundIssue != nil) { return (nil, [], foundIssue) }
        if (Double.infinity == result) { return (nil, [], UserEntryError.InfiniteResult) }
        
        return (result, rules, nil)
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
        
        let char = character.rule() //specialCharacterList[character] ?? .init(placement: .anywhere, representable: "")
        
        if (current == "0" || current == "") {
            return CalculatorEntryController.prepareForFinalReturn(char.representable)
        } else {
            var components = getComponentsOfEntry(entry: current)
            let doesContainCharacter = (char.placement == .anywhere)
                ? components[components.count-1].contains(char.representable)
                : current.contains(char.representable)
            
            if (doesContainCharacter) {
                if (char.rules.contains(.Togglable)) {
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
    static func removingLastCharacter(current: String) -> String? {
        if (current == "0" || current == "-0") { return nil }
        
        var components = getComponentsOfEntry(entry: current)
        if (KeypadSpecial.getRuleFor(components.last!) != nil) {
            components.removeLast()
        } else {
            components[components.count-1].removeLast()
            if (components[components.count-1] == "") {
                components.removeLast()
            }
        }
        
        let valueIsEmpty: Bool = (components.count == 1)
            ? (components[0] == "" || components[0] == "0")
            : (components.count == 0) ? true :false
//        print("is value empty", valueIsEmpty)
        if (valueIsEmpty) { return "0" }
        else { return CalculatorEntryController.prepareForFinalReturn(components.joined()) }
    }
}
