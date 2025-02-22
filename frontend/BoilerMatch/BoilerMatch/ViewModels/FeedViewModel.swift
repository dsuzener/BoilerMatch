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
        // Load mock data
        feedItems = (0..<pageSize).map { index in
            FeedItem(
                name: "User \(index + 1)",
                age: Int.random(in: 18...65),
                imageName: "person\(Int.random(in: 1...4))"
            )
        }
    }
    
    func loadMoreContentIfNeeded(currentItem: FeedItem) {
        guard let index = feedItems.firstIndex(where: { $0.id == currentItem.id }) else { return }
        
        let threshold = feedItems.count - 5
        if index == threshold {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        // Simulate pagination
        let newItems = (0..<pageSize).map { index in
            FeedItem(
                name: "User \(currentPage * pageSize + index + 1)",
                age: Int.random(in: 18...65),
                imageName: "person\(Int.random(in: 1...4))"
            )
        }
        
        currentPage += 1
        feedItems += newItems
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
}
