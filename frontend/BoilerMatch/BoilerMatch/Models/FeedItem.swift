import Foundation

struct FeedItem: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let imageName: String
}
