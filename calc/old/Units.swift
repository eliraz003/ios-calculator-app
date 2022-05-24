//
//  CurrencyUnitController.swift
//  calc
//
//  Created by Eliraz Atia on 06/05/2022.
//

//import Foundation
//import UIKit
//import JavaScriptCore





//    init {
//        self.init(name: "", symbol: "")
//        self.name = name
//        self.symbol = symbol
//        self.syntax = conversionSyntax
//    }
//}














//timeUnits.add(unit: Time(name: Time.Millisecond, symbol: "Ms", rate: 1))
//timeUnits.add(unit: Time(name: Time.Millisecond, symbol: "Ms", rate: 1))
//timeUnits.add(unit: Time(name: Time.Millisecond, symbol: "Ms", rate: 1))
//timeUnits.add(unit: Time(name: Time.Millisecond, symbol: "Ms", rate: 1))
//timeUnits.add(unit: Time(name: Time.Millisecond, symbol: "Ms", rate: 1))

//var temperatureUnits: [String : Unit] = [
//    Temperature.Celcius:Temperature(name: Temperature.Celcius, conversion: "x", returnConversion: "x"),
//    Temperature.Farenhite:Temperature(name: Temperature.Farenhite, conversion: "(x - 32) * (5/9)", returnConversion: "(x * 9/5) + 32"),
//    Temperature.Kalvin:Temperature(name: Temperature.Kalvin, conversion: "x - 273.15", returnConversion: "x + 273.15")
//]

//var timeUnits: [String : Unit] = [
//    Time.Millisecond:Time(name: Time.Millisecond, symbol: "Ms", rate: 1),
//    Time.Second:Time(name: Time.Second, symbol: "Sec", rate: 1000),
//    Time.Minute:Time(name: Time.Minute, symbol: "Min", rate: (1000 * 60)),
//    Time.Hour:Time(name: Time.Hour, symbol: "Hr", rate: (1000 * 60 * 60)),
//
//    "HH:MM:SS MMMMS":Time.TimeRendered(name: "HH:MM:SS MS", syntax: "HH:MM:SS MS", symbol: "H:M:S Ms"),
//    "HH:MM:SS":Time.TimeRendered(name: "HH:MM:SS", syntax: "HH:MM:SS", symbol: "H:M:S"),
//]

//var lengthUnits: [String : Unit] = [
//    Length.Millimeter:Length(name: Length.Millimeter, symbol: "MM", rate: 1),
//    Length.Centimeter:Length(name: Length.Centimeter, symbol: "CM", rate: 10),
//    Length.Meter:Length(name: Length.Meter, symbol: "M", rate: 1000),
//    Length.Kilometer:Length(name: Length.Kilometer, symbol: "KM", rate: 1000000),
//
//    Length.Yard:Length(name: Length.Yard, symbol: "YRD", rate: 914.4),
//    Length.Inch:Length(name: Length.Inch, symbol: "INCH", rate: 25.4),
//    Length.Foot:Length(name: Length.Foot, symbol: "FT", rate: 304.8),
//
//    "FT'IN":Length.LengthRendered(name: "FT'IN", syntax:"FT\" IN'", symbol:"FT")
//]

//var massUnits: [String : Mass] = [
//    Mass.Milligram:Mass(name: Mass.Milligram, symbol: "Mg", rate: 1),
//    Mass.Gram:Mass(name: Mass.Gram, symbol: "G", rate: 1000),
//    Mass.Kilogram:Mass(name: Mass.Kilogram, symbol: "Kg", rate: 1000000),
//
//    Mass.Tonne:Mass(name: Mass.Tonne, symbol: "Ton", rate: 1000000000),
//    Mass.USTon:Mass(name: Mass.USTon, symbol: "US-Ton", rate: 9.07200000),
//    Mass.ImperialTon:Mass(name: Mass.ImperialTon, symbol: "Imp-Ton", rate: 1016000000),
//
//    Mass.Stone:Mass(name: Mass.Stone, symbol: "St", rate: 6350000),
//    Mass.Pound:Mass(name: Mass.Pound, symbol: "Lb", rate: 453592),
//    Mass.Ounce:Mass(name: Mass.Ounce, symbol: "Oz", rate: 28349.5),
//]




















//class Temperature: Unit {
//    static var Celcius: String = "Celcius"
//    static var Farenhite: String = "Farenhite"
//    static var Kalvin: String = "Kalvin"
//
//    var conversion: String
//    var returnConversion: String
//
//    override var type: UnitType {
//        get { return .temperature }
//    }
//
//    internal init(name: String, conversion: String, returnConversion: String) {
//        self.returnConversion = returnConversion
//        self.conversion = conversion
//        super.init(name: name)
//    }
//
//    override func convertToBase(value: CGFloat) -> CGFloat {
//        let context = JSContext()
//        let jsValue = context?.evaluateScript(conversion.replacingOccurrences(of: "x", with: value.description))
//
//        guard let res = jsValue?.toNumber() as? CGFloat else { return 0 }
//        return res
//    }
//
//    override func convertFromBase(value: CGFloat) -> CGFloat {
//        let context = JSContext()
//        let jsValue = context?.evaluateScript(returnConversion.replacingOccurrences(of: "x", with: value.description))
//
//        guard let res = jsValue?.toNumber() as? CGFloat else { return 0 }
//        return res
//    }
//
//    override func getSymbol() -> String {
//        switch(name) {
//        case Temperature.Celcius:
//            return "°C"
//        case Temperature.Farenhite:
//            return "°F"
//        case Temperature.Kalvin:
//            return "°K"
//        default:
//            break
//        }
//
//        return ""
//    }
//}
