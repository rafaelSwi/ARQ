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
    
    let interchangeableButtonIcon: String = "chevron.down"
    
    let clipPadding: CGFloat = 20
    
    let clipCornerRadius: CGFloat = 16
    
    func persistMoneySymbol(_ value: Binding<String>, newValue: String) {
        if !newValue.hasPrefix("$") {
            value.wrappedValue = "$" + newValue.replacingOccurrences(of: "$", with: "")
        }
    }
    
    @ViewBuilder
    func currencyIcon(_ currency: String) -> some View {
        let name = CurrencyUtils.currencyIconName(currency)
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
        } else {
            Image("currency_icon_unknown")
        }
    }
    
}
