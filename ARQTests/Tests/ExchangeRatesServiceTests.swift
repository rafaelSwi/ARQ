//
//  ExchangeRatesServiceTests.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

import Testing
@testable import ARQ
import Foundation

@Suite("ExchangeRatesService")
@MainActor
struct ExchangeRatesServiceTests {

    @Test("Filters correctly by a single currency")
    func filtersSingleCurrency() async throws {
        let repo = MockExchangeRatesRepositoryTest()
        let sut  = ExchangeRatesService(repository: repo)

        let result = try await sut.execute(currencies: ["brl"])

        #expect(result.count == 1)
        #expect(result.first?.book == "usdc_brl")
    }

    @Test("Filters correctly by multiple currencies")
    func filtersMultipleCurrencies() async throws {
        let repo = MockExchangeRatesRepositoryTest()
        let sut  = ExchangeRatesService(repository: repo)

        let result = try await sut.execute(currencies: ["brl", "ars", "mxn"])

        #expect(result.count == 3)
        let books = result.map { $0.book }
        #expect(books.contains("usdc_brl"))
        #expect(books.contains("usdc_ars"))
        #expect(books.contains("usdc_mxn"))
    }

    @Test("Returns empty list for unknown currency")
    func returnsEmptyForUnknownCurrency() async throws {
        let repo = MockExchangeRatesRepositoryTest()
        let sut  = ExchangeRatesService(repository: repo)

        let result = try await sut.execute(currencies: ["???"])

        #expect(result.isEmpty)
    }

    @Test("Returns empty list for empty input")
    func returnsEmptyForEmptyInput() async throws {
        let repo = MockExchangeRatesRepositoryTest()
        let sut  = ExchangeRatesService(repository: repo)

        let result = try await sut.execute(currencies: [])

        #expect(result.isEmpty)
    }

    @Test("Propagates repository error")
    func propagatesRepositoryError() async throws {
        let repo = MockExchangeRatesRepositoryTest()
        repo.shouldThrow = true
        let sut = ExchangeRatesService(repository: repo)

        await #expect(throws: URLError.self) {
            try await sut.execute(currencies: ["brl"])
        }
    }
}
