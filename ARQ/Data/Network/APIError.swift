//
//  APIError.swift
//  ARQ
//
//  Created by rafael on 27/05/26.
//

import Foundation

enum APIError: LocalizedError, Error {
    case invalidResponse
    case noInternet
    case timeout
    case decodingFailed
    case invalidURL
    case internalServerError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:     return "error_invalid_response"
        case .noInternet:          return "error_no_internet"
        case .timeout:             return "error_timeout"
        case .decodingFailed:      return "error_decoding_failed"
        case .invalidURL:          return "error_invalid_url"
        case .internalServerError: return "error_internal_server"
        }
    }
}
