//
//  ColorController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class ColorController {
    static var shared = ColorController()
    
    var list: [String : [(UIView, ((UIColor) -> UIColor)?)]] = [:]
    var currentColours: [String : UIColor] = [:]
    
    static func appendToList(key: String, item: UIView, handler: ((UIColor) -> UIColor)? = nil) {
        if (shared.list[key] == nil) {
            shared.list[key] = []
        }

        print("List before change", shared.list.count)
        shared.list[key] = shared.list[key]?.filter({ return $0.0 != item })
        print("List after change", shared.list.count)
        
        shared.list[key]!.append((item, handler))
        update(key: key, view: item, toColor: colorFor(key: key, trouple: (item, handler)))
    }
    
    static func colorFor(key: String, trouple: (UIView, ((UIColor) -> UIColor)?)) -> UIColor {
        let newColor = shared.currentColours[key] ?? UIColor.black
        if (trouple.1 == nil) {
            return newColor
        } else {
            return trouple.1!(newColor)
        }
    }
    
    static func update(key: String, view: UIView, toColor newColor: UIColor) {
        if let asLabel = view as? UILabel {
            asLabel.textColor = newColor
        } else if let asImage = view as? UIImageView {
            asImage.tintColor = newColor
        } else if let asButton = view as? UIButton {
            asButton.setTitleColor(newColor, for: .normal)
        } else {
            view.backgroundColor = newColor
        }
    }
    
    static func dispatchChange(colours: [String : UIColor]) {
        shared.currentColours = colours
        shared.currentColours[ColorController.RowLabelError] = UIColor.fromHex(hex: "8B0E0E")
        
        shared.list.forEach({ item in
            item.value.forEach({ view in update(key: item.key, view: view.0, toColor: colorFor(key: item.key, trouple: view)) }) //(view.1 == nil) ? newColor : view.1!(newColor)})
        })
    }
}

extension ColorController {
    static var KeypadCharacter: String = "KeypadCharacter"
    static var RowLabel: String = "RowLabel"
    static var RowLabelError: String = "RowLabelError"
    
    static var MainBackground: String = "MainBackground"
    
    static var OperationKeyBackground: String = "OperationKeyBackground"
    static var StandardKeyBackground: String = "StandardKeyBackground"
}
