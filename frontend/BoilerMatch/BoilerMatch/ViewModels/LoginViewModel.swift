//
//  LoginViewModel.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import Foundation

func loginUser(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:8000/login") else {
        completion(false, "Invalid URL")
        return
    }
    
    let parameters: [String: Any] = [
        "username": username,
        "password": password
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    } catch {
        completion(false, "Failed to encode credentials")
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            DispatchQueue.main.async {
                completion(false, error.localizedDescription)
            }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            DispatchQueue.main.async {
                completion(false, "No server response")
            }
            return
        }
        
        switch httpResponse.statusCode {
        case 200:
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["token"] as? String else {
                DispatchQueue.main.async {
                    completion(false, "Invalid response format")
                }
                return
            }
            
            // Save token to Keychain (simplified example)
            UserDefaults.standard.set(token, forKey: "authToken")
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        case 401:
            DispatchQueue.main.async {
                completion(false, "Invalid credentials")
            }
            
        default:
            DispatchQueue.main.async {
                completion(false, "Server error: \(httpResponse.statusCode)")
            }
        }
    }.resume()
}
