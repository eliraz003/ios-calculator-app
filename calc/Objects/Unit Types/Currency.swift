//
//  Currency.swift
//  calc
//
//  Created by Eliraz Atia on 24/05/2022.
//

import Foundation
import UIKit

enum CurrencyFetchError: Error {
    case CannotFetch
}

/**
 Decodable object response from server
 ## CHANGE ME ACCORDING TO YOUR CURRENCY API
 */
struct CurrencyServerResponse: Decodable {
    var name:String
//    var base_currency:String
    var value:CGFloat
    var date: String
}

class Currency: RateBasedUnit {
    var isoCode: String = ""
    var countries: [String] = []
    
    override var type: UnitType {
        get { return .currency }
    }
    
    convenience init(_ temp: CurrencyUnitController.Temp) {
        self.init(name: temp.name, symbol: temp.symbol, rate: 1)
        
        isoCode = temp.iso
        countries = temp.countries
    }
    
    override func getSymbol() -> String {
        if (symbol == "$") {
            if (isoCode == "USD") { return symbol }
            return isoCode
        } else if (symbol == "£") {
            if (isoCode == "GBP") { return symbol }
            return isoCode
        }
        
        return symbol
    }
    
    static func currencyAPIUrl(iso: String) -> String {
        /**
         CHANGE URL DEPENDING ON THE URL OF YOUR CURRENCY CALLBACK API
         */
        return "https://calculatooor-ios-default-rtdb.europe-west1.firebasedatabase.app/currencies/" + iso.uppercased() + ".json"
//        return "https://sheltered-earth-85165.herokuapp.com/api/currencies/v1?iso=" +
    }
    
    func fetchValue(_ completion: @escaping (FetchedCurrency?, Error?) -> Void, dontAttemptAgain: Bool = false) {
        let url = URL(string: Currency.currencyAPIUrl(iso: isoCode))!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if (error != nil || data == nil) {
                    if (dontAttemptAgain) {completion(nil, error)}
                    else {self.fetchValue(completion, dontAttemptAgain: true)}
                    return
                }
                
                do {
                    let asObject = try JSONDecoder().decode(CurrencyServerResponse.self, from: data!)
                    print("DATA", asObject)
                    let quoteValue = asObject.value
                    completion(FetchedCurrency(name: self.name, symbol: self.symbol, isoCode: self.isoCode, rate: quoteValue), nil)
                } catch {
                    if (dontAttemptAgain) {completion(nil, CurrencyFetchError.CannotFetch)}
                    else {self.fetchValue(completion, dontAttemptAgain: true)}
                }
            }
        }.resume()
    }
    
    class FetchedCurrency: Currency {
        convenience init(name: String, symbol: String, isoCode: String, rate: CGFloat) {
            self.init(name: name, symbol: symbol, rate: rate)
            self.isoCode = isoCode
        }
    }
}
