//
//  MenuViewController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class UIScrollableSelector<T:Any>: UIView {
    let scroller = UIScrollView()
    
    private var scrollerHeightAnchor: NSLayoutConstraint!
    private var selfBottomAnchor: NSLayoutConstraint!
    
    var items: [T]
    var render: (T) -> UIView
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(title displayTitle: String, items: [T], render: @escaping (T) -> UIView) {
        self.items = items
        self.render = render
        
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        title.text = displayTitle
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        border.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        scroller.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroller)
        scroller.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        scroller.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        scroller.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 6).isActive = true
        
        refresh()
    }
    
    @discardableResult func refresh() -> UIView? {
        scroller.subviews.forEach({ $0.removeFromSuperview() })
        
        var previous: UIView?
        items.forEach({ item in
            let newView = render(item)
            newView.translatesAutoresizingMaskIntoConstraints = false
            scroller.addSubview(newView)
            newView.leftAnchor.constraint(equalTo: previous?.rightAnchor ?? scroller.leftAnchor, constant: (previous == nil) ? 0 : 6).isActive = true
            newView.topAnchor.constraint(equalTo: scroller.topAnchor, constant: 0).isActive = true
            
            previous = newView
        })
        
        layoutIfNeeded()
        scroller.contentSize = CGSize(width: previous?.frame.maxX ?? 0, height: scroller.contentSize.height)
        
        if (scrollerHeightAnchor != nil && scrollerHeightAnchor != nil) {
            scroller.removeConstraint(scrollerHeightAnchor)
            self.removeConstraint(scrollerHeightAnchor)
        }
        
        scrollerHeightAnchor = scroller.heightAnchor.constraint(equalToConstant: previous?.frame.height ?? 0)
        selfBottomAnchor = self.bottomAnchor.constraint(equalTo: scroller.bottomAnchor, constant: 12)
        scrollerHeightAnchor.isActive = true
        selfBottomAnchor.isActive = true
        
        return previous
    }
}

class MenuButton: UIButton {
    var label: String!
    var leftAccessory: UIView?
    var rightAccessory: UIView?
    var action: ((MenuButton) -> Void)!
    
    var configureMenu: () -> UIMenu? = { return nil }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    private func initialize() {
        if (leftAccessory != nil) { addSubview(leftAccessory!) }
        leftAccessory?.translatesAutoresizingMaskIntoConstraints = false
        leftAccessory?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        leftAccessory?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        if (rightAccessory != nil) { addSubview(rightAccessory!) }
        rightAccessory?.translatesAutoresizingMaskIntoConstraints = false
        rightAccessory?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        rightAccessory?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.leftAnchor.constraint(equalTo: leftAccessory?.rightAnchor ?? self.leftAnchor, constant: 6).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: (rightAccessory == nil) ? -6 : -24).isActive = true
        title.text = label
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        border.backgroundColor = .white.withAlphaComponent(0.1)
        
        self.topAnchor.constraint(equalTo: title.topAnchor, constant: -12).isActive = true
        self.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
//
//        self.isUserInteractionEnabled = true
//        self.isContextMenuInteractionEnabled = true
        
//        self.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
//    @discardableResult func configureMenuAs(_ configuration: @escaping () -> UIMenu?) -> MenuButton {
//        self.configureMenu = configuration
//        self.menu = configureMenu()
//        return self
//    }
//
    convenience init(label: String, leftAccessory: UIView?, rightAccessory: UIView?, action: @escaping (MenuButton) -> Void) {
        self.init()
        
        self.label = label
        self.leftAccessory = leftAccessory
        self.rightAccessory = rightAccessory
        self.action = action
        
        initialize()
    }
    
    convenience init(label: String, icon: UIImage?, action: @escaping (MenuButton) -> Void) {
        self.init()
        
        let iconView = UIImageView()
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.image = icon
        iconView.tintColor = UIColor.white
        
        self.label = label
        self.leftAccessory = iconView
        self.action = action
        
        initialize()
    }
    
    @objc func tapped() {
        self.action(self)
    }
}

class FavouriteUnitButton: UIButton {
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

class UnitSelectionViewController: UIViewController {
    let titleLabel: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.attributedPlaceholder = NSAttributedString(
            string: "Find Currency...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)]
        )
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 26, weight: .black)
        view.textAlignment = .left
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var favouriteUnitSelector: UIScrollableSelector<String> = {
        var view: UIScrollableSelector<String>!
        if (SavedCurrencyController.shared.savedCurrencies.count == 0) {
            view = UIScrollableSelector(title: "Favourite Currencies", items: [""], render: { item in
                let label = UILabel()
                label.textColor = UIColor.white
                label.text = "Swipe On A Unit To Favourite It!"
                label.alpha = 0.6
                return label
            })
        } else {
            let items = SavedCurrencyController.shared.savedCurrencies.keys.map({ return String($0) })
            view = UIScrollableSelector(title: "Favourite Currencies", items: items, render: { item in
                let asCurrency = currencyUnits[item] as! Currency
                return FavouriteUnitButton(unit: asCurrency, action: {
                    self.onSelect(asCurrency, {})
                })
            })
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onSelect: (Currency, @escaping () -> Void) -> Void = {_,_ in}
    var unitButtons: [MenuButton] = []
    
    let unitView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    convenience init(selected: String?, onSelect: ((Unit) -> Void)?) {
        self.init()
        
        self.onSelect = { unit, callback in
            unit.fetchValue({ (foundUnit, error) in
                if (error != nil || foundUnit == nil) {
                    print("DISPLAY ERROR")
                }
                
                onSelect?(foundUnit!)
                callback()
                self.dismiss(animated: true)
            })
        }
        
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        let iconView = UIImageView()
        scrollView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        iconView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 46).isActive = true
        iconView.tintColor = UIColor.white.withAlphaComponent(0.4)
        iconView.image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22, weight: .medium)))
        
        scrollView.addSubview(titleLabel)
        titleLabel.addTarget(self, action: #selector(onInputChange), for: .editingChanged)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true

    
        scrollView.addSubview(favouriteUnitSelector)
        favouriteUnitSelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18).isActive = true
        favouriteUnitSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        favouriteUnitSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        
        scrollView.addSubview(unitView)
        unitView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        unitView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        unitView.topAnchor.constraint(equalTo: favouriteUnitSelector.bottomAnchor, constant: 12).isActive = true
        
        
        refreshCurrencyList()
    }
    
    @objc func onInputChange() {
        print("input has changed")
        refreshCurrencyList()
    }
    
    private func findItemsToShow() -> [Currency] {
        let units = currencyUnits.sorted(by: { return $0.value.name < $1.value.name }).filter({ currency in
            guard let asCurrency = currency.value as? Currency else { return false }
            
            let filter = (titleLabel.text ?? "").uppercased()
            if (filter == "") { return true }
            
            return asCurrency.isoCode.uppercased().contains(filter) ||
                asCurrency.name.uppercased().contains(filter)
        })
        
        return units.map({ return $0.value as! Currency })
    }

    private func refreshScrollList() {
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: unitButtons.last?.frame.maxY ?? 0)
    }
    
    private func refreshCurrencyList() {
        let list = findItemsToShow()
        
        unitButtons.forEach({ $0.removeFromSuperview() })
        
        var previous: UIView?
        list.forEach(({ item in
            let label = UIButton()
            label.widthAnchor.constraint(equalToConstant: 40).isActive = true
            label.contentEdgeInsets = .init(top: 2, left: 4, bottom: 2, right: 4)
            label.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            label.setTitleColor(.white, for: .normal)
            label.backgroundColor = .white.withAlphaComponent(0.1)
            label.setTitle(item.isoCode, for: .normal)
            label.layer.cornerRadius = 8
            label.titleLabel?.numberOfLines = 0
            
            
            let starButton = UIClickableImageView(action: {})
//            starButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
//            starButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
            
            func refreshStarredState() {
                let isStarred = (SavedCurrencyController.shared.savedCurrencies.contains(where: { return $0.value == true && $0.key == item.isoCode }))
                starButton.image = UIImage(systemName: "star.fill")
                if (isStarred) {
                    starButton.tintColor = UIColor.blue
                } else {
                    starButton.tintColor = UIColor.white
                }
                
                starButton.action = {
                    SavedCurrencyController.shared.save(currency: item, state: !isStarred)
                    refreshStarredState()
                }
            }
            
            refreshStarredState()

            let button = MenuButton(label: item.name, leftAccessory: label, rightAccessory: starButton, action: { button in
                button.backgroundColor = .orange
                self.onSelect(item, {
                    button.backgroundColor = nil
                })
                
//                item.fetchValue({ (unit, error) in
//                    button.backgroundColor = nil
//                    if (error != nil || unit == nil) {
//                        print("DISPLAY ERROR")
//                    }
//
//                    self.onSelect?(unit!)
//                    self.dismiss(animated: true)
//                })
            })
            
            button.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(button)
            button.topAnchor.constraint(equalTo: previous?.bottomAnchor ?? unitView.topAnchor, constant: (previous == nil) ? 0 : 4).isActive = true
            button.leftAnchor.constraint(equalTo: unitView.leftAnchor, constant: 0).isActive = true
            button.rightAnchor.constraint(equalTo: unitView.rightAnchor, constant: 0).isActive = true
            
            unitButtons.append(button)
            previous = button
        }))

        refreshScrollList()
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

        
        let buttons: [(String, UIImage?, (MenuButton) -> Void)] = [
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
            let newButton = MenuButton(label: button.0, icon: button.1, action: button.2)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(newButton)
            newButton.topAnchor.constraint(equalTo: previous?.bottomAnchor ?? themeSelector.bottomAnchor, constant: (previous == nil) ? 16 : 0).isActive = true
            newButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            newButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            
            previous = newButton
        })
    }
}
