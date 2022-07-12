//
//  EntryMemoryController.swift
//  calc
//
//  Created by Eliraz Atia on 12/07/2022.
//

private var value: Double = 0

import Foundation
class EntryMemoryController {
    static func findFromStorage() {
        value = UserDefaults.standard.double(forKey: "@memory")
    }
    
    private static func save() {
        UserDefaults.standard.set(value, forKey: "@memory")
    }
    
    static func getValue() -> Double {
        return value
    }
    
    static func add(_ newValue: Double) {
        value += newValue
        save()
    }
    
    static func reduce(_ newValue: Double) {
        value -= newValue
        save()
    }
}
