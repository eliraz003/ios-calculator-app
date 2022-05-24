//
//  Theme.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

struct Theme {
    var name: String
    var color: UIColor
    var colors: [String : UIColor] = [:]
    
    internal init(name: String, color: UIColor, colors: [String : UIColor] = [:]) {
        self.name = name
        self.color = color
        self.colors = colors
    }
    
    internal init(name: String, colors: [String : UIColor] = [:]) {
        self.name = name
        self.color = UIColor.black
        self.colors = colors
    }
}
