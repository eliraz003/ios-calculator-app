//
//  Device.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

class Device {
    enum DeviceType: Int {
        case small = 1,
             medium = 2,
             large = 3,
             ipad = 4
    }
    
    static var typeOf: DeviceType = {
        let width = UIScreen.main.bounds.width
        print("DEVIE WIDTH", width)
        
        if (width <= 320) {
            return .small
        } else if (width <= 390) {
            return .medium
        } else if (width <= 428) {
            return .large
        }
        
        return .ipad
    }()
    
    static var hasSafeAreaInset: Bool = {
//        if #available(iOS 11.0, tvOS 11.0, *) {
//            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 }
        
//        return false

        /**
          ## TODO: THIS PART OF THE CODE DOES NOT WORK AND ALWAYS RETURNS FALSE
         */
        
        let window: UIWindow? = {
            return UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: { return $0.isKeyWindow })
        }()
        
        return (window?.safeAreaInsets.top ?? 0) >= 44
    }()
}
