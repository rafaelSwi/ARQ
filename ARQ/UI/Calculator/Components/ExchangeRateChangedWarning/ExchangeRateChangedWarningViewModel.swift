//
//  ExchangeRateChangedWarningViewModel.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

import Combine
import SwiftUI

@MainActor
final class ExchangeRateChangedWarningViewModel: ObservableObject {
    
    let exchangeRateChangedWarning: LocalizedStringKey = "warning_exchange_rate_changed"
    let exchangeRateChangedWarningHelp: LocalizedStringKey = "warning_exchange_rate_changed_help"
    
    @Published var opacity: Double = 0.4
    
    func startPulsing() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            opacity = 0.8
        }
    }
    
    func stopPulsing() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0.4
        }
    }
}
