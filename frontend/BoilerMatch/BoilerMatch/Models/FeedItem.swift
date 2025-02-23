import Foundation

struct FeedItem: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let age: Int
    let imageName: String
    
    private enum CodingKeys: String, CodingKey {
        case name, age, imageName
    }
}
