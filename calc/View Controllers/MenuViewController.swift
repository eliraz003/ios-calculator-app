//
//  MenuViewController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class MenuThemeSelector: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        title.text = "Themes"
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let scroller = UIScrollView()
        scroller.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroller)
        scroller.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        scroller.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        scroller.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6).isActive = true
        scroller.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let active = ViewController.interfaceDelegate.getTheme()
        var previous: UIView?
        themes.forEach({ theme in
            let newView = UIThemeView(theme: theme.value, isCurrent: (active.name == theme.value.name))
            newView.translatesAutoresizingMaskIntoConstraints = false
            scroller.addSubview(newView)
            newView.leftAnchor.constraint(equalTo: previous?.rightAnchor ?? scroller.leftAnchor, constant: (previous == nil) ? 0 : 6).isActive = true
            newView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            newView.widthAnchor.constraint(equalToConstant: 110).isActive = true
            newView.topAnchor.constraint(equalTo: scroller.topAnchor, constant: 0).isActive = true
            
            previous = newView
        })
        
        layoutIfNeeded()
        scroller.contentSize = CGSize(width: previous?.frame.maxX ?? 0, height: scroller.contentSize.height)
        
        self.bottomAnchor.constraint(equalTo: scroller.bottomAnchor, constant: 12).isActive = true
        
    }
}

class MenuButton: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(label: String, icon: UIImage?, action: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        iconView.image = icon
        iconView.tintColor = UIColor.white
        
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 6).isActive = true
        title.text = label
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        border.backgroundColor = .white.withAlphaComponent(0.1)
    }
}

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
        
        
        let themeSelector = MenuThemeSelector()
        themeSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeSelector)
        themeSelector.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 26).isActive = true
        themeSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        themeSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        
        let buttons: [(String, UIImage?)] = [
            ("Manage Currerncies", UIImage(systemName: "creditcard")),
            ("Report Bug", UIImage(systemName: "megaphone")),
            ("Visit Webiste", UIImage(systemName: "globe")),
        ]
        
        var previous: UIView?
        buttons.forEach({ button in
            let newButton = MenuButton(label: button.0, icon: button.1, action: {
                print("ACTION")
            })
            newButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(newButton)
            newButton.topAnchor.constraint(equalTo: previous?.bottomAnchor ?? themeSelector.bottomAnchor, constant: (previous == nil) ? 16 : 0).isActive = true
            newButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            newButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            newButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
            
            previous = newButton
        })
    }
}
