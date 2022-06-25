//
//  UIKeypadRow.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UIKeypadRow: UIStackView {
    var existingButtons: [UIKeypadButton] = []
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(actions: [KeypadInteraction], _ onAction: @escaping (KeypadInteraction) -> Void) {
        super.init(frame: CGRect.zero)
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        self.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
        
        for action in actions {
            let button = UIKeypadButton(action: action, onClick: {
                print("DID CLICK", $0)
            }) //UIKeypadButton(text: "4", action: { _ in print("Click") }) // replace with new implemetation
            ColorController.appendToList(key: action.colorControllerPattern(), item: button)
            button.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(button)
        
            button.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
            existingButtons.append(button)
        }
    }
    
//    init(labels: [String], action: @escaping (String) -> Void, supersizedFirst: Bool = false) {
//        super.init(frame: CGRect.zero)
//        self.axis = .horizontal
//        self.distribution = .equalSpacing
//        self.alignment = .center
//        self.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
//                
//        var index = 0
//        while (index < ((supersizedFirst) ? 3 : 4)) {
//            let button = UIKeypadButton(text: labels[index], action: action)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            addArrangedSubview(button)
//
//            let usesIcon = (keypadLabelIcons[labels[index]] != nil || labels[index] == "ANS")
//            button.border.alpha = (index == 0) ? 0 : 1
//            button.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
////            buttons.append(button)
//            
//            ColorController.appendToList(key: (usesIcon) ? ColorController.OperationKeyBackground : ColorController.StandardKeyBackground, item: button)
//            index += 1
//        }
//        
//        let border = UIView()
//        addSubview(border)
//        border.translatesAutoresizingMaskIntoConstraints = false
//        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
//        border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        border.backgroundColor = UIColor.black.withAlphaComponent(0.03)
//        border.isHidden = true
//    }
    
    override func didMoveToSuperview() {
        if (superview == nil) { return }
        
        /**
         Use DispatchQueue.main.asyncAfter to ensure that the constraints have been placed for the row to correctly calculate it's size
         (However, could be better setup by using the UIStackView properties)
         */
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10), execute: {
            self.layoutIfNeeded()
            self.existingButtons.forEach({
                $0.widthAnchor.constraint(equalToConstant: (self.frame.width / CGFloat(self.existingButtons.count)) - (Dimensions.keypadKeySpacing)).isActive = true
            })
        })
    }
}
