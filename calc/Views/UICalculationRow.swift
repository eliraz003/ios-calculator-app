//
//  UICalculationRow.swift
//  calc
//
//  Created by Eliraz Atia on 06/05/2022.
//

import Foundation
import UIKit

class UIClickableImageView: UIImageView {
    var action: () -> Void
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: CGRect.zero)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped() {
        action()
    }
}

class UICalculationRow: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var displayArrowTop: UIView = UIView()
    private var displayArrowBottom: UIView = UIView()
    
    private var value: String = "0"
    private var operation: MathematicalOperation?
    private var unit: Unit?
    
    private var error: Error?
    
    private var allowUserUnitChanging: Bool = true
    
    private let unitLabel: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("#", for: .normal)
        view.titleLabel?.font = Dimensions.unitFont
        
        view.showsMenuAsPrimaryAction = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let valueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "0"
        return  view
    }()

    private var operationIconBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.widthAnchor.constraint(equalToConstant: 22).isActive = true
        view.heightAnchor.constraint(equalToConstant: 22).isActive = true
        view.layer.cornerRadius = (22 / 2)
        
        return view
    }()
    
    private let operationIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(allowUserUnitChanging: Bool) {
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.allowUserUnitChanging = allowUserUnitChanging
        
        addSubview(unitLabel)
        ColorController.appendToList(key: ColorController.RowLabel, item: unitLabel)
        unitLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        unitLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        
        addSubview(operationIconBackground)
        operationIconBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        
        operationIconBackground.addSubview(operationIcon)
        operationIcon.centerXAnchor.constraint(equalTo: operationIconBackground.centerXAnchor).isActive = true
        operationIcon.centerYAnchor.constraint(equalTo: operationIconBackground.centerYAnchor).isActive = true
        
        addSubview(valueLabel)
        valueLabel.rightAnchor.constraint(equalTo: (allowUserUnitChanging) ? operationIconBackground.leftAnchor : self.rightAnchor, constant: (allowUserUnitChanging) ? -6 : -32).isActive = true
        operationIconBackground.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor, constant: 0).isActive = true
        
        displayArrowTop.translatesAutoresizingMaskIntoConstraints = false
        addSubview(displayArrowTop)
        displayArrowTop.centerXAnchor.constraint(equalTo: operationIconBackground.centerXAnchor, constant: 0).isActive = true
        displayArrowTop.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        displayArrowTop.bottomAnchor.constraint(equalTo: operationIconBackground.topAnchor, constant: 0).isActive = true
        displayArrowTop.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        displayArrowBottom.translatesAutoresizingMaskIntoConstraints = false
        addSubview(displayArrowBottom)
        displayArrowBottom.centerXAnchor.constraint(equalTo: operationIconBackground.centerXAnchor, constant: 0).isActive = true
        displayArrowBottom.topAnchor.constraint(equalTo: operationIconBackground.bottomAnchor, constant: 0).isActive = true
        displayArrowBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        displayArrowBottom.widthAnchor.constraint(equalToConstant: 1).isActive = true
                
        ColorController.appendToList(key: ColorController.RowLabel, item: valueLabel)
        ColorController.appendToList(key: ColorController.RowLabel, item: operationIconBackground, handler: { return $0.withAlphaComponent(0.3) })
        ColorController.appendToList(key: ColorController.RowLabel, item: operationIcon)

        ColorController.appendToList(key: ColorController.RowLabel, item: displayArrowTop, handler: { return $0.withAlphaComponent(0.1) })
        ColorController.appendToList(key: ColorController.RowLabel, item: displayArrowBottom, handler: { return $0.withAlphaComponent(0.1) })
        
        if (!allowUserUnitChanging) {
            valueLabel.accessibilityIdentifier = "total_label"
            operationIconBackground.removeFromSuperview()
            operationIcon.removeFromSuperview()
            displayArrowTop.removeFromSuperview()
            displayArrowBottom.removeFromSuperview()
        } else {
            displayArrowTop.alpha = 0
            displayArrowBottom.alpha = 0
        }
        
        self.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -6).isActive = true
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSelf)))
        
        blur()
        setOperationIcon(to: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10), execute: { self.refresh() })
    }
    
    func setOperationIcon(to: UIImage?) {
        operationIcon.image = to
        if (to == nil) {
            operationIconBackground.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        } else {
            operationIconBackground.transform = CGAffineTransform.identity
        }
    }
    
    func refresh() {
        valueLabel.text = String(value)
                
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        if (error != nil) {
            // If error then set label as red and add a warning icon
            ColorController.appendToList(key: ColorController.RowLabelError, item: valueLabel)
            setOperationIcon(to: UIImage(systemName: "exclamationmark.triangle.fill", withConfiguration: configuration))
        } else {
            ColorController.appendToList(key: ColorController.RowLabel, item: valueLabel)
            
            switch(operation) {
            case .plus:
                setOperationIcon(to: UIImage(systemName: "plus", withConfiguration: configuration)); break
            case .minus:
                setOperationIcon(to: UIImage(systemName: "minus", withConfiguration: configuration)); break
            case .divide:
                setOperationIcon(to: UIImage(systemName: "divide", withConfiguration: configuration)); break
            case .multiply:
                setOperationIcon(to: UIImage(systemName: "multiply", withConfiguration: configuration)); break
            default:
                setOperationIcon(to: nil); break
            }
        }
        
        let isFirst = ViewController.interfaceDelegate.isRowFirst(row: self)
        let isLast = ViewController.interfaceDelegate.isRowLast(row: self)
        
        if (isFirst && !isLast) {
            displayArrowTop.alpha = 0
            displayArrowBottom.alpha = 1
        } else if (isLast && !isFirst) {
            displayArrowTop.alpha = 1
            displayArrowBottom.alpha = 0
        } else if (!isLast && !isFirst) {
            displayArrowTop.alpha = 1
            displayArrowBottom.alpha = 1
        } else if (isLast && isFirst) {
            displayArrowTop.alpha = 0
            displayArrowBottom.alpha = 0
        }
        
        if (ViewController.controlDelegate.canRowHaveUnit(row: self)) {
            let assignUnit: (Unit?) -> Void = { newUnit in
                ViewController.controlDelegate.setUnitFor(row: self, newUnit: newUnit)
            }
            
            unit = ViewController.controlDelegate.unitForRow(row: self)
            unitLabel.setTitle(unit?.getSymbol() ?? "#", for: .normal)
            unitLabel.alpha = 1
            
            unitLabel.menu = buildMenu(setUnitCallback: assignUnit)
        } else {
            unit = nil
            
            unitLabel.setTitle("#", for: .normal)
            unitLabel.alpha = 0.35
            unitLabel.menu = nil
        }
    }
    
    private func buildMenu(setUnitCallback: @escaping (Unit?) -> Void) -> UIMenu {
        let options: UIMenu.Options = (unit != nil) ? [.displayInline] : []
         
        let timeMenu = UIMenu.init(title: "Time", image: UIImage(systemName: "clock.fill"), identifier: nil, options: options, children: timeUnits.availiableUnits(forStandardRow: allowUserUnitChanging).map{ arr in
            return UIMenu.init(title: "", image: nil, identifier: nil, options: .displayInline, children: arr.map({ sortedUnit in
                UIAction.init(title: sortedUnit.name, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: (unit == sortedUnit) ? .on : .off, handler: { action in setUnitCallback(sortedUnit) })
            }))
        })
        
        let lengthMenu = UIMenu.init(title: "Lengths", image: UIImage(systemName: "ruler.fill"), identifier: nil, options: options, children: lengthUnits.availiableUnits(forStandardRow: allowUserUnitChanging).map{ arr in
            return UIMenu.init(title: "", image: nil, identifier: nil, options: .displayInline, children: arr.map({ sortedUnit in
                UIAction.init(title: sortedUnit.name, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: (unit == sortedUnit) ? .on : .off, handler: { action in setUnitCallback(sortedUnit) })
            }))
        })
        
        let massMenu = UIMenu.init(title: "Mass / Weights", image: UIImage(systemName: "scalemass.fill"), identifier: nil, options: options, children: massUnits.availiableUnits(forStandardRow: allowUserUnitChanging).map{ arr in
            return UIMenu.init(title: "", image: nil, identifier: nil, options: .displayInline, children: arr.map({ sortedUnit in
                UIAction.init(title: sortedUnit.name, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: (unit == sortedUnit) ? .on : .off, handler: { action in setUnitCallback(sortedUnit) })
            }))
        })
        
        let currencyMenu = UIAction(title: (unit == nil) ? "Set Currency" : "Change Currency", image: UIImage(systemName: "dollarsign.circle.fill"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { action in
            ViewController.controlDelegate.showCurrencyUnitMenu(selected: (self.unit as? Currency)?.isoCode, handler: { action in
                print("Is calling callback")
                setUnitCallback(action)
            })
        })
        
        let clearUnitsButton = UIAction(title: "Clear All Units", image: UIImage(systemName: "xmark"), identifier: nil, discoverabilityTitle: nil, attributes: [.destructive], state: .off, handler: { action in
            ViewController.controlDelegate.clearUnits()
        })
        
        let pastableUnit = ViewController.controlDelegate.pasteUnit()
        let copyPasteMenu = UIMenu.init(title: "Copy", image: nil, identifier: nil, options: .displayInline, children: [
            (unit as? ResultOnlyUnit == nil)
                ? UIAction(title: "Copy", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { _ in
                    ViewController.controlDelegate.copyUnit(self.unit!)
                })
            
                : UIAction(title: "Copy", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, attributes: .disabled, state: .off, handler: { _ in }),
            
            ((pastableUnit) != nil)
                ? UIAction(title: "Paste", image: UIImage(systemName: "pencil.and.outline"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { _ in
                    setUnitCallback(ViewController.controlDelegate.pasteUnit())
                })
            
                : UIAction(title: "Paste", image: UIImage(systemName: "pencil.and.outline"), identifier: nil, discoverabilityTitle: nil, attributes: .disabled, state: .off, handler: { _ in }),
            
            (unit as? ResultOnlyUnit == nil && (pastableUnit) != nil)
                ? UIAction(title: "Paste & Copy", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { _ in
                    let toPaste = ViewController.controlDelegate.pasteUnit()
                    ViewController.controlDelegate.copyUnit(self.unit!)
                    setUnitCallback(toPaste)
                })
            
                : UIAction(title: "Paste & Copy", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, attributes: .disabled, state: .off, handler: { _ in }),
        ])
        
        var menuChildren: [UIMenuElement] = []
        if (unit?.type == .currency) {
            menuChildren = [currencyMenu, clearUnitsButton]
        } else if (unit?.type == .time) {
            menuChildren = [timeMenu, clearUnitsButton]
        } else if (unit?.type == .length) {
            menuChildren = [lengthMenu, clearUnitsButton]
        } else if (unit?.type == .mass) {
            menuChildren = [massMenu, clearUnitsButton]
        } else {
            menuChildren = [
                currencyMenu,
                timeMenu,
                lengthMenu,
                massMenu
            ]
        }
        
        if (unit != nil && unit?.type != .generic) {
            menuChildren.append(copyPasteMenu)
        }

        let menu = UIMenu(title: "Select Unit...", image: nil, identifier: nil, options: [], children: menuChildren)
        return menu
    }
    
    func focus() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.valueLabel.font = Dimensions.focusedCalculationFont
        }, completion: nil)
    }
    
    func blur() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.valueLabel.font = Dimensions.blurredCalculationFont
        }, completion: nil)
    }
    
    func setValue(newValue: CGFloat) {
        value = NumberFormatter.usingOverallCharacterCount(value: newValue, min: 0, max: 6, dontUseSeperators: allowUserUnitChanging)
        refresh()
    }
    
    func setValue(newValue: String) {
        value = newValue
        refresh()
    }
    
    func getRawValue() -> String {return value}
    func getValue() -> Double {
        let result = CalculatorEntryController.renderedValue(entry: value)
        error = result.1
        
        refresh()
        
        return result.0 ?? 0
    }
    
    func getOperation() -> MathematicalOperation? { return operation }
    func setOperation(newOperation: MathematicalOperation) {
        operation = newOperation
        refresh()
    }
    
    @objc func clickSelf() { ViewController.controlDelegate.select(row: self) }
    
    func getUnit() -> Unit? {return unit}
    func setUnit(unit: Unit?, refresh shouldRefresh: Bool = true) {
        self.unit = unit
        if (shouldRefresh) { refresh() }
    }
}
