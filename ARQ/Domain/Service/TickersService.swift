//
//  TickersService.swift
//  ARQ
//
//  Created by rafael on 28/05/26.
//

protocol TickersServiceProtocol {
    func execute() async throws -> [String]
}

final class TickersService: TickersServiceProtocol {
    
    private let repository: TickersRepositoryProtocol
    
    init(repository: TickersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [String] {
        return try await repository.fetchTickers()
    }
    
}
