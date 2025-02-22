import Foundation
import Combine

class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMatches(for userId: String) {
        // Simulating API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.matches = [
//                Match(id: "1", user1Id: userId, user2Id: "2", createdAt: Date(), status: "pending"),
//                Match(id: "2", user1Id: userId, user2Id: "3", createdAt: Date(), status: "accepted"),
//                Match(id: "3", user1Id: userId, user2Id: "4", createdAt: Date(), status: "rejected")
//            ]
//        }
    }
    
    func updateMatchStatus(matchId: String, newStatus: String) {
        if let index = matches.firstIndex(where: { $0.id == matchId }) {
            matches[index].status = newStatus
            // In a real app, you would make an API call here to update the status on the server
        }
    }
}
