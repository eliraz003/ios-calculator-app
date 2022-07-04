//
//  UIScrollableSelector.swift
//  calc
//
//  Created by Eliraz Atia on 04/07/2022.
//

import Foundation
import UIKit

class UIScrollableSelector<T:Any>: UIView {
    let scroller = UIScrollView()
    
    private var scrollerHeightAnchor: NSLayoutConstraint!
    private var selfBottomAnchor: NSLayoutConstraint!
    
    var items: [T]
    var render: (T) -> UIView
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(title displayTitle: String, items: [T], render: @escaping (T) -> UIView) {
        self.items = items
        self.render = render
        
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        title.text = displayTitle
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        border.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        scroller.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroller)
        scroller.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        scroller.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        scroller.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 6).isActive = true
        
        refresh()
    }
    
    @discardableResult func refresh() -> UIView? {
        scroller.subviews.forEach({ $0.removeFromSuperview() })
        
        var previous: UIView?
        items.forEach({ item in
            let newView = render(item)
            newView.translatesAutoresizingMaskIntoConstraints = false
            scroller.addSubview(newView)
            newView.leftAnchor.constraint(equalTo: previous?.rightAnchor ?? scroller.leftAnchor, constant: (previous == nil) ? 0 : 6).isActive = true
            newView.topAnchor.constraint(equalTo: scroller.topAnchor, constant: 0).isActive = true
            
            previous = newView
        })
        
        layoutIfNeeded()
        scroller.contentSize = CGSize(width: previous?.frame.maxX ?? 0, height: scroller.contentSize.height)
        
        if (scrollerHeightAnchor != nil && scrollerHeightAnchor != nil) {
            scroller.removeConstraint(scrollerHeightAnchor)
            self.removeConstraint(scrollerHeightAnchor)
        }
        
        scrollerHeightAnchor = scroller.heightAnchor.constraint(equalToConstant: previous?.frame.height ?? 0)
        selfBottomAnchor = self.bottomAnchor.constraint(equalTo: scroller.bottomAnchor, constant: 12)
        scrollerHeightAnchor.isActive = true
        selfBottomAnchor.isActive = true
        
        return previous
    }
}
