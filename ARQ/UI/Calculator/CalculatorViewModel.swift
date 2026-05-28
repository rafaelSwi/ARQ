//
//  CalculatorViewModel.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Combine
import SwiftUI

@MainActor
final class CalculatorViewModel: ObservableObject {
    
    let title: LocalizedStringKey = "exchange_calculator_title"
    
    @Published var mainCurrency: String = ""
    @Published var mainInput: String = ""
    
    @Published var secondaryCurrency: String = ""
    @Published var secondaryInput: String = ""
    
}
