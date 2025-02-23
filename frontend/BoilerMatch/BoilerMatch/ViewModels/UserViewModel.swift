import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(email: String, password: String) {
        isLoading = true
        AuthenticationService.shared.login(email: email, password: password)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.errorDescription
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
}
