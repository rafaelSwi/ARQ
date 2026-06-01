//
//  ErrorWarningViewModel.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import Combine
import SwiftUI

@MainActor
final class ErrorWarningViewModel: ObservableObject {
    
    let errorLabel: LocalizedStringKey = "error_fetching_latest_exchange_rate"
    
    let retryButtonLabel: LocalizedStringKey = "try_again"
    
    let offlineModeButtonLabel: LocalizedStringKey = "ignore_for_now"
    
}
