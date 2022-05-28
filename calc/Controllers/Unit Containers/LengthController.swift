//
//  LengthController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

var lengthUnits = UnitContainer({ add, reference in
    add([.ShowInResultRendering], Length(name: Length.Millimeter, symbol: "MM", rate: 1))
    add([.ShowInResultRendering], Length(name: Length.Centimeter, symbol: "CM", rate: 10))
    add([.ShowInResultRendering], Length(name: Length.Meter, symbol: "M", rate: 1000))
    add([.ShowInResultRendering], Length(name: Length.Kilometer, symbol: "KM", rate: 1000000))
    
    add([.ShowInResultRendering, .NewGroup], Length(name: Length.Inch, symbol: "IN", rate: 25.4))
    add([.ShowInResultRendering], Length(name: Length.Foot, symbol: "FT", rate: 304.8))
    add([.ShowInResultRendering], Length(name: Length.Yard, symbol: "YRD", rate: 914.4))
    add([.ShowInResultRendering], Length(name: Length.Mile, symbol: "MILE", rate: 1609344))
    
    add([], Length.LengthRendered(name: "FT'IN", syntax:"FT\" IN'", symbol:"FT", fallback: reference.getWithName(Length.Foot)))
    
    add([], Length.LengthRendered(name: "YRD FT'", syntax:"YRD FT\"", symbol:"YRD FT", fallback: reference.getWithName(Length.Yard)))
})
