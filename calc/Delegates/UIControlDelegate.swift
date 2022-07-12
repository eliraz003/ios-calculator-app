//
//  UIControlDelegate.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

/**
 A protocol for managing the controls for the calculator such as selecting a row or the backspace operation
 */
protocol UIControlDelegate {
    func selected() -> UICalculationRow
    var totalRow: UICalculationRow { get }
    
    func select(row: UICalculationRow)
    func setOperationForSelected(operation: MathematicalOperation)
    func setValueForSelected(value: String)
    
    func setAnswerToResult()
    func backspace()
    func clear()
    func clearUnits()
    func removeSelected()
    
    func pasteUnit() -> Unit?
    func copyUnit(_ unit: Unit)

    func showCurrencyUnitMenu(selected: String?, handler: @escaping (Unit) -> Void)
    @discardableResult func setUnitFor(row: UICalculationRow, newUnit: Unit?, dontForceRefresh: Bool) -> Bool
    func canRowHaveUnit(row: UICalculationRow) -> Bool
    func unitForRow(row: UICalculationRow) -> Unit?
}

extension UIViewController {
    static var controlDelegate: UIControlDelegate!
}


protocol UIKeypadInteractableDelegate {
    func didInteract(interaction: KeypadInteraction)
}
