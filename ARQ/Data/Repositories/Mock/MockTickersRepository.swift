//
//  MockTickersRepository.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

final class MockTickersRepository: TickersRepositoryProtocol {
    
    let fakeDelayInSeconds: Int
    
    init(fakeDelayInSeconds: Int) {
        self.fakeDelayInSeconds = fakeDelayInSeconds
    }
    
    func fetchTickers() async throws -> [String] {
        try await Task.sleep(for: .seconds(fakeDelayInSeconds))
        return ["MXN", "ARS", "BRL", "COP", "EURc"]
    }
    
}
