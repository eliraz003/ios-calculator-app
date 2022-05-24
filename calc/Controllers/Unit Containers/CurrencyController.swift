//
//  CurrencyController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

var currencyUnits: [String : Unit] = [:]

class CurrencyUnitController {
    static func fetchCurrencies() {
        do {
            let bundle = Bundle.main.path(forResource: "Currency-list", ofType: "txt")
            let textfile = try String(contentsOfFile: bundle!)
            let split = textfile.split(separator: "\n")
            
            split.forEach({ splitItem in
                let row = String(splitItem)
                let rowSplit = row.split(separator: "|")
                let name = String(rowSplit[0])
                let iso = String(rowSplit[1])
                let symbol = String(rowSplit[2])
                
                currencyUnits[iso] = Currency(Temp(name: name, iso: iso, symbol: symbol, countries: []))
            })
        } catch { print("FAILED") }
    }
    
    struct Temp {
        var name: String
        var iso: String
        var symbol: String
        var countries: [String]
    }
}
