//
//  UIDotsIndicator.swift
//  calc
//
//  Created by Eliraz Atia on 03/07/2022.
//

import Foundation
import UIKit

class UIDotsIndicator: UIView {
    private var dots: [UIView] = []
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(count: Int) {
        super.init(frame: CGRect.zero)
        
        let size: CGFloat = 8
        let gap: CGFloat = 12
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        var i = 0
        while (i < count) {
            let newView = UIView(frame: CGRect(x: (CGFloat(i)*size)+(CGFloat(i)*gap), y: 0, width: size, height: size))
            newView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(newView)
            
            ColorController.appendToList(key: ColorController.RowLabel, item: newView)
            newView.layer.cornerRadius = (size / 2)
            
            i += 1
            dots.append(newView)
        }
        
        self.layoutIfNeeded()
        self.widthAnchor.constraint(equalToConstant: dots.last?.frame.maxX ?? 0).isActive = true
        
        setIndex(index: 0)
    }
    
    func setIndex(index: Int) {
        for dot in dots { dot.alpha = 0.3 }
        dots[index].alpha = 1
    }
}
