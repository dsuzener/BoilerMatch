import Foundation
import Combine

class FeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var remainingViews = 15
    
    private var currentPage = 0
    private let pageSize = 30
    private var lastResetTime: Date = Date()
    
    init() {
        loadInitialContent()
        setupResetTimer()
    }
    
    func loadInitialContent() {
        fetchFeedItems() // Fetch initial feed items from the server
    }
    
    func loadMoreContentIfNeeded(currentItem: FeedItem) {
        guard let index = feedItems.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let threshold = feedItems.count - 5
        if index == threshold {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        fetchFeedItems() // Fetch more feed items (pagination can be added if needed)
    }
    
    func navigateToProfile(_ item: FeedItem) {
        if remainingViews > 0 {
            remainingViews -= 1
            // Implement navigation to user's public profile here
        }
    }
    
    private func setupResetTimer() {
        Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { [weak self] _ in
            self?.checkAndResetViews()
        }
    }
    
    private func checkAndResetViews() {
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastResetTime) >= 12 * 60 * 60 {
            remainingViews = 15
            lastResetTime = currentTime
        }
    }
    
    private func fetchFeedItems() {
        guard let url = URL(string: "http://localhost:8000/api/feed") else {
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
                    print("Error fetching feed items: \(error.localizedDescription)")
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
                let decodedItems = try JSONDecoder().decode([FeedItem].self, from: data)
                DispatchQueue.main.async {
                    self?.feedItems += decodedItems
                    print("Successfully fetched feed items")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to decode feed items: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
