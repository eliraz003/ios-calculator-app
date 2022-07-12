//
//  UIToast.swift
//  calc
//
//  Created by Eliraz Atia on 11/07/2022.
//

import Foundation
import UIKit

class UIToast: UIButton {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    @discardableResult init(label: String) {
        super.init(frame: CGRect.zero)
        if let key = UIApplication.shared.keyWindow {
            print(key.safeAreaInsets)
            self.translatesAutoresizingMaskIntoConstraints = false
            key.addSubview(self)
            self.leftAnchor.constraint(equalTo: key.leftAnchor, constant: Dimensions.keypadPadding).isActive = true
            self.rightAnchor.constraint(equalTo: key.rightAnchor, constant: -Dimensions.keypadPadding).isActive = true
            self.bottomAnchor.constraint(equalTo: key.bottomAnchor, constant: -32).isActive = true
            
            self.titleLabel?.numberOfLines = 0
            self.setTitle(label, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .systemBlue
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
            self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 36, bottom: 16, right: 36)
            
            self.layoutIfNeeded()
            self.layer.cornerRadius = 22
            
            self.transform = CGAffineTransform(translationX: 0, y: 100)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: 100)
                }, completion: { _ in self.removeFromSuperview() })
            })
        }
    }
}
