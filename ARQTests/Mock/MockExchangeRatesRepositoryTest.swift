//
//  MockExchangeRatesRepositoryTest.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

@testable import ARQ
import Foundation

final class MockExchangeRatesRepositoryTest: ExchangeRatesRepositoryProtocol {

    var shouldThrow = false
    var stubbedRates: [ExchangeRates] = [
        ExchangeRates(ask: 1,       bid: 1,       book: "usdc_usdc", date: nil),
        ExchangeRates(ask: 18.41,   bid: 18.40,   book: "usdc_mxn",  date: Date()),
        ExchangeRates(ask: 1551.00, bid: 1539.43, book: "usdc_ars",  date: Date()),
        ExchangeRates(ask: 0.8597,  bid: 0.8590,  book: "usdc_eurc", date: Date()),
        ExchangeRates(ask: 3771.27, bid: 3768.00, book: "usdc_cop",  date: Date()),
        ExchangeRates(ask: 5.23,    bid: 5.21,    book: "usdc_brl",  date: Date())
    ]

    func fetchExchangeRates(currencies: [String]) async throws -> [ExchangeRates] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return stubbedRates.filter { rate in
            guard let book = rate.book else { return false }
            return currencies.contains { book.hasSuffix($0.lowercased()) }
        }
    }
}
