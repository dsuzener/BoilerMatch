//
//  LoginViewModel.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import Foundation

func loginUser(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:8000/api/login") else {
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
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, "No data received from server")
                }
                return
            }
            
            do {
                // Decode the JSON response into a User object
                let user = try JSONDecoder().decode(FeedItem.self, from: data)
                
                // Save the username to UserDefaults for later use
                UserDefaults.standard.set(user.name, forKey: "username")
                UserDefaults.standard.set(user.bio, forKey: "bio")
                UserDefaults.standard.register(defaults: ["age": 0])
                UserDefaults.standard.set(user.age, forKey: "age")
                
                DispatchQueue.main.async {
                    completion(true, "Success!") // Login successful with user object
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Failed to decode server response: \(error.localizedDescription)")
                }
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
