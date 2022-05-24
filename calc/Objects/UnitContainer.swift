//
//  UnitContainer.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

enum UnitContainerOption: String {
    case ShowInResultRendering,
         HideInResultRendering
}

/**
 Utility class to contain units of a generic type,
 for example will be used for the timeUnits variable and the lengthVariable
 */
class UnitContainer {
    private var items: [(Unit, [UnitContainerOption])] = []
    var first: Unit? { return items.first?.0 }
    
    init(_ constructor: ((UnitContainerOption, Unit) -> Void, UnitContainer) -> Void) {
        constructor(
            { option, newUnit in items.append((newUnit, [option])) },
            self
        )
    }
    
    func getWithName(_ name: String) -> Unit? {
        return items
            .first(where: { return $0.0.name == name })
            .map({ return $0.0 })
    }
    
    func availiableUnits(forStandardRow: Bool) -> [[Unit]] {
        var arrA: [Unit] = []
        var arrB: [Unit] = []
        
        arrA = items.filter({ unit in
            if (!forStandardRow) { return (unit.0 as? ResultOnlyUnit == nil && unit.1.contains(.ShowInResultRendering)) }
            return (unit.0 as? ResultOnlyUnit == nil)
        }).map({ return $0.0 })
        
        arrB = items.filter({ unit in
            return (unit.0 as? ResultOnlyUnit != nil)
        }).map({ return $0.0 })
        
        if(arrB.count > 0 && !forStandardRow) { return [arrA, arrB] }
        return [arrA]
    }
}
