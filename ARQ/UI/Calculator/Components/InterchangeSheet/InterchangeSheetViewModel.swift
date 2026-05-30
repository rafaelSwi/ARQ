//
//  InterchangeSheetViewModel.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

import Combine
import SwiftUI

@MainActor
final class InterchangeSheetViewModel: ObservableObject {
    
    let chooseCurrencyTitle: LocalizedStringKey = "choose_currency"
    
    let loadingCurrenciesLabel: LocalizedStringKey = "loading_currencies"
    
    let errorMessageLabel: LocalizedStringKey = "an_error_occurred"
    
    let dismissButtonIcon: String = "xmark"
    
    let errorIcon: String = "exclamationmark.circle"
    
    let selectedCurrencyIcon: String = "checkmark"
    
    func currencyList(_ currencies: [String], _ mainCurrency: String) -> [String] {
        return currencies.filter { $0 != mainCurrency }
    }
    
    
}
