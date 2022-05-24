////
////  CalculatorHandler.swift
////  calc
////
////  Created by Eliraz Atia on 06/05/2022.
////
//
//import Foundation
//
//class CalculatorHdler {
//    static func prepareForFinalReturn(_ string: String) -> String {
//        var index = 0
//        var finalString = string
//        let isNegativeString = (string.first == "-")
//        if (isNegativeString) { finalString = String(finalString.dropFirst()) }
//
//        while (finalString.first == "0" && index < string.count && string.count > 1) {
//            finalString = String(finalString.dropFirst())
//            index += 1
//        }
//
//        if (finalString.count == 0) { finalString = "0" }
//
//        return ((isNegativeString) ? "-" : "") + finalString
//    }
//
//    static func appendCharacter(character: String, to current: String) -> String {
//        // check if current equals to 0
//            // if character is . then return "0."
//            // else then return the character
//        // else
//            // if character equals "."
//                // if decimal exists then return current and don't change anything
//                // else return "current" + "."
//            // else
//                // return current + character
//
//        if (current.count >= 8) { return current }
//
//        if (current == "0" || current == "") {
//            if (character == ".") {
//                return "0."
//            } else {
//                return character
//            }
//        } else {
//            if (character == ".") {
//                if (current.contains(".")) {
//                    return CalculatorEntryController.prepareForFinalReturn(current)
//                } else {
//                    return CalculatorEntryController.prepareForFinalReturn(current + ".")
//                }
//            } else {
//                return CalculatorEntryController.prepareForFinalReturn(current + character)
//            }
//        }
//    }
//
//    static func removingLastCharacter(current: String) -> String {
//        // if current is only one character long than return "0"
//        // else
//            // remove last character
//            // if last character is a "." then also remove the "."
//
//        if (current.count <= 1) {
//            return "0"
//        } else {
//            var newString = current
//            if let lastIndex = current.lastIndex(of: current.last!) {
//                newString.remove(at: lastIndex)
//            }
//            
//            return CalculatorEntryController.prepareForFinalReturn(newString)
//        }
//    }
//
//    static func reverseCalculatorValue(current: String) -> String {
//        // flip value
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
////
////        if (current.first == "-") {
////            var newCurrent = current
////            newCurrent = String(current.dropFirst())
////            return newCurrent
////        } else {
////            return "-" + current
////        }
//    }
//}
