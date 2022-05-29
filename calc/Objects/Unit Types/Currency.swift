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
    var quote_currency:String
    var base_currency:String
    var quote:CGFloat
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
    
    func fetchValue(_ completion: @escaping (Unit?, Error?) -> Void, dontAttemptAgain: Bool = false) {
        let url = URL(string: "https://sheltered-earth-85165.herokuapp.com/api/currencies/v1?iso=" + isoCode.uppercased())!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if (error != nil || data == nil) {
                    if (dontAttemptAgain) {completion(nil, error)}
                    else {self.fetchValue(completion, dontAttemptAgain: true)}
                    return
                }
                
                do {
                    let asObject = try JSONDecoder().decode(CurrencyServerResponse.self, from: data!)
                    let quoteValue = asObject.quote
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
