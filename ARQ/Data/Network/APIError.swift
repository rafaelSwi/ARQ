//
//  APIError.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

enum APIError: Error {
    case invalidResponse
    case noInternet
    case timeout
    case decodingFailed
}
