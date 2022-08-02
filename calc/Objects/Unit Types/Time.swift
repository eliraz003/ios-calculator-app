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
        
        // Is the time based of seconds from 1970
        var isAbsoluteTime: Bool = false
        
        override var type: UnitType {
            get { return .time }
        }

        init(name: String, syntax: String, symbol: String, absolute: Bool, fallback: Unit?) {
            super.init(name: name, symbol: symbol)
            self.syntax = syntax
            self.isAbsoluteTime = absolute
            self.fallback = fallback
        }
        
        func renderResult(value: CGFloat) -> String {
            var startingString = syntax
            
            if (isAbsoluteTime) {
                let remainingTime = value / Time.SecondValue
                print("before", Date().timeIntervalSince1970, remainingTime)
                
                let dateObject = Date(timeIntervalSince1970: remainingTime)
                let calendar = Calendar.current
                let obj = calendar.dateComponents([
                    .year,
                    .month,
                    .day,
                    .hour,
                    .minute
                ], from: dateObject)
                
                startingString = startingString.replacingOccurrences(of: "YEAR", with: asWholeNumber(obj.year ?? 0, showCommas: false))
                startingString = startingString.replacingOccurrences(of: "MONTH", with: asWholeNumber(obj.month ?? 0))
                startingString = startingString.replacingOccurrences(of: "DAY", with: asWholeNumber(obj.day ?? 0))
                
                startingString = startingString.replacingOccurrences(of: "HOUR", with: asWholeNumber(obj.hour ?? 0))
                startingString = startingString.replacingOccurrences(of: "MINUTE", with: asWholeNumber(obj.minute ?? 0))
            } else {
                var remainingTime = value
                let years = (startingString.contains("YEAR")) ? floor(remainingTime / (Time.YearValue)) : 0
                remainingTime -= floor(years * Time.YearValue)
                let months = (startingString.contains("MONTH")) ? floor(remainingTime / (Time.MonthValue)) : 0
                remainingTime -= floor(months * Time.MonthValue)
                let days = (startingString.contains("DAY")) ? floor(remainingTime / (Time.DayValue)) : 0
                remainingTime -= floor(days * Time.DayValue)
                
                let hours = (startingString.contains("HOUR")) ? floor(remainingTime / (Time.HourValue)) : 0
                remainingTime -= floor(hours * Time.HourValue)
                let minutes = (startingString.contains("MINUTE")) ? floor(remainingTime / (Time.MinuteValue)) : 0
                remainingTime -= floor(minutes * Time.MinuteValue)
                let seconds = (startingString.contains("SECOND")) ? floor(remainingTime / (Time.SecondValue)) : 0
                remainingTime -= floor(seconds * Time.SecondValue)
                            
                let milliseconds = (remainingTime * Time.MillisecondValue)
                
                startingString = startingString.replacingOccurrences(of: "YEAR", with: asWholeNumber(years+1970, showCommas: false))
                startingString = startingString.replacingOccurrences(of: "MONTH", with: asWholeNumber(months))
                startingString = startingString.replacingOccurrences(of: "DAY", with: asWholeNumber(days))
                
                startingString = startingString.replacingOccurrences(of: "HOUR", with: asWholeNumber(hours))
                startingString = startingString.replacingOccurrences(of: "MINUTE", with: asWholeNumber(minutes))
                startingString = startingString.replacingOccurrences(of: "SECOND", with: asWholeNumber(seconds))
                startingString = startingString.replacingOccurrences(of: "MILLISECOND", with: asWholeNumber(milliseconds))
            }
            
//            print(hours, minutes, seconds, milliseconds)
            
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
    static var Month = "Month"
    static var Year = "Year"
    
    
    static var MillisecondValue: CGFloat = 1
    static var SecondValue: CGFloat = 1000
    static var MinuteValue: CGFloat = (1000 * 60)
    static var HourValue: CGFloat = (1000 * 60 * 60)
    
    static var DayValue: CGFloat = (1000 * 60 * 60 * 24)
    static var MonthValue: CGFloat = (1000 * 60 * 60 * 24 * 365) / 12
    static var YearValue: CGFloat = (1000 * 60 * 60 * 24 * 365)
}
