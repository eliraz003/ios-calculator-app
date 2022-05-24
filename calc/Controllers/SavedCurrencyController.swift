//
//  SavedCurrencyController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

//private
//
//private
//
//private

class SavedCurrencyController {
    static var shared: SavedCurrencyController = SavedCurrencyController()
    
    var savedCurrencies: [String:Bool] = [
        "GBP":true,
        "EUR":true,
        "USD":true,
        "CHF":true
    ]
    
    init() { readSaved() }
    
    func save(currency: Currency, state: Bool) {
        if (state) { savedCurrencies[currency.isoCode] = true }
        else { savedCurrencies.removeValue(forKey: currency.isoCode) }
        
        UserDefaults.standard.set(savedCurrencies, forKey: "@currency")
    }
    
    func readSaved() {
        if let saved = UserDefaults.standard.object(forKey: "@currency") as? [String:Bool] {
            savedCurrencies = saved
        }
    }
}
