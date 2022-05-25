//
//  ViewController.swift
//  calc
//
//  Created by Eliraz Atia on 27/03/2022.
//

import UIKit

enum MathematicalOperation {
    case add
    case minus
    case multiply
    case divide
}

/**
 ViewController is the main view of the app
 */
class ViewController: UIViewController, UITextFieldDelegate, UIControlDelegate, UIInterfaceDelegate {
    var keypad: UIkeypadView!
    var rowsContainer: UICalculationRowsController!
    
    var mostRecentUnit: Unit?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.interfaceDelegate = self
        ViewController.controlDelegate = self
        
        keypad = UIkeypadView()
        keypad.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keypad)
        
        rowsContainer = UICalculationRowsController() //(delegate: self)
        rowsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rowsContainer)
        
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if (device == .phone) {
            keypad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            keypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            keypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.keypadBottomOffset).isActive = true

            rowsContainer.bottomAnchor.constraint(equalTo: keypad.topAnchor, constant: 0).isActive = true
            rowsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            rowsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            rowsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true

        } else if (device == .pad) {
            keypad.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            keypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            keypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
            
            rowsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
            rowsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            rowsContainer.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            rowsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        }
        
        rowsContainer.bringToLife()
        rowsContainer.addRow()
        
        ColorController.appendToList(key: ColorController.MainBackground, item: view)
        ViewController.interfaceDelegate.setTheme(theme:
            ViewController.interfaceDelegate.getTheme()
        )
    }
    
    
    //* INTERFACE DELEGATE *//
    
    func getTheme() -> Theme {
        let themeName = UserDefaults.standard.string(forKey: "@theme") ?? defaultTheme
        return themes[themeName]!
    }
    
    func setTheme(theme: Theme) {
        UserDefaults.standard.set(theme.name, forKey: "@theme")
        ColorController.dispatchChange(colours: theme.colors)
    }
    
    func openViewModally(_ view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
    
    func forceDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func isRowLast(row: UICalculationRow) -> Bool {
        return (rowsContainer.rows.last?.0 == row)
    }
    
    func isRowFirst(row: UICalculationRow) -> Bool {
        return (rowsContainer.rows.first?.0 == row)
    }
    
    
    //* UTILITY FUNCTIONS *//
    
    private func refreshRows() {
        rowsContainer.rows.forEach({ $0.0.refresh() })
        rowsContainer.totalRow.refresh()
        
        refreshTotals()
    }
    
    private func refreshTotals() {
        var total: CGFloat = 0.0
        
        var appliedUnit = false
        var index = 0
        while (index < rowsContainer.rows.count) {
            let current: UICalculationRow = rowsContainer.rows[index].0
            let previous: UICalculationRow? = (index == 0) ? nil : rowsContainer.rows[index - 1].0
            
            func getValue() -> Double {
                let value = current.getValue()
                let unit = current.getUnit()
                if (unit != nil) {
                    appliedUnit = true
                    return unit!.convertToBase(value: value)
                } else { return value }
            }
            
            switch(previous?.getOperation() ?? MathematicalOperation.add) {
            case .add:
                total += getValue(); break
            case .divide:
                let secondaryTotal = getValue()
                if (secondaryTotal != 0) { total = (total / getValue()) }
                break
            case .minus:
                total -= getValue(); break
            case .multiply:
                total = (total * getValue()); break
            }
            
            index += 1
        }
        
        var finalValue = total
        if (rowsContainer.totalRow.getUnit() != nil && appliedUnit) { finalValue = rowsContainer.totalRow.getUnit()?.convertFromBase(value: finalValue) ?? total }

        let nubmerFormatter = NumberFormatter()
        nubmerFormatter.numberStyle = .decimal
        nubmerFormatter.alwaysShowsDecimalSeparator = true
        
        let finalValueAsString = nubmerFormatter.string(from: NSNumber(value: finalValue))!
        let beforeDecimalCharacterCount = finalValueAsString.split(separator: ".").map({ i in return String(i) })[0].count
        
        var numberOfDecimalsAllowed = (8 - beforeDecimalCharacterCount)
        if (numberOfDecimalsAllowed <= 2) { numberOfDecimalsAllowed = 2 }
        if (rowsContainer.totalRow.getUnit()?.type == .currency) { numberOfDecimalsAllowed = 2 }
        
        nubmerFormatter.maximumFractionDigits = numberOfDecimalsAllowed
        var absoluteFinalValue = nubmerFormatter.string(from: NSNumber(value: finalValue))!
        
        
        if let resultAsResultOnlyUnit = rowsContainer.totalRow.getUnit() as? ResultOnlyUnit {
            rowsContainer.totalRow.setValue(newValue: resultAsResultOnlyUnit.renderResult(value: total))
        } else {
            if (absoluteFinalValue.last == ".") { absoluteFinalValue = absoluteFinalValue.replacingOccurrences(of: ".", with: "") }
            rowsContainer.totalRow.setValue(newValue: absoluteFinalValue)//(decimalValue == nil) ? mainValue : "\(mainValue).\(decimalValue!)")
        }
    }
        
        
    
    //* CONTROL DELEGATE *//
    
    func selected() -> UICalculationRow {
        return rowsContainer.getCurrent()
    }
    
    func select(row: UICalculationRow) {
        rowsContainer.setSelectedIndex(at: row)
    }
    
    func setOperationForSelected(operation: MathematicalOperation) {
        if (selected().getValue() == 0) { return }
        
        selected().setOperation(newOperation: operation)
        rowsContainer.nextRow()
        
        refreshRows()
    }
    
    func setValueForSelected(value: String) {
        selected().setValue(newValue: value)
        refreshRows()
    }
    
    
    
    func setAnswerToResult() {
        let answer = rowsContainer.totalRow.getRawValue()
        let answerUnit = rowsContainer.totalRow.getUnit()
        
        rowsContainer.clear()
        selected().setValue(newValue: answer)
        
        let answerAsResultOnly = answerUnit as? ResultOnlyUnit
        selected().setUnit(unit: (answerAsResultOnly != nil) ? answerAsResultOnly?.fallbackUnit() : answerUnit)
         
        refreshRows()
        refreshTotals()
    }
    
    func backspace() {
        if (selected().getValue() == 0) { ViewController.controlDelegate.removeSelected() }
        else { setValueForSelected(value: CalculatorEntryController.removingLastCharacter(current: ViewController.controlDelegate.selected().getRawValue())) }
    }
    
    func clear() {
        mostRecentUnit = nil
        
        rowsContainer.clear()
        rowsContainer.totalRow.setUnit(unit: nil)
        refreshRows()
    }
    
    func clearUnits() {
        mostRecentUnit = nil
        
        rowsContainer.rows.forEach({ $0.0.setUnit(unit: nil, refresh: false) })
        rowsContainer.totalRow.setUnit(unit: nil, refresh: false)
        
        refreshRows()
    }
    
    func removeSelected() {
        rowsContainer.removeCurrent()
        refreshRows()
    }
    
    
    
    func showCurrencyUnitMenu(selected: String?, handler: @escaping (Unit) -> Void) {
        let newController = SearchUnitViewController(selected: selected, onSelect: handler)
        present(newController, animated: true, completion: nil)
    }
    
    func setUnitFor(row: UICalculationRow, newUnit: Unit?) {
        row.setUnit(unit: newUnit)
        mostRecentUnit = newUnit ?? mostRecentUnit
        
        refreshRows()
    }
    
    func canRowHaveUnit(row: UICalculationRow) -> Bool {
        // check if value beforehand is multiply or divide
        if (rowsContainer.totalRow == row) { return true }
        
        let itemIndex = rowsContainer.rows.firstIndex(where: { return $0.0 == row }) ?? 0
        if ((itemIndex - 1) < 0) { return true }
        let operation = rowsContainer.rows[itemIndex - 1].0.getOperation()
        if (operation == .multiply || operation == .divide) { return false }
        
        return true
    }
    
    func unitForRow(row: UICalculationRow) -> Unit? {
        let isTotalRow = (rowsContainer.totalRow == row)
        if (row.getUnit() != nil) { return row.getUnit() }
        
        var foundUnit: Unit? = mostRecentUnit
        var index: Int = 0
        while (foundUnit == nil && index < rowsContainer.rows.count) {
            foundUnit = rowsContainer.rows[index].0.getUnit()
            index += 1
        }
        
        let foundUnitAsResults = foundUnit as? ResultOnlyUnit
        if (!isTotalRow && foundUnitAsResults != nil) {
            foundUnit = foundUnitAsResults?.fallbackUnit()
        }
        
        mostRecentUnit = foundUnit
        return foundUnit
    }
}
