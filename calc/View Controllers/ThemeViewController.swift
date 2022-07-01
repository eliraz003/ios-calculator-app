//
//  ThemeViewController.swift
//  calc
//
//  Created by Eliraz Atia on 23/04/2022.
//

import Foundation
import UIKit


//TODO: TO REMOVE
/**
 ThemeViewController is used to show the user the availiable themes in the app
 */
class ThemeViewController: HeaderViewController {
    override var viewTitle: String { return "Set Theme" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let active = ViewController.interfaceDelegate.getTheme()
        
        var index = 0
        var lastRow: UIView? = nil
        themes.sorted(by: {
            return $0.key > $1.key
        }).forEach({ theme in
            let isLeft = (index % 2 == 0)
            
            let newView = UIThemeView(theme: theme.value, isCurrent: (active.name == theme.value.name))
            view.addSubview(newView)
            newView.topAnchor.constraint(equalTo: lastRow?.bottomAnchor ?? titleLabel.bottomAnchor, constant: (lastRow == nil) ? 12 : 6).isActive = true
            if (!isLeft) {
                newView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 3).isActive = true
                newView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
                lastRow = newView
            } else {
                newView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
                newView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -3).isActive = true
            }
            
            index += 1
        })
    }
}

