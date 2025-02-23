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
    
    let parameters = ["username": username, "password": password]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(false, error.localizedDescription)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(false, "Server error")
            return
        }
        
        // Assuming the server sends back a JSON with a token or success message
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let token = json["token"] as? String {
            // Save the token securely (you might want to use Keychain for this)
            UserDefaults.standard.set(token, forKey: "authToken")
            completion(true, nil)
        } else {
            completion(false, "Invalid server response")
        }
    }.resume()
}
