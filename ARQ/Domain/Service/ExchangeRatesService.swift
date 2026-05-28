//
//  ExchangeRatesService.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

protocol ExchangeRatesServiceProtocol {
    func execute() async throws -> [ExchangeRates]
}

final class ExchangeRatesService: ExchangeRatesServiceProtocol {
    
    private let repository: ExchangeRatesRepositoryProtocol
    
    init(repository: ExchangeRatesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [ExchangeRates] {
        let rates = try await repository.fetchExchangeRates()
        return rates
    }
    
}
