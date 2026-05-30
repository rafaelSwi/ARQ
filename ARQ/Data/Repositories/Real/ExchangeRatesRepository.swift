//
//  ExchangeRatesRepository.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

final class ExchangeRatesRepository: ExchangeRatesRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchExchangeRates(currencies: [String]) async throws -> [ExchangeRates] {
        let response: ExchangeRatesResponseDTO = try await apiClient.request(.exchangeRates(currencies: currencies))
        return response.payload.map { $0.toDomain() }
    }

}
