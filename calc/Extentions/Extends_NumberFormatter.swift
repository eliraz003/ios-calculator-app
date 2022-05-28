//
//  Extends_NumberFormatter.swift
//  calc
//
//  Created by Eliraz Atia on 28/05/2022.
//

import Foundation
import UIKit

extension NumberFormatter {
    static func usingOverallCharacterCount(value: CGFloat, min: Int, max: Int) -> String {
        let nubmerFormatter = NumberFormatter()
        nubmerFormatter.numberStyle = .decimal
        nubmerFormatter.alwaysShowsDecimalSeparator = true
        
        let finalValueAsString = nubmerFormatter.string(from: NSNumber(value: value))!
        let beforeDecimalCharacterCount = finalValueAsString.split(separator: ".").map({ i in return String(i) })[0].count
        
        var numberOfDecimalsAllowed = (max - beforeDecimalCharacterCount)
        if (numberOfDecimalsAllowed <= min) { numberOfDecimalsAllowed = min }
        nubmerFormatter.maximumFractionDigits = numberOfDecimalsAllowed
        
        var absoluteFinalValue = nubmerFormatter.string(from: NSNumber(value: value))!
        if (absoluteFinalValue.last == ".") {
            absoluteFinalValue = absoluteFinalValue.replacingOccurrences(of: ".", with: "")
        }
        
        return absoluteFinalValue
    }
}
