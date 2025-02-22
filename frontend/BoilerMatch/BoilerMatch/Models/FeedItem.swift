import Foundation

struct FeedItem: Identifiable {
    let id = UUID()
    let name: String
    let bio: String
    let imageName: String
    let interests: [String]
}
