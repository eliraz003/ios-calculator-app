//
//  ViewController.swift
//  calc
//
//  Created by Eliraz Atia on 27/03/2022.
//

import UIKit

enum MathematicalOperation: String {
    case plus
    case minus
    case multiply
    case divide
}

class UIDotsIndicator: UIView {
    private var dots: [UIView] = []
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(count: Int) {
        super.init(frame: CGRect.zero)
        
        let size: CGFloat = 8
        let gap: CGFloat = 12
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        var i = 0
        while (i < count) {
            let newView = UIView(frame: CGRect(x: (CGFloat(i)*size)+(CGFloat(i)*gap), y: 0, width: size, height: size))
            addSubview(newView)
//            newView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//            newView.leftAnchor.constraint(equalTo: previous?.rightAnchor ?? leftAnchor, constant: 0).isActive = true
//            newView.widthAnchor.constraint(equalToConstant: 8).isActive = true
//            newView.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            newView.backgroundColor = .white
            newView.layer.cornerRadius = (size / 2)
//            previous = newView
            i += 1
            dots.append(newView)
        }
        
        self.layoutIfNeeded()
        self.widthAnchor.constraint(equalToConstant: dots.last?.frame.maxX ?? 0).isActive = true
        
        setIndex(index: 0)
        //        self.rightAnchor.constraint(equalTo: previous?.rightAnchor ?? self.rightAnchor, constant: 0).isActive = true
    }
    
    func setIndex(index: Int) {
        for dot in dots {
            dot.alpha = 0.3
        }
        
        dots[index].alpha = 1
    }
}

/**
 ViewController is the main view of the app
 */
class ViewController: UIViewController, UITextFieldDelegate, UIControlDelegate, UIInterfaceDelegate, UIKeypadInteractableDelegate {
    private var stepsIndicator: UIDotsIndicator!
    private var keypadBounds: UIView!
    
    private var currentKeypad: Int = 0
    private var mainKeypad: UIkeypadView!
    private var secondaryKeypad: UIkeypadView!
    
    private var rowsContainer: UICalculationRowsController!
    
    private var mostRecentUnit: Unit?
    private var copiedUnit: Unit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.interfaceDelegate = self
        ViewController.controlDelegate = self
    
        rowsContainer = UICalculationRowsController() //(delegate: self)
        rowsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rowsContainer)
        
        stepsIndicator = UIDotsIndicator(count: 2)
        view.addSubview(stepsIndicator)
        
        mainKeypad = UIkeypadView(layout: KeypadLayout.Standard, delegate: self)
        mainKeypad.accessibilityIdentifier = "main_keypad"
        mainKeypad.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainKeypad)
        
        secondaryKeypad = UIkeypadView(layout: KeypadLayout.Special, delegate: self)
        secondaryKeypad.accessibilityIdentifier = "secondary_keypad"
        secondaryKeypad.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondaryKeypad)

        stepsIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        stepsIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.keypadBottomOffset).isActive = true
        
        mainKeypad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainKeypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainKeypad.bottomAnchor.constraint(equalTo: stepsIndicator.topAnchor, constant: -8).isActive = true
        
        secondaryKeypad.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        secondaryKeypad.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        secondaryKeypad.bottomAnchor.constraint(equalTo: stepsIndicator.topAnchor, constant: -8).isActive = true
        secondaryKeypad.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        

        rowsContainer.bottomAnchor.constraint(equalTo: mainKeypad.topAnchor, constant: 0).isActive = true
        rowsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        rowsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        rowsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        
        rowsContainer.bringToLife()
        rowsContainer.addRow()
        
        rowsContainer.totalRow.accessibilityIdentifier = "total_row"
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPanKeypad(gesture:)))
        mainKeypad.isUserInteractionEnabled = true
        mainKeypad.addGestureRecognizer(panGesture)
        let secondaryPanGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPanKeypad(gesture:)))
        secondaryKeypad.isUserInteractionEnabled = true
        secondaryKeypad.addGestureRecognizer(secondaryPanGesture)
        
        ColorController.appendToList(key: ColorController.MainBackground, item: view)
        ViewController.interfaceDelegate.setTheme(theme:
            ViewController.interfaceDelegate.getTheme()
        )
    }
    
    //* ALLOW USER TO SWIPE BETWEEN MAIN AND SECONDARY KEYPAD *//
    
    private func getOffsetOfKeypadUsingIndex(_ current: Int, target: Int) -> CGFloat {
        let w = UIScreen.main.bounds.width
        let offset = CGFloat(target - current)
        return w * offset
    }
    
    @objc func userDidPanKeypad(gesture: UIPanGestureRecognizer) {
        var transform = gesture.translation(in: view).x
        if (currentKeypad == 0) { transform = min(0, transform) }
        else if (currentKeypad == 1) { transform = max(0, transform) }
        
        if (gesture.state == .changed) {
            self.mainKeypad.transform = CGAffineTransform(translationX:  getOffsetOfKeypadUsingIndex(currentKeypad, target: 0) + transform, y: 0)
            self.secondaryKeypad.transform = CGAffineTransform(translationX: getOffsetOfKeypadUsingIndex(currentKeypad, target: 1) + transform, y: 0)
        } else if (gesture.state == .ended) {
            if (currentKeypad == 0 && transform < -100) { currentKeypad = 1 }
            else if (currentKeypad == 1 && transform > 100) { currentKeypad = 0 }
            
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.mainKeypad.transform = CGAffineTransform(translationX: self.getOffsetOfKeypadUsingIndex(self.currentKeypad, target: 0), y: 0)
                self.secondaryKeypad.transform = CGAffineTransform(translationX: self.getOffsetOfKeypadUsingIndex(self.currentKeypad, target: 1), y: 0)
            }, completion: { _ in
                self.stepsIndicator.setIndex(index: self.currentKeypad)
            })
        }
    }
    
    
    
    //* KEYPAD CONTROL DELEGATE *//
    
    func didInteract(interaction: KeypadInteraction) {
        switch(interaction) {
        case .number(let number):
            setValueForSelected(value:
                CalculatorEntryController.appendCharacter(character: number, to: selected().getRawValue()))
            break
            
        case .special(let special):
            setValueForSelected(value:
                CalculatorEntryController.appendCharacter(character: special, to: selected().getRawValue()))
            break
            
        case .operation(let operation):
            setOperationForSelected(operation: MathematicalOperation(rawValue: operation.rawValue) ?? .plus)
            break
            
        case .action(let action):
            switch(action) {
            case .backspace:
                return backspace()
            case .clear:
                return clear()
            case .openMenu:
                return openViewModally(MenuViewController())
            case .answer:
                return setAnswerToResult()
            }
        default:
            break
        }
    }
    
    
    //* INTERFACE DELEGATE *//
    
    /**
     Get the Theme object that is saved in local storage
     */
    func getTheme() -> Theme {
        let themeName = UserDefaults.standard.string(forKey: "@theme") ?? defaultTheme
        return themes[themeName]!
    }
    
    /**
     Set the theme by calling the ColorController and saving the new themes name to the UserDefaults
     */
    func setTheme(theme: Theme) {
        UserDefaults.standard.set(theme.name, forKey: "@theme")
        ColorController.dispatchChange(colours: theme.colors)
    }
    
    /**
     Open a view modally (call when presenting the menu or the currency selector)
     */
    func openViewModally(_ view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
    
    /**
     Dismiss the presented view controller
     (Shorter than fetching the root UIViewController each time view should be dismissed)
     */
    func forceDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Checks if the row passed is the last row (most recently created) in the row controller
     */
    func isRowLast(row: UICalculationRow) -> Bool {
        return (rowsContainer.rows.last?.0 == row)
    }
    
    /**
     Checks if the row passed is the first row (first one still existing) in the row controller
     */
    func isRowFirst(row: UICalculationRow) -> Bool {
        return (rowsContainer.rows.first?.0 == row)
    }
    
    
    //* UTILITY FUNCTIONS *//
    
    /**
     Call when a rows value or operation has been changed
     Refreshes every row including the total row and calls for the calculation result to be recalculated
     */
    private func refreshRows() {
        rowsContainer.rows.forEach({ $0.0.refresh() })
        rowsContainer.totalRow.refresh()
        
        refreshTotals()
    }
    
    /**
     Loop thorugh each row and calculate the total result
     */
    @discardableResult private func refreshTotals() -> CGFloat {
        var total: CGFloat = 0.0
        
        var appliedUnit = false
        var index = 0
        while (index < rowsContainer.rows.count) {
            let current: UICalculationRow = rowsContainer.rows[index].0
            let previous: UICalculationRow? = (index == 0) ? nil : rowsContainer.rows[index - 1].0
            
            /**
             Gets the correct value (converting to the base unit if a unit is selected for this calculation)
             */
            func getValue() -> Double {
                let value = current.getValue()
                let unit = current.getUnit()
                if (unit != nil) {
                    appliedUnit = true
                    return unit!.convertToBase(value: value)
                } else { return value }
            }
            
            /**
             Check the operation of the previous row (if previous operation had an addition operation then that means that this value should be added to the previous value)
             */
            switch(previous?.getOperation() ?? MathematicalOperation.plus) {
            case .plus:
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
        
        /**
         If a unit is selected for the current calculation then convert the final value to the unit shown in the totals row
         */
        var finalValue = total
        if (rowsContainer.totalRow.getUnit() != nil && appliedUnit) { finalValue = rowsContainer.totalRow.getUnit()?.convertFromBase(value: finalValue) ?? total }
    
        /**
         If the totals row has a special unit render (using ResultOnlyUnit) then call the renderResult unit,
         if not assign the total row value to the number found from the numberFormatter
         */
        if let resultAsResultOnlyUnit = rowsContainer.totalRow.getUnit() as? ResultOnlyUnit {
            rowsContainer.totalRow.setValue(newValue: resultAsResultOnlyUnit.renderResult(value: total))
        } else {
            let isCurrency = (rowsContainer.totalRow.getUnit()?.type == .currency)
            let min = 2
            let max = (isCurrency) ? 2 : 6
            
            /**
             Render the total result in the most appropiate way
             (Uses NumberFormatter as CGFloat.description can return scientific numbers)
             */
            let absoluteFinalValue = NumberFormatter.usingOverallCharacterCount(value: finalValue, min: min, max: max)
            rowsContainer.totalRow.setValue(newValue: absoluteFinalValue)
        }
        
        return total
    }
        
        
    
    //* CONTROL DELEGATE *//
    
    /**
     Get the current row selected by the user
     */
    func selected() -> UICalculationRow {
        return rowsContainer.getCurrent()
    }
    
    /**
     Select a given UICalculationRow
     */
    func select(row: UICalculationRow) {
        rowsContainer.setSelectedIndex(at: row)
    }
    
    /**
     Set the operation for the current row and navigate to the row below
     (addition, division, multiplication, subtraction...)
     */
    func setOperationForSelected(operation: MathematicalOperation) {
        if (selected().getValue() == 0) { return }
        
        selected().setOperation(newOperation: operation)
        rowsContainer.nextRow()
        
        refreshRows()
    }
    
    /**
     Set the value for the selected row
     */
    func setValueForSelected(value: String) {
        selected().setValue(newValue: value)
        refreshRows()
    }
    
    
    /**
     Clear the calculation and add a row with the current answer (compress calculation into one row)
     */
    func setAnswerToResult() {
        mostRecentUnit = nil
        
        let answer = refreshTotals()
        var answerUnit = rowsContainer.totalRow.getUnit()
        if let unitAsResultOnly = answerUnit as? ResultOnlyUnit { answerUnit = unitAsResultOnly.fallbackUnit() }
        
        rowsContainer.clear()
        selected().setValue(newValue: answerUnit?.convertFromBase(value: answer) ?? answer)
        selected().setUnit(unit: answerUnit)
         
        refreshRows()
        refreshTotals()
    }
    
    /**
     Performs a backspace operation by removing the last character from the current row
     */
    func backspace() {
        let newValueRemoved = CalculatorEntryController.removingLastCharacter(current: ViewController.controlDelegate.selected().getRawValue())
        
        if (newValueRemoved != nil) { setValueForSelected(value: newValueRemoved!) }
        else { ViewController.controlDelegate.removeSelected() }
    }
    
    /**
     Clears the entire calculation
     */
    func clear() {
        mostRecentUnit = nil
        copiedUnit = nil
        
        rowsContainer.clear()
        rowsContainer.totalRow.setUnit(unit: nil)
        refreshRows()
    }
    
    /**
     Clear all the units selected in the calculation
     */
    func clearUnits() {
        mostRecentUnit = nil
        copiedUnit = nil
        
        rowsContainer.rows.forEach({ $0.0.setUnit(unit: nil, refresh: false) })
        rowsContainer.totalRow.setUnit(unit: nil, refresh: false)
        
        refreshRows()
    }
    
    /**
     Remove the current selected row
     */
    func removeSelected() {
        rowsContainer.removeCurrent()
        refreshRows()
    }
    
    /**
     Set the copiedUnit to the passed unit and refresh the rows to reset the rows menus
     */
    func copyUnit(_ unit: Unit) {
        copiedUnit = unit
        refreshRows()
    }
    
    /**
     Returns the unit that was most recently copied
     */
    func pasteUnit() -> Unit? {
        return copiedUnit
    }
    
    /**
     Create and present the SearchUnitViewController used to select a currency
     */
    func showCurrencyUnitMenu(selected: String?, handler: @escaping (Unit) -> Void) {
        let newController = SearchUnitViewController(selected: selected, onSelect: handler)
        present(newController, animated: true, completion: nil)
    }

    /**
     Set a unit for a given row
     */
    func setUnitFor(row: UICalculationRow, newUnit: Unit?) {
        row.setUnit(unit: newUnit)
        mostRecentUnit = newUnit ?? mostRecentUnit
        
        refreshRows()
    }
    
    /**
     Check if the row can have a unit
     (Rows that are below multiply or divide operations cannot have units)
     */
    func canRowHaveUnit(row: UICalculationRow) -> Bool {
        // check if value beforehand is multiply or divide
        if (rowsContainer.totalRow == row) { return true }
        
        let itemIndex = rowsContainer.rows.firstIndex(where: { return $0.0 == row }) ?? 0
        if ((itemIndex - 1) < 0) { return true }
        let operation = rowsContainer.rows[itemIndex - 1].0.getOperation()
        if (operation == .multiply || operation == .divide) { return false }
        
        return true
    }
    
    /**
     Get the unit for the row
     Check the applied unit by calling row.getUnit() and validate that it can be set
     If the value above it has a multiply or divide operation than return a nil unit
     */
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
