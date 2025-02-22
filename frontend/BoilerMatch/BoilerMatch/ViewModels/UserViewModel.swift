import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(email: String, password: String) {
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if email == "test@example.com" && password == "password" {
                self.currentUser = User(id: "1", email: email, name: "Test User", createdAt: Date())
                self.isAuthenticated = true
            } else {
                self.errorMessage = "Invalid credentials"
            }
        }
    }
    
    func register(email: String, name: String, password: String) {
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(id: UUID().uuidString, email: email, name: name, createdAt: Date())
            self.isAuthenticated = true
        }
    }
    
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
    }
}
