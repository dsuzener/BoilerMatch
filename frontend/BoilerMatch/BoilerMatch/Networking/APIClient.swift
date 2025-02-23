//
//  APIClient.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import Foundation
import Combine

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://your-server-url.com/api"
    private var authToken: String?
    
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                if !(200...299).contains(httpResponse.statusCode) {
                    throw APIError.httpError(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.decodingError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
}
