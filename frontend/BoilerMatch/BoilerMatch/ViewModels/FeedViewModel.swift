import Foundation
import Combine

class FeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var viewCount = 0
    @Published var dailyLimit = 100
    
    private var currentPage = 0
    private let pageSize = 30
    
    init() {
        loadInitialContent()
    }
    
    func loadInitialContent() {
        // Load mock data
        feedItems = (0..<pageSize).map { index in
            FeedItem(
                name: "User \(index + 1)",
                bio: ["CS Student", "Engineer", "Designer", "iOS Dev"].randomElement()!,
                imageName: "person\(Int.random(in: 1...4))",
                interests: ["Swift", "C++", "Python", "AI", "ML"].shuffled().prefix(2).map { $0 }
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
                bio: ["New User", "Recent Member", "Active Student"].randomElement()!,
                imageName: "person\(Int.random(in: 1...4))",
                interests: ["Sports", "Music", "Travel"].shuffled().prefix(2).map { $0 }
            )
        }
        
        currentPage += 1
        feedItems += newItems
    }
    
    func handleSwipeAction(_ direction: SwipeDirection, for item: FeedItem) {
        viewCount += 1
        // Implement actual match logic here
    }
    
    enum SwipeDirection {
        case like, dislike
    }
}
