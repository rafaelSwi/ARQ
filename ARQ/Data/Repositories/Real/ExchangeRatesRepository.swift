//
//  ExchangeRatesRepository.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

import Foundation

final class ExchangeRatesRepository: ExchangeRatesRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchExchangeRates(currencies: [String]) async throws -> [ExchangeRates] {
        var results: [ExchangeRates] = []
        
        results.append(
            ExchangeRates(ask: 1.0, bid: 1.0, book: "usdc_usdc", date: Date.now)
        )

        for currency in currencies {
            do {
                let response: [ExchangeRateDTO] = try await apiClient.request(.exchangeRates(currencies: [currency]))
                let mapped = response.map { $0.toDomain() }
                results.append(contentsOf: mapped)
            } catch APIError.internalServerError {
                continue
            }
        }

        return results
    }

}
