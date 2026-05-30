//
//  TickersRepository.swift
//  ARQ
//
//  Created by rafael on 29/05/26.
//

final class TickersRepository: TickersRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchTickers() async throws -> [String] {
        let response: TickersCurrenciesResponseDTO = try await apiClient.request(.tickersCurrencies())
        return response
    }

}
