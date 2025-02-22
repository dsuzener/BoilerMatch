import Foundation

struct Match: Codable, Identifiable {
    let id: String
    let user1Id: String
    let user2Id: String
    let createdAt: Date
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case createdAt = "created_at"
        case status
    }
}
