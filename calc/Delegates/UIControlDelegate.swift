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
    
    func select(row: UICalculationRow)
    func setOperationForSelected(operation: MathematicalOperation)
    func setValueForSelected(value: String)
    
    func setAnswerToResult()
    func backspace()
    func clear()
    func clearUnits()
    func removeSelected()

    func showCurrencyUnitMenu(selected: String?, handler: @escaping (Unit) -> Void)
    func setUnitFor(row: UICalculationRow, newUnit: Unit?)
    func canRowHaveUnit(row: UICalculationRow) -> Bool
    func unitForRow(row: UICalculationRow) -> Unit?
}

extension UIViewController {
    static var controlDelegate: UIControlDelegate!
}


protocol UIKeypadInteractableDelegate {
    func didInteract(interaction: KeypadInteraction)
}
