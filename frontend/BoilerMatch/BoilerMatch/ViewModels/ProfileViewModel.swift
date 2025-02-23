import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProfile(for userId: String) {
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.profile = Profile(id: "1", userId: userId, bio: "I love coding!", interests: ["Swift", "iOS", "SwiftUI"], photos: ["photo1.jpg", "photo2.jpg"])
        }
    }
    
    func updateProfile(bio: String, interests: [String]) {
        guard let userId = profile?.userId else { return }
        
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.profile = Profile(id: self.profile?.id ?? "1", userId: userId, bio: bio, interests: interests, photos: self.profile?.photos ?? [])
        }
    }
}
