import Foundation

struct Message: Codable, Identifiable {
    let id: String
    let senderId: String
    let receiverId: String
    let content: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case timestamp
    }
}
