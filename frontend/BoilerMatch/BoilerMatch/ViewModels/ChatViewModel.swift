import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMessages(for matchId: String) {
        // Simulating API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages = [
                Message(id: "1", senderId: "1", receiverId: "2", content: "Hello!", timestamp: Date().addingTimeInterval(-3600)),
                Message(id: "2", senderId: "2", receiverId: "1", content: "Hi there!", timestamp: Date().addingTimeInterval(-3500)),
                Message(id: "3", senderId: "1", receiverId: "2", content: "How are you?", timestamp: Date().addingTimeInterval(-3400))
            ]
        }
    }
    
    func sendMessage(content: String, senderId: String, receiverId: String) {
        let newMessage = Message(id: UUID().uuidString, senderId: senderId, receiverId: receiverId, content: content, timestamp: Date())
        messages.append(newMessage)
        
        // In a real app, you would make an API call here to send the message to the server
    }
}
