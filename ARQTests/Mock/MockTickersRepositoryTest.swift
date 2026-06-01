//
//  MockTickersRepositoryTest.swift
//  ARQ
//
//  Created by rafael on 31/05/26.
//

@testable import ARQ
import Foundation

final class MockTickersRepositoryTest: TickersRepositoryProtocol {

    var shouldThrow = false
    var stubbedTickers = ["MXN", "ARS", "BRL", "COP", "EURc"]

    func fetchTickers() async throws -> [String] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return stubbedTickers
    }
}
