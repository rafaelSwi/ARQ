//
//  Endpoint.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Foundation

struct Endpoint {
    let path: String
    let method: String
    var queryItems: [URLQueryItem] = []
    let body: Data?
    
    func asURLRequest(baseURL: URL) throws -> URLRequest {
            var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                           resolvingAgainstBaseURL: true)
            if !queryItems.isEmpty {
                components?.queryItems = queryItems
            }

            guard let url = components?.url else { throw APIError.invalidURL }

            var request = URLRequest(url: url)
            request.httpMethod = method
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            request.httpBody = body
            return request
        }
}

extension Endpoint {
    static func exchangeRates(currencies: [String]) -> Endpoint {
        return Endpoint(
            path: "/v1/tickers",
            method: "GET",
            queryItems: [URLQueryItem(name: "currencies", value: currencies.joined(separator: ","))],
            body: nil
        )
    }

    static func tickersCurrencies() -> Endpoint {
        return Endpoint(
            path: "/v1/tickers-currencies",
            method: "GET",
            body: nil
        )
    }
}
