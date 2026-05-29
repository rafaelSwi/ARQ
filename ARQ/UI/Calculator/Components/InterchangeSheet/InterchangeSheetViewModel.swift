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
    
    let dismissButtonIcon: String = "xmark"
    
    let selectedCurrencyIcon: String = "checkmark"
    
    func currencyList(_ dict: [String: Double?], _ mainCurrency: String) -> [String] {
        return dict.keys.filter { $0 != mainCurrency }
    }
    
    
}
