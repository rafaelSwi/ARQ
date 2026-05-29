//
//  MockExchangeRatesRepository.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

final class MockExchangeRatesRepository: ExchangeRatesRepositoryProtocol {
    
    func fetchExchangeRates() async throws -> [ExchangeRates] {
        try await Task.sleep(for: .seconds(3))
        return [
            ExchangeRates(
                ask: 1,
                bid: 1,
                book: "usdc_usdc",
                date: nil,
            ),
            ExchangeRates(
                ask: 18.4105000000,
                bid: 18.4069700000,
                book: "usdc_mxn",
                date: "2025-10-20T20:14:57.361483956".asDate()
            ),
            ExchangeRates(
                ask: 1551.0000000000,
                bid: 1539.4290300000,
                book: "usdc_ars",
                date: "2025-10-21T09:44:18.512194175".asDate()
            )
        ]
    }
    
}
