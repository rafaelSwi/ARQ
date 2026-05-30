//
//  ExchangeRatesRepositoryProtocol.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

protocol ExchangeRatesRepositoryProtocol {
    func fetchExchangeRates(currencies: [String]) async throws -> [ExchangeRates]
}
