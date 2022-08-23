//
//  TimeController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation

var timeUnits = UnitContainer({ add, reference in
    let secondUnit = Time(name: Time.Second, symbol: "Sec", rate: Time.SecondValue)
    
    add([.ShowInResultRendering], Time(name: Time.Millisecond, symbol: "Ms", rate: Time.MillisecondValue))
    add([.ShowInResultRendering], secondUnit)
    add([.ShowInResultRendering], Time(name: Time.Minute, symbol: "Min", rate: Time.MinuteValue))
    add([.ShowInResultRendering], Time(name: Time.Hour, symbol: "Hr", rate: Time.HourValue))
    add([.ShowInResultRendering], Time(name: Time.Day, symbol: "Day", rate: Time.DayValue))
    
    add([.ShowInResultRendering], Time.TimeRendered(name: Time.HMSM, syntax: "HOUR:MINUTE:SECOND MILLISECOND", symbol: "H:M:S Ms", absolute: false, fallback: secondUnit ))
    add([.ShowInResultRendering], Time.TimeRendered(name: Time.HMS, syntax: "HOUR:MINUTE:SECOND", symbol: "H:M:S", absolute: false, fallback: secondUnit))
    add([.ShowInResultRendering], Time.TimeRendered(name: Time.Date, syntax: "DAY/MONTH/YEAR", symbol: "Date", absolute: true, fallback: secondUnit))
    add([.ShowInResultRendering], Time.TimeRendered(name: Time.DateTime, syntax: "DAY/MONTH/YEAR HOUR:MINUTE", symbol: "Date", absolute: true, fallback: secondUnit))
})
