//
//  Length.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class Length: RateBasedUnit {
    override var type: UnitType {
        get { return .length }
    }
    
    class LengthRendered: Unit, ResultOnlyUnit {
        var syntax: String = ""
        var fallback: Unit? = nil
        
        override var type: UnitType {
            get { return .length }
        }
        
        internal init (name: String, syntax: String, symbol: String, fallback: Unit?) {
            super.init(name: name, symbol: symbol)
            self.syntax = syntax
            self.fallback = fallback
        }
        
        func renderResult(value: CGFloat) -> String {
            var startingString = syntax
            var remainingValue = value
            
            let mile = (startingString.contains("MILE")) ? floor(remainingValue / 1609344) : 0
            remainingValue -= (mile * 1609344)
            
            let yard = (startingString.contains("YRD")) ? floor(remainingValue / 914.4) : 0
            remainingValue -= (yard * 914.4)
            
            let feet = (startingString.contains("FT")) ? floor(remainingValue / 304.8) : 0
            remainingValue -= (feet * 304.8)
            
            let inch = (startingString.contains("IN")) ? floor(remainingValue / 25.4) : 0
            remainingValue -= (inch * 304.8)
            
            startingString = startingString.replacingOccurrences(of: "MILE", with: asWholeNumber(mile))
            startingString = startingString.replacingOccurrences(of: "YRD", with: asWholeNumber(yard))
            startingString = startingString.replacingOccurrences(of: "FT", with: asWholeNumber(feet))
            startingString = startingString.replacingOccurrences(of: "IN", with: asWholeNumber(inch))
            
            return startingString
        }
    }
}

extension Length {
    static var Millimeter = "Millimeter"
    static var Centimeter = "Centimeter"
    static var Meter = "Meter"
    static var Kilometer = "Kilometer"
    
    static var Inch = "Inch"
    static var Foot = "Foot"
    static var Yard = "Yard"
    static var Mile = "Mile"
}
