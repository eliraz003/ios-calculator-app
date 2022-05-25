//
//  UIInterfaceDelegate.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

/**
 A protocol for managing main interface interactions with the root view controller
 */
protocol UIInterfaceDelegate {
    func forceDismiss()
    func openViewModally(_ view: UIViewController)
    
    func getTheme() -> Theme
    func setTheme(theme: Theme)
    
    func isRowLast(row: UICalculationRow) -> Bool
    func isRowFirst(row: UICalculationRow) -> Bool
}

extension UIViewController {
    static var interfaceDelegate: UIInterfaceDelegate!
}
