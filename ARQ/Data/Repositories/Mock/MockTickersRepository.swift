//
//  MockTickersRepository.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

final class MockTickersRepository: TickersRepositoryProtocol {
    
    func fetchTickers() async throws -> [String] {
        try await Task.sleep(for: .seconds(3))
        return ["MXN", "ARS", "BRL", "COP"]
    }
    
    
    
    
}
