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
class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let titleLabel = UIImageView(image: UIImage(named: "settings"))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 52).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(description)
        description.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        description.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        description.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        description.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        description.text = "Lorem ipsum dor amir del aromeiec ecme vrjme llrlv tbtk"
        description.textColor = .white.withAlphaComponent(0.6)
        description.textAlignment = .center
        description.numberOfLines = 0
        
        
        let activeTheme = ViewController.interfaceDelegate.getTheme()
        let themeSelector = UIScrollableSelector(title: "Theme", items: themes.values.map({ return $0 }), render: { item in
            let newView = UIThemeView(theme: item, isCurrent: (activeTheme.name == item.name))
            newView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            newView.widthAnchor.constraint(equalToConstant: 110).isActive = true
            return newView
        })
        themeSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeSelector)
        themeSelector.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 26).isActive = true
        themeSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        themeSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        
        let buttons: [(String, UIImage?, (UIMenuButton) -> Void)] = [
            ("Manage Currerncies", UIImage(systemName: "creditcard"), { _ in
                self.present(UnitSelectionViewController(selected: nil, onSelect: nil), animated: true)
            }),
            
            ("Disable Ads (Support The App)", UIImage(systemName: "bell.slash"), { _ in
                guard let donateURL = URL(string: "https://www.apple.com") else { return }
                UIApplication.shared.open(donateURL)
            }),
            
            ("Report Bug", UIImage(systemName: "megaphone"), { _ in
                guard let supportURL = URL(string: "https://www.apple.com/support") else { return }
                UIApplication.shared.open(supportURL)
            }),
            
            ("Visit Webiste", UIImage(systemName: "globe"), { _ in
                guard let url = URL(string: "https://www.google.com") else { return }
                UIApplication.shared.open(url)
            }),
        ]
        
        var previous: UIView?
        buttons.forEach({ button in
            let newButton = UIMenuButton(label: button.0, icon: button.1, action: button.2)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(newButton)
            newButton.topAnchor.constraint(equalTo: previous?.bottomAnchor ?? themeSelector.bottomAnchor, constant: (previous == nil) ? 16 : 0).isActive = true
            newButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            newButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            
            previous = newButton
        })
    }
}
