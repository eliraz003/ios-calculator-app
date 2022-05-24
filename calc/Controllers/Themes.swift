//
//  Themes.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

var defaultTheme: String = "Black"
var themes: [String:Theme] = [
    "Green":.init(name: "Green", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "1E5F30"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "1A562B"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "1B592C"),
        
        ColorController.KeypadCharacter:UIColor.white,
        ColorController.RowLabel:UIColor.white
    ]),
    
    "White":.init(name: "White", colors: [
        ColorController.MainBackground:UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.85, alpha: 1),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "DCDCCA"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "D9D9CB"),
        
        ColorController.KeypadCharacter:UIColor.black,
        ColorController.RowLabel:UIColor.black
    ]),
    
    "Black":.init(name: "Black", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "222322"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "343534"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "236FE2"),
        
        ColorController.KeypadCharacter:UIColor.white,
        ColorController.RowLabel:UIColor.white
    ]),
    
    "Blue":.init(name: "Blue", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "205CB7"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "1F53A3"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "2358AA"),
        
        ColorController.KeypadCharacter:UIColor.white,
        ColorController.RowLabel:UIColor.white
    ]),
    
    "Red":.init(name: "Red", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "F9334B"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "CF2A3D"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "E2283D"),
        
        ColorController.KeypadCharacter:UIColor.black,
        ColorController.RowLabel:UIColor.black
    ]),
    
    "Yellow":.init(name: "Yellow", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "F4D801"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "E0CA1D"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "E8D01A"),
        
        ColorController.KeypadCharacter:UIColor.black,
        ColorController.RowLabel:UIColor.black
    ]),
    
    "Purple":.init(name: "Purple", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "AB94FF"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "917BE4"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "9E88F1"),
        
        ColorController.KeypadCharacter:UIColor.black,
        ColorController.RowLabel:UIColor.black
    ]),
    
    "Cyan":.init(name: "Cyan", colors: [
        ColorController.MainBackground:UIColor.fromHex(hex: "2E96B5"),
        
        ColorController.StandardKeyBackground:UIColor.fromHex(hex: "2A88A5"),
        ColorController.OperationKeyBackground:UIColor.fromHex(hex: "3192B0"),
        
        ColorController.KeypadCharacter:UIColor.white,
        ColorController.RowLabel:UIColor.white
    ]),
]
