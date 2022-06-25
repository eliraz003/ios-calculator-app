//
//  UIkeypadButton.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UIKeypadButtonLabel: UILabel {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(text: String) {
        super.init(frame: CGRect.zero)
        
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = Dimensions.keyFontsize
        ColorController.appendToList(key: ColorController.KeypadCharacter, item: self)
    }
}

class UIKeypadButtonIcon: UIImageView
{
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(icon: UIImage) {
        super.init(frame: CGRect.zero)
        
        self.tintColor = UIColor.black
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = icon
        ColorController.appendToList(key: ColorController.KeypadCharacter, item: self)
    }
}

class UIKeypadButton: UIView {
//    let label = UILabel()
//    let icon = UIImageView()
    
//    private var text: String
    
    private var action: KeypadInteraction
    private var onClick: ((KeypadInteraction) -> Void)!
    
//    var border = UIView()
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(action: KeypadInteraction, onClick: @escaping (KeypadInteraction) -> Void) { //(text: String, action: @escaping (String) -> Void) {
//        self.text = text
        self.action = action
        self.onClick = onClick
        super.init(frame: CGRect.zero)
        
//        self.action = action
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        self.layer.cornerRadius = (Dimensions.keyHeight / 2)
        
        let renderable = action.getRenderer()
        addSubview(renderable)
        renderable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        renderable.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true

//        if (keypadLabelIcons[text] == nil) {
//            addSubview(label)
//            label.text = text
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
//
//            label.font = Dimensions.keyFontsize
//            ColorController.appendToList(key: ColorController.KeypadCharacter, item: label)
//        } else {
//            addSubview(icon)
//            icon.tintColor = UIColor.black
//            icon.isUserInteractionEnabled = false
//            icon.translatesAutoresizingMaskIntoConstraints = false
//            icon.image = keypadLabelIcons[text]
//            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
//            ColorController.appendToList(key: ColorController.KeypadCharacter, item: icon)
//        }
        
//        addSubview(border)
//        border.translatesAutoresizingMaskIntoConstraints = false
//        border.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//        border.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        border.backgroundColor = UIColor.black.withAlphaComponent(0.03)
//        border.isHidden = true
    }
    
    @objc func tapped() {
        onClick(action)

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
}

