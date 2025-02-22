import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = [
        Message(id: "1", senderId: "1", receiverId: "2", content: "Hello!", timestamp: Date()),
        Message(id: "2", senderId: "2", receiverId: "1", content: "Hi there!", timestamp: Date())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    MessageBubble(message: message, isCurrentUser: message.senderId == "1")
                }
            }
            
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
    
    func sendMessage() {
        if !messageText.isEmpty {
            let newMessage = Message(id: UUID().uuidString, senderId: "1", receiverId: "2", content: messageText, timestamp: Date())
            messages.append(newMessage)
            messageText = ""
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            Text(message.content)
                .padding(10)
                .background(isCurrentUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}
