//
//  MassController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

var massUnits: UnitContainer = UnitContainer({ add, reference in
    add(.ShowInResultRendering, Mass(name: Mass.Milligram, symbol: "Mg", rate: 1))
    add(.ShowInResultRendering, Mass(name: Mass.Gram, symbol: "G", rate: 1000))
    add(.ShowInResultRendering, Mass(name: Mass.Kilogram, symbol: "KG", rate: 1000000))
    add(.ShowInResultRendering, Mass(name: Mass.Tonne, symbol: "Ton", rate: 1000000000))
    
    add(.ShowInResultRendering, Mass(name: Mass.USTon, symbol: "US-Ton", rate: 9.07200000))
    add(.ShowInResultRendering, Mass(name: Mass.ImperialTon, symbol: "Imp-Ton", rate: 1016000000))
    
    add(.ShowInResultRendering, Mass(name: Mass.Stone, symbol: "St", rate: 6350000))
    add(.ShowInResultRendering, Mass(name: Mass.Pound, symbol: "Lb", rate: 453592))
    add(.ShowInResultRendering, Mass(name: Mass.Ounce, symbol: "Oz", rate: 28349.5))
})
