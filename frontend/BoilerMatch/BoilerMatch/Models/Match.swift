import Foundation

struct Match: Identifiable, Decodable {
    let id: String
    let username: String
    let fullName: String
    let age: Int
    let profilePicture: String
    var status: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case fullName = "full_name"
        case age
        case profilePictures = "profile_pictures"
        case accountStatus = "account_status" // New key for account status
    }

    // Custom initializer to handle nested or transformed data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Map user_id to id
        self.id = try container.decode(String.self, forKey: .userId)

        // Map other fields directly
        self.username = try container.decode(String.self, forKey: .username)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.age = try container.decode(Int.self, forKey: .age)

        // Extract the first profile picture (or use a placeholder if none exist)
        let profilePictures = try container.decode([String].self, forKey: .profilePictures)
        self.profilePicture = profilePictures.first ?? "https://via.placeholder.com/150"

        // Map account_status to status
        self.status = try container.decode(String.self, forKey: .accountStatus)
    }
}
