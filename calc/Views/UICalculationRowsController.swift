//
//  UICalculationRowsController.swift
//  calc
//
//  Created by Eliraz Atia on 06/05/2022.
//

import Foundation
import UIKit

class UICalculationRowsController: UIView {
    private var border: UIView = UIView()
    
    private var contentViewHeightAxis: NSLayoutConstraint!
    private let contentScrollView: UIView = UIView()
    private let contentView: UIView = UIView()
    
    private var selectedIndex: Int!
    var rows: [(UICalculationRow, NSLayoutConstraint)] = []
    var totalRow: UICalculationRow!
    
    private var contentHeight: CGFloat = 0
    private var currentOffset: CGFloat = 0
    private var scrollViewHeight: CGFloat = 0
    
    private var rowSpacing = 6.0
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: CGRect.zero)
    }
    
    func bringToLife() {
        totalRow = UICalculationRow(allowUserUnitChanging: false)
        addSubview(totalRow)
        totalRow.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        totalRow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        totalRow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentScrollView)
        contentScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: totalRow.topAnchor, constant: -8).isActive = true
        contentScrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: 0).isActive = true
        contentViewHeightAxis = contentView.heightAnchor.constraint(equalToConstant: 100)
        contentViewHeightAxis.isActive = true
    
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        border.bottomAnchor.constraint(equalTo: totalRow.topAnchor, constant: -8).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        ColorController.appendToList(key: ColorController.RowLabel, item: border, handler: { return $0.withAlphaComponent(0.1) })
        
        contentScrollView.layer.masksToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scrolled(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        self.layoutIfNeeded()
        scrollViewHeight = contentScrollView.frame.height
    }
    
    /**
     Refreshes the rows and arranges them in the correct position
     */
    private func refreshRowLayouts() {
        contentScrollView.layoutIfNeeded()
        
        var previous: NSLayoutYAxisAnchor?
        var index = rows.count - 1
        rows.reversed().forEach({ row in
            row.1.isActive = false
            rows[index].1 = row.0.bottomAnchor.constraint(equalTo: previous ?? contentView.bottomAnchor, constant: (previous == nil) ? -4 : 0)
            rows[index].1.isActive = true
            previous = row.0.topAnchor
            index -= 1
        })
        
        let openHeight = rows[selectedIndex].0.frame.height
        let standardHeight = (rows.count <= 1) ? 0 : ((selectedIndex == 0) ? rows[0].0.frame.height : rows[1].0.frame.height)
        
        let count = CGFloat(rows.count - 1)
        let preferedHeight = (openHeight + (count * standardHeight))
        
        contentView.removeConstraint(contentViewHeightAxis)
        contentViewHeightAxis = contentView.heightAnchor.constraint(equalToConstant: (preferedHeight == 0) ? 16: preferedHeight)
        contentViewHeightAxis.isActive = true
        
        contentHeight = preferedHeight
        setScroll(usesTransform: false)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    /**
     The final (target) transform of the scroll
     */
    var finalTransform: CGFloat = 0
    
    /**
     Sets the scroll position
     usesTransform? : should the final transform be checked and validated (incase above or below the limits)
     */
    func setScroll(usesTransform: Bool) {
        var maxScroll = (contentHeight - scrollViewHeight)
        if (maxScroll < 0) { maxScroll = 0 }
        
        print("MAX SCROLL", maxScroll)
        
        if (usesTransform) {
            if (finalTransform < 0) { finalTransform = 0 }
            else if (finalTransform > maxScroll) { finalTransform = maxScroll }
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 2.2, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: (usesTransform) ? self.finalTransform : self.currentOffset)
        }, completion: nil)
    }
    
    /**
     Event called when UIPanGestureRecognizer recognises a pan
     */
    @objc func scrolled(gesture: UIPanGestureRecognizer) {
        finalTransform = currentOffset + gesture.translation(in: self).y
        
        if (gesture.state == .changed) {
            setScroll(usesTransform: true)
        } else if (gesture.state == .ended) {
            setScroll(usesTransform: true)
            currentOffset = finalTransform
            finalTransform = 0
            
            if (abs(gesture.translation(in: self).y) < 16 && abs(gesture.translation(in: self).x) > 28) {
                ViewController.controlDelegate.backspace()
            }
        }
    }

    func addRow() {
        let newRow = UICalculationRow(allowUserUnitChanging: true)
        contentView.addSubview(newRow)
        newRow.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        newRow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        let yAnchor = newRow.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        yAnchor.isActive = true
        
        rows.append((newRow, yAnchor))
        setSelectedIndex(index: rows.count - 1)
        refreshRowLayouts()
    }
    
    func nextRow() {
        let nextRow = selectedIndex + 1
        if (nextRow >= rows.count) {
            addRow()
        } else {
            setSelectedIndex(index: nextRow)
        }
    }
    
    func setSelectedIndex(at: UICalculationRow) {
        guard let atIndex = rows.firstIndex(where: { i in
            return (i.0 === at)
        }) else { return }
        
        setSelectedIndex(index: atIndex)
    }
    
    func removeCurrent() {
        rows[selectedIndex].0.removeFromSuperview()
        rows.remove(at: selectedIndex)

        if (rows.count == 0) { addRow() }

        setSelectedIndex(index: rows.count - 1)
        refreshRowLayouts()
    }
    
    func clear() {
        rows.forEach({ child in
            child.1.isActive = false
            child.0.removeFromSuperview()
        })
        
        contentScrollView.layoutIfNeeded()
        rows = []
        
        selectedIndex = 0
        addRow()
        
        contentView.transform = CGAffineTransform.identity
    }
    
    func setSelectedIndex(index: Int) {
        selectedIndex = index
        rows.forEach({ row in row.0.blur() })
        
        getCurrent().focus()
    }
    
    func getCurrent() -> UICalculationRow {
        return rows[selectedIndex].0
    }
}
