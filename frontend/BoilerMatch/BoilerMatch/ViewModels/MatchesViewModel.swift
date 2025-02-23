import Foundation
import Combine

class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchMatches()
    }
    
    func fetchMatches() {
        guard let url = URL(string: "http://localhost:8000/api/matches") else {
            print("Invalid URL")
            return
        }
        
        // Retrieve the username (acting as the token)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("No username found in UserDefaults")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(username, forHTTPHeaderField: "Authorization")
        
        print("Sending request to \(url) with Authorization header: \(username)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching matches: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    print("No response from server")
                }
                return
            }
            
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    print("Server returned an error: \(httpResponse.statusCode)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received from server")
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decodedMatches = try JSONDecoder().decode([Match].self, from: data)
                DispatchQueue.main.async {
                    self?.matches += decodedMatches
                    print("Successfully fetched match items")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to decode match items: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func updateMatchStatus(matchId: String, newStatus: String) {
        if let index = matches.firstIndex(where: { $0.id == matchId }) {
            matches[index].status = newStatus
            fetchMatches()
        }
    }
}
