//
//  ThemeView.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UIThemeView: UIView {
    var theme: Theme!
    
    convenience init(theme: Theme, isCurrent: Bool) {
        self.init(frame: CGRect.zero)
        
        self.theme = theme
        
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        addSubview(color)
        color.backgroundColor = theme.colors[ColorController.MainBackground]
        color.layer.cornerRadius = 6
        NSLayoutConstraint.activate([
            color.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            color.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2),
            color.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            color.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.backgroundColor = theme.colors[ColorController.RowLabel]?.withAlphaComponent(0.1)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = theme.name
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = theme.colors[ColorController.RowLabel]?.withAlphaComponent(0.9)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: color.leftAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: color.bottomAnchor, constant: -6),
            label.rightAnchor.constraint(equalTo: color.rightAnchor, constant: 0),
            
            border.leftAnchor.constraint(equalTo: color.leftAnchor, constant: 8),
            border.rightAnchor.constraint(equalTo: color.rightAnchor, constant: -8),
            border.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -6),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if (isCurrent) {
            let tick = UIImageView()
            tick.image = UIImage(named: "tick_bounded")
            addSubview(tick)
            tick.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tick.widthAnchor.constraint(equalToConstant: 28),
                tick.heightAnchor.constraint(equalToConstant: 28),
                tick.rightAnchor.constraint(equalTo: color.rightAnchor, constant: 4),
                tick.topAnchor.constraint(equalTo: color.topAnchor, constant: -4)
            ])
        }
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }

    @objc func click() {
        ViewController.interfaceDelegate.setTheme(theme: theme)
        ViewController.interfaceDelegate.forceDismiss()
    }
}
