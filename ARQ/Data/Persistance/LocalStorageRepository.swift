//
//  LocalStorageRepository.swift
//  ARQ
//
//  Created by rafael on 01/06/26.
//

import Foundation

final class LocalStorageRepository {

    private let defaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func saveCurrencies(_ currencies: [String]) {
        let unique = currencies.reduce(into: [String]()) { result, currency in
            if !result.contains(where: { $0.lowercased() == currency.lowercased() }) {
                result.append(currency)
            }
        }
        guard let data = try? encoder.encode(unique) else { return }
        defaults.set(data, forKey: PersistenceKeys.currencies)
    }

    func loadCurrencies() -> [String] {
        guard
            let data = defaults.data(forKey: PersistenceKeys.currencies),
            let currencies = try? decoder.decode([String].self, from: data)
        else { return [] }
        return currencies
    }

    func saveExchangeRates(_ rates: [ExchangeRates]) {
        guard let data = try? encoder.encode(rates) else { return }
        defaults.set(data, forKey: PersistenceKeys.exchangeRates)
    }

    func loadExchangeRates() -> [ExchangeRates] {
        guard
            let data = defaults.data(forKey: PersistenceKeys.exchangeRates),
            let rates = try? decoder.decode([ExchangeRates].self, from: data)
        else { return [] }
        return rates
    }
    
    func saveSelectedCurrencies(main: String, secondary: String) {
        defaults.set(main, forKey: PersistenceKeys.mainCurrency)
        defaults.set(secondary, forKey: PersistenceKeys.secondaryCurrency)
    }

    func loadMainCurrency() -> String {
        return defaults.string(forKey: PersistenceKeys.mainCurrency) ?? ""
    }

    func loadSecondaryCurrency() -> String {
        return defaults.string(forKey: PersistenceKeys.secondaryCurrency) ?? ""
    }
}
