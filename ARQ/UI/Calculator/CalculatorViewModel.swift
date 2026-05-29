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
    
    private let exchangeRatesService: ExchangeRatesService = ExchangeRatesService(repository: MockExchangeRatesRepository())
    private let tickersService: TickersService = TickersService(repository: MockTickersRepository())
    
    let title: LocalizedStringKey = "exchange_calculator_title"
    
    @Published var currencies: [String: Double?] = [:]
    @Published var exchangeRates: [ExchangeRates] = []
    
    @Published var errorMessage: String? = nil
    
    @Published var showInterchangeSheet: Bool = false
    
    @Published var mainCurrency: String = ""
    @Published var mainInput: String = ""
    
    @Published var secondaryCurrency: String = ""
    @Published var secondaryInput: String = ""
    
    func onDismissSheetAction() {
        VibrationUtils.softVibrate()
        showInterchangeSheet = false
    }
    
    func swap() {
        Swift.swap(&mainCurrency, &secondaryCurrency)
        Swift.swap(&mainInput, &secondaryInput)
    }
    
    func convertExchangeRate(_ exchangeRate: ExchangeRates) {
        if let bookCurrencyName = exchangeRate.book?.split(separator: "_")[1].lowercased() {
            if let matchingKey = currencies.keys.first(where: { $0.lowercased() == bookCurrencyName }) {
                currencies[matchingKey] = exchangeRate.ask
            }
        }
    }
    
    func interchangeableButtonAction() {
        VibrationUtils.softVibrate()
        showInterchangeSheet.toggle()
    }
    
    func interchangeCurrency(_ currency: String) {
        VibrationUtils.softVibrate()
        if currency == mainCurrency {
            swap()
        } else {
            secondaryCurrency = currency
        }
        showInterchangeSheet = false
    }
    
    func loadData() async {
        initializeUsdcValues()
        do {
            try await loadCurrencies()
            try await loadExchangeRates()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func initializeUsdcValues() {
        currencies["USDc"] = 1
        mainCurrency = "USDc"
    }
    
    private func loadCurrencies() async throws {
        let fetchedCurrencies: [String] = try await tickersService.execute()
        for fetched in fetchedCurrencies {
            if currencies[fetched] == nil {
                currencies.updateValue(nil, forKey: fetched)
            }
        }
    }
    
    private func loadExchangeRates() async throws {
        let fetchedExchangeRates: [ExchangeRates] = try await exchangeRatesService.execute()
        for fetched in fetchedExchangeRates {
            if let index = exchangeRates.firstIndex(where: { $0.book == fetched.book }) {
                exchangeRates[index] = fetched
            } else {
                exchangeRates.append(fetched)
            }
            convertExchangeRate(fetched)
        }
    }
    
}
