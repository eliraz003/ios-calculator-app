//
//  TimeController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

var timeUnits = UnitContainer({ add, reference in
    add(.ShowInResultRendering, Time(name: Time.Millisecond, symbol: "Ms", rate: Time.MillisecondValue))
    add(.ShowInResultRendering, Time(name: Time.Second, symbol: "Sec", rate: Time.SecondValue))
    add(.ShowInResultRendering, Time(name: Time.Minute, symbol: "Min", rate: Time.MinuteValue))
    add(.ShowInResultRendering, Time(name: Time.Hour, symbol: "Hr", rate: Time.HourValue))
    add(.ShowInResultRendering, Time(name: Time.Day, symbol: "Day", rate: Time.DayValue))
    
    add(.ShowInResultRendering, Time.TimeRendered(name: "HH:MM:SS MS", syntax: "HH:MM:SS MS", symbol: "H:M:S Ms", fallback: reference.first ))
    add(.ShowInResultRendering, Time.TimeRendered(name: "HH:MM:SS", syntax: "HH:MM:SS", symbol: "H:M:S", fallback: reference.first))
})
