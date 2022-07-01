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
    init(text: String, useMonoFont: Bool = false) {
        super.init(frame: CGRect.zero)
        
        self.text = text
        self.accessibilityIdentifier = nil
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = (useMonoFont) ? Dimensions.monoKeyFontsize : Dimensions.keyFontsize
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
    private var action: KeypadInteraction
    private var onClick: ((KeypadInteraction) -> Void)!
        
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(action: KeypadInteraction, onClick: @escaping (KeypadInteraction) -> Void) {
        self.action = action
        self.onClick = onClick
        super.init(frame: CGRect.zero)
        
        self.layer.cornerRadius = (Dimensions.keyHeight / 2)
        self.accessibilityIdentifier = action.accessibilityLabel()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        let renderable = action.getRenderer()
        
        addSubview(renderable)
        renderable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        renderable.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
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

