//
//  Mass.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

class Mass: RateBasedUnit {
    override var type: UnitType {
        get { return .mass }
    }
}

extension Mass {
    static var Milligram = "Milligram"
    static var Gram = "Gram"
    static var Kilogram = "Kilogram"
    static var Tonne = "Tonne"
    static var USTon = "USTon"
    static var ImperialTon = "ImperialTon"
    static var Stone = "Stone"
    static var Pound = "Pound"
    static var Ounce = "Ounce"
}
