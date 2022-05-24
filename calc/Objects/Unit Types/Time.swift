//
//  Time.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class Time: RateBasedUnit {
    override var type: UnitType {
        get { return .time }
    }
    
    class TimeRendered: Unit, ResultOnlyUnit {
        var syntax: String = ""
        var fallback: Unit?
        
        override var type: UnitType {
            get { return .time }
        }

        init(name: String, syntax: String, symbol: String, fallback: Unit?) {
            super.init(name: name, symbol: symbol)
            self.syntax = syntax
            self.fallback = fallback
        }
        
        func renderResult(value: CGFloat) -> String {
            var startingString = syntax
            var remainingTime = value
            
            let hours = (startingString.contains("HH")) ? floor(remainingTime / (Time.HourValue)) : 0
            remainingTime -= (hours * Time.HourValue)
            let minutes = (startingString.contains("MM")) ? floor(remainingTime / (Time.MinuteValue)) : 0
            remainingTime -= (minutes * Time.MinuteValue)
            let seconds = (startingString.contains("SS")) ? floor(remainingTime / (Time.SecondValue)) : 0
            remainingTime -= (seconds * Time.SecondValue)
            
            let milliseconds = (remainingTime * Time.MillisecondValue)
            
            startingString = startingString.replacingOccurrences(of: "HH", with: asWholeNumber(hours))
            startingString = startingString.replacingOccurrences(of: "MM", with: asWholeNumber(minutes))
            startingString = startingString.replacingOccurrences(of: "SS", with: asWholeNumber(seconds))
            startingString = startingString.replacingOccurrences(of: "MS", with: asWholeNumber(milliseconds))
            
            print(hours, minutes, seconds, milliseconds)
            
            return startingString
        }
        
        func fallbackUnit() -> Unit? {
            return timeUnits.first
        }
    }
}

extension Time {
    static var Millisecond = "Millisecond"
    static var Second = "Second"
    static var Minute = "Minute"
    static var Hour = "Hour"
    static var Day = "Day"
    
    static var MillisecondValue: CGFloat = 1 //0.001
    static var SecondValue: CGFloat = 1000
    static var MinuteValue: CGFloat = (1000 * 60)
    static var HourValue: CGFloat = (1000 * 60 * 60)
    static var DayValue: CGFloat = (1000 * 60 * 60 * 24)
}
