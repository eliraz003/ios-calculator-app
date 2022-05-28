//
//  UnitContainer.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

enum UnitContainerOption: String {
    case ShowInResultRendering,
         HideInResultRendering,
         NewGroup
}

/**
 Utility class to contain units of a generic type,
 for example will be used for the timeUnits variable and the lengthVariable
 */
class UnitContainer {
    private var items: [(Unit, [UnitContainerOption])] = []
    var first: Unit? { return items.first?.0 }
    
    init(_ constructor: (([UnitContainerOption], Unit) -> Void, UnitContainer) -> Void) {
        constructor(
            { options, newUnit in items.append((newUnit, options)) },
            self
        )
    }
    
    func getWithName(_ name: String) -> Unit? {
        return items
            .first(where: { return $0.0.name == name })
            .map({ return $0.0 })
    }
    
    func availiableUnits(forStandardRow: Bool) -> [[Unit]] {
//        var arrA: [Unit] = []
//        var arrB: [Unit] = []
        
        var resultOnlyArray: [Unit] = []
        var arrays: [[Unit]] = [[]]
        
        items.forEach({ unit in
            // add to resultsOnlyArray if is ResultOnlyUnit and is on total row
            // add to array if the row is either (forStandardRow) || (!forStandardRow && unit.1.contains(.Show))
            
            let isResultOnlyRow = unit.0 as? ResultOnlyUnit != nil
            
            if (isResultOnlyRow) {
                if (!forStandardRow) { resultOnlyArray.append(unit.0) }
                return
            }
            
            if (forStandardRow || (!forStandardRow && unit.1.contains(.ShowInResultRendering))) {
                if (unit.1.contains(.NewGroup)) { arrays.append([]) }
                arrays[arrays.count - 1].append(unit.0)
            }
        })
        
//        arrays.append(items.filter({ unit in
//            if (!forStandardRow) { return (unit.0 as? ResultOnlyUnit == nil && unit.1.contains(.ShowInResultRendering)) }
//            return (unit.0 as? ResultOnlyUnit == nil)
//        }).map({ return $0.0 }))
        
//        arrays.append(items.filter({ unit in
//            return (unit.0 as? ResultOnlyUnit != nil && !forStandardRow)
//        }).map({ return $0.0 }))
        arrays.append(resultOnlyArray)
        return arrays
        
//        if(arrB.count > 0 && !forStandardRow) { return [arrA, arrB] }
//        return [arrA]
    }
}
