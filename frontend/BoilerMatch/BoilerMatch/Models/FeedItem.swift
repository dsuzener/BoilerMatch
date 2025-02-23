import Foundation

struct FeedItem: Identifiable, Decodable {
    let id = UUID() // Generate a unique ID for each item
    let name: String
    let age: Int
    let imageName: String

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case age
        case profilePictures = "profile_pictures"
    }

    // Custom initializer to handle nested or transformed data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Map full_name to name
        self.name = try container.decode(String.self, forKey: .fullName)
        
        // Map age directly
        self.age = try container.decode(Int.self, forKey: .age)
        
        // Extract the first image URL from profile_pictures
        let profilePictures = try container.decode([String].self, forKey: .profilePictures)
        self.imageName = profilePictures.first ?? "" // Use an empty string if no images are available
    }
}
