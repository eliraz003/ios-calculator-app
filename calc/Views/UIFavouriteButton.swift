//
//  UIFavouriteButton.swift
//  calc
//
//  Created by Eliraz Atia on 04/07/2022.
//

import Foundation
import UIKit

class UIFavouriteButton: UIButton {
    var action: () -> Void
    var unit: Currency
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(unit: Currency, action: @escaping () -> Void) {
        self.action = action
        self.unit = unit
        
        super.init(frame: CGRect.zero)
        
        self.contentEdgeInsets = .init(top: 6, left: 12, bottom: 6, right: 12)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .white.withAlphaComponent(0.15)
        self.setTitle(unit.isoCode, for: .normal)
        self.layer.cornerRadius = 12
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        self.action()
    }
}
