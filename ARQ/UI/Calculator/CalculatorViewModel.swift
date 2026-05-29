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
    
    @Published var currencies: [String] = []
    @Published var exchangeRates: [ExchangeRates] = []
    
    @Published var errorMessage: String? = nil
    
    @Published var showInterchangeSheet: Bool = false
    
    @Published var mainCurrency: String = ""
    @Published var mainInput: String = ""
    
    @Published var secondaryCurrency: String = ""
    @Published var secondaryInput: String = ""
    
    var updatingInputValue: Bool = false
    
    func onDismissSheetAction() {
        VibrationUtils.softVibrate()
        showInterchangeSheet = false
    }
    
    func swap() {
        Swift.swap(&mainCurrency, &secondaryCurrency)
        Swift.swap(&mainInput, &secondaryInput)
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
            onMainInputChange()
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
    
    var availableCurrencies: [String] {
        return currencies.filter { currency in
            exchangeRates.contains(where: {
                $0.book?.split(separator: "_")[1].lowercased() == currency.lowercased()
            })
        }
    }
    
    func onMainInputChange() {
        updateInput(from: mainCurrency, to: secondaryCurrency, source: mainInput) {
            secondaryInput = $0
        }
    }

    func onSecondaryInputChange() {
        updateInput(from: secondaryCurrency, to: mainCurrency, source: secondaryInput) {
            mainInput = $0
        }
    }

    private func updateInput(from: String, to: String, source: String, update: (String) -> Void) {
        guard !updatingInputValue else { return }
        updatingInputValue = true
        defer { updatingInputValue = false }
        if let converted = convert(from, to, amount: parseInput(source)) {
            update("$\(String(format: "%.2f", converted))")
        }
    }
    
    private func parseInput(_ input: String) -> Double {
        let cleaned = input.replacingOccurrences(of: "$", with: "")
        return Double(cleaned) ?? 0
    }
    
    private func convert(_ fromCurrency: String, _ toCurrency: String, amount: Double) -> Double? {
        let fromValue = currencyValueInUSDc(fromCurrency)
        let toValue = currencyValueInUSDc(toCurrency)
        guard let fromValue, let toValue, fromValue != 0 else { return nil }
        return (amount / fromValue) * toValue
    }

    private func currencyValueInUSDc(_ currency: String) -> Double? {
        let currencyName = currency.lowercased()
        for exchangeRate in exchangeRates {
            let exchangeRateCurrencyName = exchangeRate.book?.split(separator: "_")[1].lowercased() ?? ""
            if exchangeRateCurrencyName == currencyName {
                return exchangeRate.ask
            }
        }
        return nil
    }
    
    private func initializeUsdcValues() {
        currencies.append("USDc")
        mainCurrency = "USDc"
    }
    
    private func loadCurrencies() async throws {
        let fetchedCurrencies: [String] = try await tickersService.execute()
        for fetched in fetchedCurrencies {
            if currencies.contains(fetched) == false {
                currencies.append(fetched)
            }
        }
    }
    
    private func loadExchangeRates() async throws {
        let fetchedExchangeRates: [ExchangeRates] = try await exchangeRatesService.execute()
        print("fetchedExchangeRates: \(fetchedExchangeRates)")
        for fetched in fetchedExchangeRates {
            if let index = exchangeRates.firstIndex(where: { $0.book == fetched.book }) {
                exchangeRates[index] = fetched
            } else {
                exchangeRates.append(fetched)
            }
        }
    }
    
}
