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
        print("[Request] \(urlRequest.httpMethod ?? "?") \(urlRequest.url?.absoluteString ?? "no URL")")

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let body = String(data: data, encoding: .utf8) ?? "<nothing>"
                print("[Request] Status \(statusCode) — body: \(body)")
                if statusCode == 500 {
                    throw APIError.internalServerError
                }
                throw APIError.invalidResponse
            }

            print("[Request] Status \(http.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("[Request] Body: \(responseString)")
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                print("[Request] Decode OK for \(T.self)")
                return decoded
            } catch {
                print("[Request] Decode failed for \(T.self): \(error)")
                throw APIError.decodingFailed
            }

        } catch let urlError as URLError {
            print("[Request] URLError \(urlError.code.rawValue): \(urlError.localizedDescription)")
            switch urlError.code {
            case .notConnectedToInternet: throw APIError.noInternet
            case .timedOut: throw APIError.timeout
            default: throw APIError.invalidResponse
            }
        }
    }
    
}
