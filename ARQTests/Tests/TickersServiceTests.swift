//
//  TickersServiceTests.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

import Testing
@testable import ARQ
import Foundation

@Suite("TickersService")
@MainActor
struct TickersServiceTests {

    @Test("Returns tickers from repository successfully")
    func returnsTickersOnSuccess() async throws {
        let repo = MockTickersRepositoryTest()
        let sut  = TickersService(repository: repo)

        let result = try await sut.execute()

        #expect(result == ["MXN", "ARS", "BRL", "COP", "EURc"])
    }

    @Test("Returns empty list when repository has no tickers")
    func returnsEmptyWhenRepositoryIsEmpty() async throws {
        let repo = MockTickersRepositoryTest()
        repo.stubbedTickers = []
        let sut = TickersService(repository: repo)

        let result = try await sut.execute()

        #expect(result.isEmpty)
    }

    @Test("Propagates repository error")
    func propagatesRepositoryError() async throws {
        let repo = MockTickersRepositoryTest()
        repo.shouldThrow = true
        let sut = TickersService(repository: repo)

        await #expect(throws: URLError.self) {
            try await sut.execute()
        }
    }
}
