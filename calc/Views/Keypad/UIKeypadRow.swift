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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
        
        for action in actions {
            let button = UIKeypadButton(action: action, onClick: { onAction($0) })
            let colorControllerPattern = action.colorControllerPattern()
            ColorController.appendToList(key: colorControllerPattern.0, item: button, handler: colorControllerPattern.1)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(button)
        
            button.heightAnchor.constraint(equalToConstant: Dimensions.keyHeight).isActive = true
            existingButtons.append(button)
        }
    }
    
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
