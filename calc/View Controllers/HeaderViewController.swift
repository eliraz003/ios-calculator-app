//
//  HeaderViewController.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit


//TODO: TO REMOVE
/**
 HeaderViewController is used as a root class for a UIViewController that has a background colour and a title label included
 */
class HeaderViewController: UIViewController {
    let titleLabel = UILabel()
    var viewTitle: String { return "" }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 46).isActive = true
        titleLabel.text = viewTitle
        titleLabel.textColor = UIColor(named: "primary_text")
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    }
}

