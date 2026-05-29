//
//  CurrencyUtils.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

final class CurrencyUtils {
    
    static func currencyName(_ currency: String) -> String {
        return currency.isEmpty ? "nothing_selected".localized : currency
    }
    
    static func currencyIconName(_ currency: String) -> String {
        return "currency_icon_\(currency)".lowercased()
    }
    
}
