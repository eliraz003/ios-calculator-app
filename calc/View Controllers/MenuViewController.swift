//
//  MenuViewController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

/**
 MenuViewController is the view presented when opening the menu using the three button dots on the keypad,
 this view shows the options that the user can select, such as themes and manage currencies
 */
class MenuViewController: HeaderViewController {
    override var viewTitle: String { return "More Options" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeButton = UIMenuActionButton(label: "Change Theme", actionIcon: UIImage(systemName: "paintpalette.fill"), showBackground: true, action: {
            self.present(ThemeViewController(), animated: true, completion: nil)
        })
        view.addSubview(themeButton)
        themeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        themeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        themeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        
        let seeAllCurrenciesButton = UIMenuActionButton(label: "Manage Currencies", actionIcon: UIImage(systemName: "coloncurrencysign.circle"), showBackground: true, action: {
            self.present(SearchUnitViewController(selected: nil, onSelect: nil), animated: true, completion: nil)
        })
        view.addSubview(seeAllCurrenciesButton)
        seeAllCurrenciesButton.topAnchor.constraint(equalTo: themeButton.bottomAnchor, constant: 4).isActive = true
        seeAllCurrenciesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        seeAllCurrenciesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        
        let reportButton = UIMenuActionButton(label: "Visit Our Website!", actionIcon: UIImage(systemName: "globe"), showBackground: false, action: {
            if let url = URL(string: "https://calculatooor-ios.web.app/") { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
        })
        view.addSubview(reportButton)
        reportButton.topAnchor.constraint(equalTo: seeAllCurrenciesButton.bottomAnchor, constant: 4).isActive = true
        reportButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        reportButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
    }
}
