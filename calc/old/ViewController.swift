////
////  ViewController.swift
////  calc
////
////  Created by Eliraz Atia on 27/03/2022.
////
//
//import UIKit
//
//enum MathematicalOperation {
//    case add
//    case minus
//    case multiply
//    case divide
//}
//
//protocol UIMainDelegate {
//    func setSelected(to: UICalculationRow)
//
//    func setOperation(to: MathematicalOperation)
//    func setValue(to: String)
//
//    func clear()
//    func remove()
//    func setUnit(to: Unit?, row: UICalculationRow)
//    func setTotalsUnit(to: Unit?)
//
//    func getCurrentValue() -> Double
//    func getCurrentRawValue() -> String
//    func setAnswerAsResult()
//
//    func openThemeSelector()
//    func dismissThemeSelector()
//    func setTheme(to: Theme)
//
//    func validateAssignedUnit(unit: Unit?, forRow row: UICalculationRow) -> Bool
//
//    func presentUnit(selected: String?, handler: @escaping (Unit) -> Void)
//
//    func allowedMenu(_ row: UICalculationRow) -> Bool
//    func getAutomaticUnit() -> Unit?
//}
//
//
//
///**
// CONTINUE WORKING BY MINIFIING THE UICONTROLDELEGATE
// */
//protocol UIInterfaceDelegate {
//    func openThemeSelector()
//    func dismissThemeSelector()
//
//    func getTheme() -> Theme
//    func setTheme(theme: Theme)
//}
//
//protocol UIControlDelegate {
//    func selected() -> UICalculationRow
//
//    func select(row: UICalculationRow)
//    func setOperationForSelected(operation: MathematicalOperation)
//    func setValueForSelected(value: String)
//
//    func setAnswerToResult()
//    func clear()
//    func removeSelected()
//
//    func canRowHaveUnit(row: UICalculationRow) -> Bool
//    func unitForRow() -> Unit?
//}
//
///**
// function refreshRows()
//    loops through every row and calls .refresh
//
// row.refresh()
//    // set value label to correct value saved
//    // set operation label to correct operation
//    // call canRowHaveUnit(self)
//        // if yes
//            // call unitForRow and set the unit label to the recieved unit
//        // if no
//            // remove unit and refresh unit label
//            // remove menu
// */
//
//
//
//var defaultTheme: String = "Green"
//var themes: [String:Theme] = [
//    "White":.init(name: "White", color: UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.85, alpha: 1)),
//    "Green":.init(name: "Green", color: UIColor.fromHex(hex: "85F9BD")),
//    "Blue":.init(name: "Blue", color: UIColor.fromHex(hex: "1281E3")),
//    "Yellow":.init(name: "Yellow", color: UIColor.fromHex(hex: "F4D801")),
//    "Red":.init(name: "Red", color: UIColor.fromHex(hex: "E2655D")),
//    "Purple":.init(name: "Purple", color: UIColor.fromHex(hex: "AB94FF")),
//    "Cyan":.init(name: "Cyan", color: UIColor.fromHex(hex: "9ED9E7")),
//]
//
//class ViewController: UIViewController, UITextFieldDelegate, UIMainDelegate {
//    var keypad: UIkeypadView!
//    var rowsContainer: UICalculationRowsController!
//
//    var mostRecentUnit: Unit?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let theme = ViewController.getTheme()
//        view.backgroundColor = theme.color
//
//        keypad = UIkeypadView()
//        keypad.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(keypad)
//        keypad.delegate = self
//
//        rowsContainer = UICalculationRowsController(delegate: self)
//        rowsContainer.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(rowsContainer)
//
//        let device = UIScreen.main.traitCollection.userInterfaceIdiom
//        if (device == .phone) {
//            keypad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//            keypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//            keypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
//            keypad.extendedViewBottomAnchor = view.bottomAnchor
//
//            rowsContainer.bottomAnchor.constraint(equalTo: keypad.topAnchor, constant: 0).isActive = true
//            rowsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//            rowsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//            rowsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
//
//        } else if (device == .pad) {
//            keypad.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//            keypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
//            keypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
//            keypad.extendedViewBottomAnchor = view.bottomAnchor
//            keypad.extendedViewTopAnchor = view.topAnchor
//
//            rowsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
//            rowsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//            rowsContainer.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//            rowsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
//        }
//
//        rowsContainer.addRow()
//    }
//
//    static func getTheme() -> Theme {
//        let themeName = UserDefaults.standard.string(forKey: "@theme") ?? defaultTheme
//        return themes[themeName]!
//    }
//
//    func setTheme(to: Theme) {
//        UserDefaults.standard.set(to.name, forKey: "@theme")
//        view.backgroundColor = to.color
//    }
//
//    func refreshTotals() {
//        var total: CGFloat = 0
//
//        var appliedUnit = false
//        var isTime = false
//        var index = 0
//        while (index < rowsContainer.rows.count) {
//            let current: UICalculationRow = rowsContainer.rows[index].0
//            let previous: UICalculationRow? = (index == 0) ? nil : rowsContainer.rows[index - 1].0
//
//            func getValue() -> Double {
//                let value = current.getValue()
//                let unit = current.getUnit()
//                if (unit != nil) {
//                    appliedUnit = true
//                    if (unit?.type == .time) { isTime = true }
//                    return unit!.convertToBase(value: value)
//                } else { return value }
//            }
//
//            switch(previous?.operation ?? MathematicalOperation.add) {
//            case .add:
//                total += getValue()
//                break
//            case .divide:
//                let secondaryTotal = getValue()
//                if (secondaryTotal != 0) { total = (total / getValue()) }
//                break
//            case .minus:
//                total -= getValue()
//                break
//            case .multiply:
//                total = (total * getValue())
//                break
//            }
//
//            index += 1
//        }
//
//        var finalValue = total
//        if (rowsContainer.totalRow.unit != nil && appliedUnit) { finalValue = rowsContainer.totalRow.unit?.convertFromBase(value: finalValue) ?? total }
//        let stringValue = finalValue.description
//
//        let stringValueSplit = stringValue.split(separator: ".").map({ i in return String(i) })
//        let mainValue = stringValueSplit[0]
//        var decimalValue = stringValueSplit[1]
//        var finalResultValue = mainValue
//
//        var numberOfDecimalsAllowed = (8 - mainValue.count)
//        if (numberOfDecimalsAllowed <= 2) { numberOfDecimalsAllowed = 2 }
//
//        if let formatter = NumberFormatter().number(from: decimalValue) {
//            if (Int(truncating: formatter) > 0) {
//                while (decimalValue.count > numberOfDecimalsAllowed) { decimalValue = String(decimalValue.dropLast()) }
//                finalResultValue += "." + decimalValue
//            }
//        }
//
//        if (isTime) {
////            let timeInMilliseconds = total
//            if let asDisplayTimeUnit = rowsContainer.totalRow.unit as? Time.DisplayTimeUnit {
//                rowsContainer.totalRow.setValue(newValue: asDisplayTimeUnit.renderTimeDisplay(valueInMS: total))//total.description + ":00")
//            } else {
//                rowsContainer.totalRow.setValue(newValue: "NaN")
//            }
//        } else {
//            rowsContainer.totalRow.setValue(newValue: finalResultValue)
//        }
//
//        refreshMenus()
//    }
//
//    func allowedMenu(_ row: UICalculationRow) -> Bool {
//        let itemIndex = rowsContainer.rows.firstIndex(where: { return $0.0 == row }) ?? 0
//        if ((itemIndex - 1) <= 0) { return true }
//        let operation = rowsContainer.rows[itemIndex - 1].0.operation
//        if (operation == .multiply || operation == .divide) { return false }
//
//        return true
//    }
//
//    func refreshMenus() {
//        rowsContainer.rows.forEach({ row in row.0.updateMenu() })
//        rowsContainer.totalRow.updateMenu()
//    }
//
//    func setSelected(to: UICalculationRow) {
//        rowsContainer.setSelectedIndex(at: to)
//    }
//
//    func setOperation(to: MathematicalOperation) {
//        refreshUnitsForAllRows(to: nil, row: rowsContainer.totalRow)
//
//        if (rowsContainer.getCurrent().getValue() == 0) { return }
//
//        rowsContainer.getCurrent().setOperation(newOperation: to)
//        rowsContainer.nextRow()
//
////        if (to == .divide || to == .multiply) { rowsContainer.getCurrent().setUnit(unit: nil) }
//
//        refreshTotals()
//    }
//
//    func setValue(to: String) {
//        rowsContainer.getCurrent().setValue(newValue: to)
//        refreshTotals()
//    }
//
//    func clear() {
//        mostRecentUnit = nil
//        rowsContainer.clear()
//        rowsContainer.totalRow.setUnit(unit: nil)
//
//        refreshTotals()
//    }
//
//    func setAnswerAsResult() {
//        let answer = rowsContainer.totalRow.getRawValue()
//        let answerUnit = rowsContainer.totalRow.getUnit()
//        rowsContainer.clear()
//
//        rowsContainer.getCurrent().setValue(newValue: answer)
//        rowsContainer.getCurrent().setUnit(unit: answerUnit)
//
//        refreshTotals()
//    }
//
//    func remove() {
//        rowsContainer.removeCurrent()
//        refreshTotals()
//    }
//
//    func validateAssignedUnit(unit: Unit?, forRow row: UICalculationRow) -> Bool {
//        let itemIndex = rowsContainer.rows.firstIndex(where: { return $0.0 == row }) ?? 0
//        if ((itemIndex - 1) <= 0) { return true }
//        let operation = rowsContainer.rows[itemIndex - 1].0.operation
//        if (operation == .multiply || operation == .divide) { return false }
//
//        var allowed = true
//        if (unit == nil) {
//            rowsContainer.rows.forEach({ containedRow in
//                if (row != containedRow.0 && containedRow.0.unit != nil) { allowed = false }
//            })
//        } else {
//            rowsContainer.rows.forEach({ row in
//                if (row.0.unit == nil) { return }
//                allowed = (row.0.unit?.type == unit?.type)
//            })
//        }
//
//        return allowed
//    }
//
//    func getAutomaticUnit() -> Unit? {
//        var firstFound: Unit?
//        rowsContainer.rows.forEach({ row in
//            if (firstFound == nil) { firstFound = row.0.unit }
//        })
//
//        return mostRecentUnit ?? firstFound
//    }
//
//    func refreshUnitsForAllRows(to: Unit?, row: UICalculationRow) {
//        var previousOperation: MathematicalOperation?
//        var closestUnit: Unit?
//        rowsContainer.rows.forEach({ rowContainer in
//            let row = rowContainer.0
//            if (row.unit == nil && !row.hasForcefullyRemovedUnit && !(previousOperation == .multiply || previousOperation == .divide)) {
//                var unitToSet = closestUnit ?? to
//                if ((unitToSet as? Time.DisplayTimeUnit) != nil) { unitToSet = timeUnits[Time.Millisecond] }
//
//                row.setUnit(unit: unitToSet)
//            } else {
//                if (row.unit != nil) { closestUnit = row.unit }
//            }
//
//            previousOperation = row.operation
//        })
//
//        if (rowsContainer.totalRow.unit == nil) {
//            if ((to ?? closestUnit) as? Time != nil) {
//                rowsContainer.totalRow.setUnit(unit: displayTimeUnits[0])
//            }
//        }
//    }
//
//    func setUnit(to: Unit?, row: UICalculationRow) {
////        var itemIndex = rowsContainer.rows.firstIndex(where: { return $0.0 == row })
////        if ((itemIndex - 1) > 0) { return }
//
//        row.setUnit(unit: to)
//        if (to == nil) { row.hasForcefullyRemovedUnit = true }
//
//        refreshUnitsForAllRows(to: to, row: row)
//
//        refreshTotals()
//        refreshMenus()
//        mostRecentUnit = to ?? mostRecentUnit
//    }
//
//    func setTotalsUnit(to: Unit?) {
//        rowsContainer.totalRow.setUnit(unit: to ?? rowsContainer.rows.last?.0.unit)
//
//        refreshUnitsForAllRows(to: to, row: rowsContainer.totalRow)
//        refreshTotals()
//        refreshMenus()
//    }
//
//    func getCurrentValue() -> Double {return rowsContainer.getCurrent().getValue()}
//
//    func getCurrentRawValue() -> String {return rowsContainer.getCurrent().getRawValue()}
//
//    func presentUnit(selected: String?, handler: @escaping (Unit) -> Void) {
//        let newController = SearchUnitViewController(selected: selected, onSelect: handler)
//        present(newController, animated: true, completion: nil)
//    }
//
//    func openThemeSelector() {
//        let newController = ThemeViewController()
//        newController.delegate = self
//        present(newController, animated: true, completion: nil)
//    }
//
//    func dismissThemeSelector() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//enum CurrencyError: Error {
//    case CannotFetch
//}
//
