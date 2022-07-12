//
//  UIFavouriteButton.swift
//  calc
//
//  Created by Eliraz Atia on 04/07/2022.
//

import Foundation
import UIKit

//class UIFavouriteButton: UIButton {
//    var action: () -> Void
//    var unit: Currency
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//    init(unit: Currency, action: @escaping () -> Void) {
//        self.action = action
//        self.unit = unit
//
//        super.init(frame: CGRect.zero)
//
//        self.contentEdgeInsets = .init(top: 6, left: 12, bottom: 6, right: 12)
//        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        self.setTitleColor(.white, for: .normal)
//        self.backgroundColor = .white.withAlphaComponent(0.15)
//        self.setTitle(unit.isoCode, for: .normal)
//        self.layer.cornerRadius = 12
//        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
//    }
//
//    @objc func tapped() {
//        self.action()
//    }
//}

class UIFavouriteButton: UIView {
    var action: () -> Void
    var unit: Currency
    
    let symbolLabel = UILabel()
    let titleLabel = UILabel()
    let valueLabel = UILabel()
//    let statusIndicator = UIActivityIndicatorView(style: .medium)
    
    private let verticalEdgeInset: CGFloat = 8
    private let horizontalEdgeInset: CGFloat = 12
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(unit: Currency, action: @escaping () -> Void) {
        self.action = action
        self.unit = unit
        
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolLabel)
        symbolLabel.text = (unit.getSymbol().count == 3) ? "" : unit.getSymbol()
        symbolLabel.font = .monospacedSystemFont(ofSize: 18, weight: .semibold)
        symbolLabel.textColor = .white
        symbolLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalEdgeInset).isActive = true
        symbolLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalEdgeInset).isActive = true
        
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.text = unit.isoCode
        titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalEdgeInset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalEdgeInset).isActive = true

        
    
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        valueLabel.text = "..."
        valueLabel.textColor = .white.withAlphaComponent(0.3)
        valueLabel.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalEdgeInset).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalEdgeInset).isActive = true
        
        unit.fetchValue({ result, err in
            if (err != nil) {
                self.valueLabel.text = "Failed"
                self.valueLabel.textColor = .systemRed
                return
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            let valueAsString = formatter.string(from: NSNumber(value: Double(result?.rate ?? 0))) ?? "0"
            self.valueLabel.text = "€" + valueAsString
            self.valueLabel.textColor = .systemGreen
        })
        
        
        self.widthAnchor.constraint(equalToConstant: 86).isActive = true
        self.backgroundColor = .white.withAlphaComponent(0.15)
        self.layer.cornerRadius = 12
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped() {
//        addSubview(statusIndicator)
//        layoutIfNeeded()
//        statusIndicator.frame.origin = CGPoint(
//            x: (self.frame.width / 2) - (statusIndicator.frame.width / 2),
//            y: (self.frame.height / 2) - (statusIndicator.frame.height / 2))
//
//        statusIndicator.isHidden = false
//        statusIndicator.startAnimating()
//
//        titleLabel.layer.opacity = 0
//        valueLabel.layer.opacity = 0
//
        self.action()
    }
}
