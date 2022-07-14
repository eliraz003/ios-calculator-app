//
//  AppDelegate.swift
//  calc
//
//  Created by Eliraz Atia on 27/03/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CurrencyUnitController.fetchCurrencies()
        EntryMemoryController.findFromStorage()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension UIColor {
    static func fromHex(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { return UIColor.gray }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public func adjust(hueBy hue: CGFloat = 0, saturationBy saturation: CGFloat = 0, brightnessBy brightness: CGFloat = 0) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue,
                       saturation: currentSaturation + saturation,
                       brightness: currentBrigthness + brightness,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
}

extension String {
    var isNumber: Bool {
        get {
            var foundNoneNumber = false
            self.forEach({
                if (!$0.isNumber) { foundNoneNumber = true }
            })
            
            if (self.count == 0) { return false }
            return !foundNoneNumber
        }
    }
}

extension NumberFormatter {
    static func usingOverallCharacterCount(value: CGFloat, min: Int, max: Int, dontUseSeperators: Bool = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.alwaysShowsDecimalSeparator = true
        
        let finalValueAsString = numberFormatter.string(from: NSNumber(value: value))!
        let beforeDecimalCharacterCount = finalValueAsString.split(separator: ".").map({ i in return String(i) })[0].count
        
        var numberOfDecimalsAllowed = (max - beforeDecimalCharacterCount)
        if (numberOfDecimalsAllowed <= min) { numberOfDecimalsAllowed = min }
        numberFormatter.maximumFractionDigits = numberOfDecimalsAllowed
        
        var absoluteFinalValue = numberFormatter.string(from: NSNumber(value: value))!
        if (absoluteFinalValue.last == ".") {
            absoluteFinalValue = absoluteFinalValue.replacingOccurrences(of: ".", with: "")
        }
        
        if (dontUseSeperators && absoluteFinalValue.contains(",")) {
            absoluteFinalValue = absoluteFinalValue.replacingOccurrences(of: ",", with: "")
        }
        
        return absoluteFinalValue
    }
    
    static func simple(value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.alwaysShowsDecimalSeparator = false
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    static func simple(value: String) -> Double {
        return Double(value) ?? 0
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.alwaysShowsDecimalSeparator = false
//        return numberFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
}
