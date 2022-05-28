//
//  Dimensions.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit
    
class Dimensions {
    static var keyHeight: CGFloat = {
        if (Device.typeOf == .small) {
            return 46
        } else if (Device.typeOf == .large) {
            return 68
        }
        
        return 58
    }()
    
    static var keyFontsize: UIFont = {
        if (Device.typeOf == .small) {
            return UIFont.systemFont(ofSize: 30, weight: .light)
        } else if (Device.typeOf == .medium) {
            return UIFont.systemFont(ofSize: 32, weight: .light)
        }
        
        return UIFont.systemFont(ofSize: 36, weight: .regular)
    }()
    
    static var keypadBottomOffset: CGFloat = {
        var bottomSafeAreaInset: CGFloat = (Device.hasSafeAreaInset) ? 12 : 0
        
        if (Device.typeOf == .small) {
            return (12.0 + bottomSafeAreaInset)
        }
        
        return (24.0 + bottomSafeAreaInset)
    }()
    
    static var keypadKeySpacing = 4.0
    static var keypadPadding: CGFloat = {
        if (Device.typeOf == .small) {
            return 6
        }
        
        return 12
    }()
    
    static var unitFont: UIFont = {
        if ([Device.DeviceType.medium, Device.DeviceType.small].contains(Device.typeOf)) {
            return UIFont.systemFont(ofSize: 26, weight: .light)
        }
        
        
        return UIFont.systemFont(ofSize: 32, weight: .regular)
    }()
    
    static var focusedCalculationFont: UIFont = {
        if (Device.typeOf == .small) {
            return UIFont.systemFont(ofSize: 42, weight: .light)
        } else if (Device.typeOf == .medium) {
            return UIFont.systemFont(ofSize: 48, weight: .medium)
        }
            
        return UIFont.systemFont(ofSize: 54, weight: .semibold)
    }()
    
    static var blurredCalculationFont: UIFont = {
        if ([Device.DeviceType.medium, Device.DeviceType.small].contains(Device.typeOf)) {
            return UIFont.systemFont(ofSize: 28, weight: .regular)
        }
        
        return UIFont.systemFont(ofSize: 32, weight: .regular)
    }()
}
