//
//  APIClient.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Foundation

final class APIClient {
    
    private let session: URLSession
    private let baseURL: URL
    
    init(session: URLSession = .shared, baseURL: URL) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
            let urlRequest = try endpoint.asURLRequest(baseURL: baseURL)
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw APIError.invalidResponse
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        }
    
}
