import Foundation

struct Match: Codable, Identifiable {
    let id: String
    let userId: String
    let unread: String
    let createdAt: Date
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case unread = "no"
        case createdAt = "created_at"
        case status
    }
}
