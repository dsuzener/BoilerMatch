//
//  AuthenticationService.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//


import Foundation
import Combine

class AuthenticationService {
    static let shared = AuthenticationService()
    
    @Published var isAuthenticated = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        return APIClient.shared.request(Endpoint.login(email: email, password: password))
            .handleEvents(receiveOutput: { [weak self] (response: LoginResponse) in
                APIClient.shared.setAuthToken(response.token)
                self?.isAuthenticated = true
            })
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func logout() {
        APIClient.shared.setAuthToken("")
        isAuthenticated = false
    }
}

struct LoginResponse: Decodable {
    let user: User
    let token: String
}
