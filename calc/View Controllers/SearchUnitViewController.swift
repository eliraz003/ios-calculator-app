//
//  SearchUnitViewController.swift
//  calc
//
//  Created by Eliraz Atia on 23/04/2022.
//

import Foundation
import UIKit

/**
 SearchUnitViewController is used to search and select currencies,
 Initialize with selected and onSelect
 
 selected:String - The iso of the selected currency for the row that is presenting this search view
 onSelect:(newUnit) -> Void - A callback operator for when the user selects a currency
 */
class SearchUnitViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var selected: String?
    var setItems: [Currency] = []
    var onSelect: ((Unit) -> Void)?
    
    let tableView = UITableView()
    let textFieldSearchArea = UITextField()
    
    var recentCachedItems: [Currency]? = nil
    
    convenience init(selected: String?, onSelect: ((Unit) -> Void)?) {
        self.init()
        self.onSelect = onSelect
        self.selected = selected
        
        currencyUnits.sorted(by: { a,b in
            let aSaved = SavedCurrencyController.shared.savedCurrencies[(a.value as? Currency)?.isoCode ?? ""] ?? false
            let bSaved = SavedCurrencyController.shared.savedCurrencies[(b.value as? Currency)?.isoCode ?? ""] ?? false
            
            let isGreater = a.value.name < b.value.name
            
            if (aSaved && bSaved) {
                return isGreater
            } else {
                if (aSaved) { return true }
                else if (bSaved) { return false }
                return isGreater
            }
        }).forEach(({ item in
            setItems.append(item.value as! Currency)
        }))
        
        view.backgroundColor = UIColor(named: "background")
        
        let textFieldBackground = UIView()
        textFieldBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldBackground)
        
        textFieldBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        textFieldBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        textFieldBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        textFieldBackground.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textFieldBackground.backgroundColor = UIColor(named: "textfield") //UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        
        let textFieldIcon = UIImageView()
        textFieldIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldIcon)
        textFieldIcon.image = UIImage(systemName: "magnifyingglass")
        textFieldIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        textFieldIcon.tintColor = UIColor.systemBlue
        textFieldIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textFieldIcon.centerYAnchor.constraint(equalTo: textFieldBackground.centerYAnchor, constant: 0).isActive = true
        textFieldIcon.leftAnchor.constraint(equalTo: textFieldBackground.leftAnchor, constant: 16).isActive = true
        
        textFieldSearchArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldSearchArea)
        textFieldSearchArea.leftAnchor.constraint(equalTo: textFieldIcon.rightAnchor, constant: 12).isActive = true
        textFieldSearchArea.rightAnchor.constraint(equalTo: textFieldBackground.rightAnchor, constant: -24).isActive = true
        textFieldSearchArea.centerYAnchor.constraint(equalTo: textFieldBackground.centerYAnchor, constant: 0).isActive = true
        textFieldSearchArea.placeholder = "Search Unit (GBP, USD, AFN...)"
        textFieldSearchArea.textColor = UIColor(named: "primary_text")
        textFieldSearchArea.addTarget(self, action: #selector(didChangeCaller), for: .allEditingEvents)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: textFieldBackground.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textFieldSearchArea.becomeFirstResponder()
    }
    
    @objc func didChangeCaller() {
        if (textFieldSearchArea.text?.count == 0) {
            recentCachedItems = nil
        } else {
            recentCachedItems = setItems.filter({ currency in
                let matchesISO = currency.isoCode.uppercased().contains(textFieldSearchArea.text?.uppercased() ?? "")
                let matchesLabel = currency.name.uppercased().contains(textFieldSearchArea.text?.uppercased() ?? "")
                return (matchesISO || matchesLabel)
            })
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCachedItems?.count ?? setItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UICurrencyTableCell()
        let current = recentCachedItems?[indexPath.row] ?? setItems[indexPath.row]
        cell.currency = current
        
        if (selected != nil && selected == current.isoCode) {cell.isActive = true}
        else {cell.isActive = false}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let cell = tableView.cellForRow(at: indexPath) as? UICurrencyTableCell {
            return UISwipeActionsConfiguration(actions: [
                .init(style: .normal, title: (cell.isSaved()) ? "Unfavourite" : "Favourite", handler: { a,b,c in
                    let currency = cell.currency
                    let newState = !(SavedCurrencyController.shared.savedCurrencies[currency?.isoCode ?? ""] ?? false)
                    SavedCurrencyController.shared.save(currency: currency!, state: newState)
                    cell.updateStarState()
                    c(true)
                })
            ])
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.onSelect == nil) { return }
        
        let cell = tableView.cellForRow(at: indexPath) as? UICurrencyTableCell
        cell?.spin()
        
        let item = recentCachedItems?[indexPath.row] ?? setItems[indexPath.row] //setItems[indexPath.row]
        item.fetchValue({ (newUnit, error) in
            if (error != nil || newUnit == nil) {
                let warning = UIAlertController(title: "Failed Getting Currency Value!", message: "The server was not able to fetch the result for this currency, please contact us at elirazatia003@gmail.com if this issue persists!", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in }))
                
                cell?.fail()
                self.present(warning, animated: true, completion: nil)
            } else {
                self.onSelect!(newUnit!)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
