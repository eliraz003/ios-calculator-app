//
//  Unit.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit
import JavaScriptCore

enum UnitType {
    case generic,
         currency,
         time,
         
         length,
         mass
}

class Unit: Equatable {
    var id: String = {
        return UUID().uuidString
    }()
    
    var symbol: String = ""
    var name: String
    var type: UnitType {
        get { return .generic }
    }
    
    func convertToBase(value: CGFloat) -> CGFloat { return 1 }
    
    func convertFromBase(value: CGFloat) -> CGFloat { return 1 }
    
    func getSymbol() -> String {
        if (type == .generic) { return "#" }
        else { return symbol }
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool { return lhs.id == rhs.id }
    
    internal init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
}


/**
 Protocol for units that can only be used on the total row (i.e. for rendering porpuses only and not to be used as inputs)
 for example:
 HH:MM:SS which would render hours, minutes, and seconds together
 or FT'IN which would render both the feet and inch values together
 */
protocol ResultOnlyUnit: Unit {
    var syntax: String { get set }
    var fallback: Unit? { get set }
    
    func renderResult(value: CGFloat) -> String
}

extension ResultOnlyUnit {
    func asWholeNumber(_ v: CGFloat) -> String {
        let nubmerFormatter = NumberFormatter()
        nubmerFormatter.numberStyle = .decimal
        nubmerFormatter.alwaysShowsDecimalSeparator = false
        nubmerFormatter.maximumFractionDigits = 0
        
        let stringRepresentation = nubmerFormatter.string(from: NSNumber(value: v))!
        
        print("STRING REPRESENTATION", stringRepresentation)
        return String(stringRepresentation.split(separator: ".")[0]) // String(v.description.split(separator: ".")[0])
    }
    
    func fallbackUnit() -> Unit? { return fallback }
}


/**
 Used to create units that are rate based, i.e. all share a similar value such as both Killogram and grams can both be converted into milligrams
 */
class RateBasedUnit: Unit {
    var rate: CGFloat = 0
    
    init(name: String, symbol: String, rate: CGFloat) {
        super.init(name: name, symbol: symbol)
        self.rate = rate
    }
    
    override func convertToBase(value: CGFloat) -> CGFloat {
        return value * CGFloat(rate)
    }
    
    override func convertFromBase(value: CGFloat) -> CGFloat {
        return value / CGFloat(rate)
    }
}


/**
 Used to create units that require calculation to convert back and forth to a shared value, for example temperature.
 Celcuius to Farenhite requires calculating (c+32)*(9/5)
 This uses the JSContext() to perform such operations
 */
class CalculationBasedUnit: Unit {
    var conversion: String
    var returnConversion: String
    
    internal init(name: String, symbol: String, conversion: String, returnConversion: String) {
        self.returnConversion = returnConversion
        self.conversion = conversion
        super.init(name: name, symbol: symbol)
    }
    
    override func convertToBase(value: CGFloat) -> CGFloat {
        let context = JSContext()
        let jsValue = context?.evaluateScript(conversion.replacingOccurrences(of: "x", with: value.description))

        guard let res = jsValue?.toNumber() as? CGFloat else { return 0 }
        return res
    }

    override func convertFromBase(value: CGFloat) -> CGFloat {
        let context = JSContext()
        let jsValue = context?.evaluateScript(returnConversion.replacingOccurrences(of: "x", with: value.description))

        guard let res = jsValue?.toNumber() as? CGFloat else { return 0 }
        return res
    }
}

