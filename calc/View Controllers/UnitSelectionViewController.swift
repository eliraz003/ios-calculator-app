//
//  UnitSelectionViewController.swift
//  calc
//
//  Created by Eliraz Atia on 04/07/2022.
//

import Foundation
import UIKit

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
                return UIFavouriteButton(unit: asCurrency, action: {
                    self.onSelect(asCurrency, {})
                })
            })
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onSelect: (Currency, @escaping () -> Void) -> Void = {_,_ in}
    var unitButtons: [UIMenuButton] = []
    
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

            let button = UIMenuButton(label: item.name, leftAccessory: label, rightAccessory: starButton, action: { button in
                button.backgroundColor = .orange
                self.onSelect(item, { button.backgroundColor = nil })
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
