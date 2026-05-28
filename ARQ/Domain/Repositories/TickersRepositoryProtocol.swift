//
//  TickersRepositoryProtocol.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

protocol TickersRepositoryProtocol {
    func fetchTickers() async throws -> [String]
}
