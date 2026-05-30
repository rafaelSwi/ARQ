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
    let body: Data?
    
    func asURLRequest(baseURL: URL) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

extension Endpoint {
    static func exchangeRates(currencies: [String]) -> Endpoint {
        let joined = currencies.joined(separator: ",")
        return Endpoint(
            path: "/v1/tickers?currencies=\(joined)",
            method: "GET",
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
