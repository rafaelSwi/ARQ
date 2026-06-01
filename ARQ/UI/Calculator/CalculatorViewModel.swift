//
//  CalculatorViewModel.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Combine
import SwiftUI
import Network

@MainActor
final class CalculatorViewModel: ObservableObject {
    
    private let exchangeRatesService: ExchangeRatesService
    private let tickersService: TickersService
    
    private var pollingTask: Task<Void, Never>?
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    
    init(
        exchangeRatesService: ExchangeRatesService,
        tickersService: TickersService
    ) {
        self.exchangeRatesService = exchangeRatesService
        self.tickersService = tickersService
        startNetworkMonitor()
    }
    
    let title: LocalizedStringKey = "exchange_calculator_title"
    
    @Published var currencies: [String] = []
    @Published var exchangeRates: [ExchangeRates] = []
    
    @Published var errorMessage: String? = nil
    @Published var showInterchangeSheet: Bool = false
    @Published var showExchangeRateChangedWarning: Bool = false
    
    @Published var mainCurrency: String = ""
    @Published var mainCurrencyValue: Double = 0.0
    
    @Published var secondaryCurrency: String = ""
    @Published var secondaryCurrencyValue: Double = 0.0
    
    @Published var mainFieldActive: Bool = false
    @Published var secondaryFieldActive: Bool = false
    
    let cooldownToRefreshExchangeRate: Int = 60
    
    func onDismissSheetAction() {
        VibrationUtils.softVibrate()
        showInterchangeSheet = false
    }
    
    func swapButtonAction() {
        VibrationUtils.softVibrate()
        UsabilityUtils.lowerKeyboard()
        mainFieldActive = false
        secondaryFieldActive = false
        if mainCurrency.isEmpty || secondaryCurrency.isEmpty {
            return
        } else {
            swap()
        }
    }
    
    func retryButtonAction() async {
        VibrationUtils.softVibrate()
        errorMessage = nil
        await loadData()
    }
    
    var currentPriceInformation: String {
        if isAnyCurrencyNotSelected {
            return "\("selected_currency".localized) \(mainCurrency)"
        } else {
            let convertedValue: Double = convert(mainCurrency, secondaryCurrency, amount: 1) ?? 0
            return "1 \(mainCurrency) = \(formatConvertedValue(convertedValue)) \(secondaryCurrency)"
        }
    }
    
    var isAnyCurrencyNotSelected: Bool {
        return mainCurrency.isEmpty || secondaryCurrency.isEmpty
    }
    
    var somethingGoneWrong: Bool {
        return errorMessage != nil
    }
    
    func onMainCurrencyValueChange() {
        defer { showExchangeRateChangedWarning = false }
        secondaryCurrencyValue = convert(mainCurrency, secondaryCurrency, amount: mainCurrencyValue) ?? 0.0
    }
    
    func onSecondaryCurrencyValueChange() {
        defer { showExchangeRateChangedWarning = false }
        mainCurrencyValue = convert(secondaryCurrency, mainCurrency, amount: secondaryCurrencyValue) ?? 0.0
    }
    
    func setMainFieldActive() {
        secondaryFieldActive = false
        mainFieldActive = true
    }
    
    func setSecondaryFieldActive() {
        mainFieldActive = false
        secondaryFieldActive = true
    }
    
    func interchangeableButtonAction() {
        VibrationUtils.softVibrate()
        showInterchangeSheet.toggle()
    }
    
    func onEmptyAreaClickAction() {
        UsabilityUtils.lowerKeyboard()
        mainFieldActive = false
        secondaryFieldActive = false
        showExchangeRateChangedWarning = false
        updateFieldValueBasedOnFocus()
    }
    
    func interchangeCurrency(_ currency: String) {
        VibrationUtils.softVibrate()
        if currency == mainCurrency {
            swap()
        } else {
            secondaryCurrency = currency
            secondaryCurrencyValue = convert(mainCurrency, currency, amount: mainCurrencyValue) ?? 0
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
    
    func startPolling() {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(cooldownToRefreshExchangeRate))
                guard !Task.isCancelled else { break }
                guard isConnected else { continue }
                await refreshRates()
            }
        }
    }
    
    private func refreshRates() async {
        do {
            try await loadExchangeRates()
        } catch {}
    }
    
    private func startNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
    
    var availableCurrencies: [String] {
        return currencies.filter { currency in
            exchangeRates.contains(where: {
                $0.book?.split(separator: "_")[1].lowercased() == currency.lowercased()
            })
        }
    }
    
    private var noFieldsAreBeingUsed: Bool {
        return !mainFieldActive && !secondaryFieldActive
    }
    
    private func swap() {
        Swift.swap(&mainCurrency, &secondaryCurrency)
        Swift.swap(&mainCurrencyValue, &secondaryCurrencyValue)
    }
    
    private func formatConvertedValue(_ value: Double) -> String {
        if value == 0 { return "0" }
        
        if value >= 1 {
            return String(format: "%.2f", value)
        } else {
            let digits = Int(ceil(-log10(abs(value)))) + 2
            return String(format: "%.\(digits)f", value)
        }
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
        let existing = Set(currencies)
        let newItems = fetchedCurrencies.filter { !existing.contains($0) }
        currencies.append(contentsOf: newItems)
    }
    
    private func updateFieldValueBasedOnFocus() {
        if noFieldsAreBeingUsed {
            onMainCurrencyValueChange()
            onSecondaryCurrencyValueChange()
        }
    }
    
    private func manageShowExchangeRateWarning(_ book: String?) {
        if book == nil { return }
        let bookContainsMain = book!.contains(mainCurrency.lowercased())
        let bookContainsSecondary = book!.contains(secondaryCurrency.lowercased())
        let anyValueStored = mainCurrencyValue > 0 || secondaryCurrencyValue > 0
        let isSecondaryCurrencySelected = !secondaryCurrency.isEmpty
        if anyValueStored && isSecondaryCurrencySelected {
            if mainFieldActive || secondaryFieldActive {
                if bookContainsMain || bookContainsSecondary {
                    showExchangeRateChangedWarning = true
                }
            }
        }
    }
    
    private func loadExchangeRates() async throws {
        let fetchedExchangeRates: [ExchangeRates] = try await exchangeRatesService.execute(currencies: currencies)
        for fetched in fetchedExchangeRates {
            if let index = exchangeRates.firstIndex(where: { $0.book == fetched.book }) {
                let current = exchangeRates[index]
                if current.ask != fetched.ask || current.bid != fetched.bid {
                    exchangeRates[index] = fetched
                    manageShowExchangeRateWarning(current.book)
                    updateFieldValueBasedOnFocus()
                }
            } else {
                exchangeRates.append(fetched)
            }
        }
    }
}

extension CalculatorViewModel {
    static func makeDefault() -> CalculatorViewModel {
        let apiClient = APIClient(baseURL: URL(string: "https://api.dolarapp.dev")!)
        return CalculatorViewModel(
            exchangeRatesService: ExchangeRatesService(repository: ExchangeRatesRepository(apiClient: apiClient)),
            tickersService: TickersService(repository: TickersRepository(apiClient: apiClient))
        )
    }
    
    static func makeMock(_ seconds: Int) -> CalculatorViewModel {
        CalculatorViewModel(
            exchangeRatesService: ExchangeRatesService(repository: MockExchangeRatesRepository(fakeDelayInSeconds: seconds)),
            tickersService: TickersService(repository: MockTickersRepository(fakeDelayInSeconds: seconds))
        )
    }
}
