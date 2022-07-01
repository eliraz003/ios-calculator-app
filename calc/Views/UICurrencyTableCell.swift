//
//  CurrencyTableCell.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UICurrencyTableCell: UITableViewCell {
    var isActive: Bool = false {
        didSet {
            if (isActive) {tickMark.layer.opacity = 1}
            else {tickMark.layer.opacity = 0}
        }
    }
    
    var currency: Currency? {
        didSet {
            isoLabel.text = currency?.isoCode
            countryLabel.text = currency?.name
            updateStarState()
        }
    }
    
    private let tickMark = UIImageView()
    private let starIcon = UIImageView()
    
    private let isoLabel = UILabel()
    private let countryLabel = UILabel()
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        tickMark.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tickMark)
        tickMark.widthAnchor.constraint(equalToConstant: 16).isActive = true
        tickMark.heightAnchor.constraint(equalToConstant: 16).isActive = true
        tickMark.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        tickMark.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        tickMark.image = UIImage(named: "tick")
        
        isoLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(isoLabel)
        isoLabel.text = "ISO"
        isoLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        isoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        isoLabel.leftAnchor.constraint(equalTo: tickMark.rightAnchor, constant: 6).isActive = true
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countryLabel)
        countryLabel.topAnchor.constraint(equalTo: isoLabel.bottomAnchor, constant: 0).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: isoLabel.leftAnchor, constant: 0).isActive = true
        countryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        countryLabel.text = "Country"
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        spinner.color = .darkGray
        spinner.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        spinner.alpha = 0
        
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starIcon)
        starIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        starIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        starIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        starIcon.image = UIImage(named: "tick")
        
        self.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func isSaved() -> Bool {
        return SavedCurrencyController.shared.savedCurrencies[currency?.isoCode ?? ""] ?? false
    }
    
    func updateStarState() {
        if (isSaved()) { starIcon.image = UIImage(named: "star_disabled") }
        else { starIcon.image = UIImage(named: "star_enabled") }
    }
    
    func spin() {
        spinner.alpha = 1
        spinner.startAnimating()
    }
    
    func fail() {
        spinner.alpha = 0
    }
}
