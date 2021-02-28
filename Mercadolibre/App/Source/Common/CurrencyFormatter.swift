//
//  CurrencyFormatter.swift
//  Mercadolibre
//
//  Created by Luis Cabarique on 28/02/21.
//

import Foundation

extension Float {
    func toCurrency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        currencyFormatter.currencySymbol = "$"
        currencyFormatter.minimumFractionDigits = 0
        
        return currencyFormatter.string(from: self as NSNumber) ?? "\(self)"
    }
}
