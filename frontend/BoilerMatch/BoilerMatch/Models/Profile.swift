import Foundation

struct Profile: Codable, Identifiable {
    let id: String
    let userId: String
    let bio: String
    let interests: [String]
    let photos: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case bio
        case interests
        case photos
    }
}
