//
//  UIToast.swift
//  calc
//
//  Created by Eliraz Atia on 11/07/2022.
//

import Foundation
import UIKit

class UIToast: UIView {
    var hasManuallyDismissed = false
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    @discardableResult init(label: String) {
        super.init(frame: CGRect.zero)
        if let key = UIApplication.shared.keyWindow {
            self.translatesAutoresizingMaskIntoConstraints = false
            key.addSubview(self)
            let xAnchor = self.centerXAnchor.constraint(equalTo: key.centerXAnchor, constant: 0)
            let rAnchor = self.rightAnchor.constraint(equalTo: key.rightAnchor, constant: -Dimensions.keypadPadding)
            let lAnchor = self.leftAnchor.constraint(equalTo: key.leftAnchor, constant: Dimensions.keypadPadding)
            xAnchor.isActive = true
            
            self.bottomAnchor.constraint(equalTo: key.bottomAnchor, constant: -48).isActive = true
            
            
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
            titleLabel.numberOfLines = 0
            titleLabel.font = Dimensions.toastFontsize
            titleLabel.text = label
            
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            self.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -22).isActive = true
            self.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 22).isActive = true
            self.heightAnchor.constraint(equalToConstant: 56).isActive = true
            self.layer.cornerRadius = (56 / 2)
            self.layoutIfNeeded()
            
            if (self.frame.width >= UIScreen.main.bounds.width) {
                xAnchor.isActive = false
                rAnchor.isActive = true
                lAnchor.isActive = true
            }
            
            
            ColorController.appendToList(key: ColorController.StandardKeyBackground, item: self, handler: { return $0.adjust(hueBy: 0.16, saturationBy: 0, brightnessBy: 0).withAlphaComponent(0.95) })
            ColorController.appendToList(key: ColorController.RowLabel, item: titleLabel)
            
            self.layer.shadowOffset = CGSize(width: 0, height: 12)
            self.layer.shadowRadius = 16
//            self.layer.shadowOpacity = 1
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
            titleLabel.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            
            self.transform = CGAffineTransform(translationX: 0, y: 100)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                if (!self.hasManuallyDismissed) { self.dismiss() }
            })
        }
    }
    
    @objc func click() {
        print("CLICKED")
        if (!hasManuallyDismissed) {
            hasManuallyDismissed = true
            dismiss()
        }
    }
    
    func dismiss(force: Bool = false) {
        if (force) { hasManuallyDismissed = true }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: { _ in self.removeFromSuperview() })

    }
}
