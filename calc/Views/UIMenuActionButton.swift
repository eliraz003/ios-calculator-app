//
//  MenuActionButton.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UIMenuActionButton: UIView {
    var action: () -> Void = {}
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(label textLabel: String, actionIcon: UIImage?, showBackground: Bool, action: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.action = action
        
        let bgColor = UIColor(named: "menu_button_background")?.withAlphaComponent(0.4)
        let textColor = UIColor(named: "menu_button_text")
        let textColorNoBackground = UIColor(named: "primary_text")
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = (showBackground) ? bgColor : UIColor.white.withAlphaComponent(0)
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.layer.cornerRadius = 6
        
        let icon = UIImageView(image: actionIcon)
        icon.tintColor = (showBackground) ? textColor : textColorNoBackground
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = textLabel
        label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .medium)
        label.textColor = (showBackground) ? textColor : textColorNoBackground
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressed)))
    }
    
    @objc func pressed() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            self.transform = CGAffineTransform.identity
        })
        
        action()
    }
}
