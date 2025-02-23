//
//  Endpoint.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let body: Encodable?
    var headers: [String: String]?
    
    init(path: String, method: HTTPMethod = .get, body: Encodable? = nil, headers: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers ?? ["Content-Type": "application/json"]
    }
}

extension Endpoint {
    static func login(email: String, password: String) -> Endpoint {
        return Endpoint(path: "/login", method: .post, body: ["email": email, "password": password])
    }
    
    static func register(user: User) -> Endpoint {
        return Endpoint(path: "/register", method: .post, body: user)
    }
    
    static func getProfile(userId: String) -> Endpoint {
        return Endpoint(path: "/profile/\(userId)")
    }
    
    static func updateProfile(profile: Profile) -> Endpoint {
        return Endpoint(path: "/profile", method: .put, body: profile)
    }
    
    static func getFeed() -> Endpoint {
        return Endpoint(path: "/feed")
    }
    
    static func getMatches() -> Endpoint {
        return Endpoint(path: "/matches")
    }
    
    static func sendMessage(to userId: String, content: String) -> Endpoint {
        return Endpoint(path: "/messages", method: .post, body: ["receiverId": userId, "content": content])
    }
    
    static func getFeed(page: Int, pageSize: Int) -> Endpoint {
            return Endpoint(path: "/feed?page=\(page)&pageSize=\(pageSize)")
    }
    
}
