//
//  MenuButton.swift
//  calc
//
//  Created by Eliraz Atia on 04/07/2022.
//

import Foundation
import UIKit

class UIMenuButton: UIButton {
    var label: String!
    var leftAccessory: UIView?
    var rightAccessory: UIView?
    var action: ((UIMenuButton) -> Void)!
    
    var configureMenu: () -> UIMenu? = { return nil }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    private func initialize() {
        if (leftAccessory != nil) { addSubview(leftAccessory!) }
        leftAccessory?.translatesAutoresizingMaskIntoConstraints = false
        leftAccessory?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        leftAccessory?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        if (rightAccessory != nil) { addSubview(rightAccessory!) }
        rightAccessory?.translatesAutoresizingMaskIntoConstraints = false
        rightAccessory?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        rightAccessory?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.leftAnchor.constraint(equalTo: leftAccessory?.rightAnchor ?? self.leftAnchor, constant: 6).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: (rightAccessory == nil) ? -6 : -24).isActive = true
        title.text = label
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        border.backgroundColor = .white.withAlphaComponent(0.1)
        
        self.topAnchor.constraint(equalTo: title.topAnchor, constant: -12).isActive = true
        self.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    convenience init(label: String, leftAccessory: UIView?, rightAccessory: UIView?, action: @escaping (UIMenuButton) -> Void) {
        self.init()
        
        self.label = label
        self.leftAccessory = leftAccessory
        self.rightAccessory = rightAccessory
        self.action = action
        
        initialize()
    }
    
    convenience init(label: String, icon: UIImage?, action: @escaping (UIMenuButton) -> Void) {
        self.init()
        
        let iconView = UIImageView()
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.image = icon
        iconView.tintColor = UIColor.white
        
        self.label = label
        self.leftAccessory = iconView
        self.action = action
        
        initialize()
    }
    
    @objc func tapped() {
        self.action(self)
    }
}
