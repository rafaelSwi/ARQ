//
//  CurrencyFieldViewModel.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import Combine
import SwiftUI

@MainActor
final class CurrencyFieldViewModel: ObservableObject {
    
    let amountFieldTitle: LocalizedStringKey = "amount"
    
    func persistMoneySymbol(_ value: Binding<String>, newValue: String) {
        if !newValue.hasPrefix("$") {
            value.wrappedValue = "$" + newValue.replacingOccurrences(of: "$", with: "")
        }
    }
    
    func currencyName(_ currency: String) -> String {
        return currency.isEmpty ? "nothing_selected".localized : currency
    }
    
    private func currencyIconName(_ currency: String) -> String {
        return "icon_\(currency)".lowercased()
    }
    
    @ViewBuilder
    func currencyIcon(_ currency: String) -> some View {
        let name = currencyIconName(currency)
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
        } else {
            Image("icon_unknown")
        }
    }
    
}
