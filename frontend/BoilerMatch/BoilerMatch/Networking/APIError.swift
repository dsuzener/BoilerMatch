//
//  APIError.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case unknown
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from the server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError:
            return "Error decoding the response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
