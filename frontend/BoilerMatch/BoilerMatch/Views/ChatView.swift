import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = [
        Message(id: "1", senderId: "1", receiverId: "2", content: "Hello!", timestamp: Date().addingTimeInterval(-3600)),
        Message(id: "2", senderId: "2", receiverId: "1", content: "Hi there!", timestamp: Date().addingTimeInterval(-3500)),
        Message(id: "3", senderId: "1", receiverId: "2", content: "How are you?", timestamp: Date().addingTimeInterval(-3400))
    ]
    
    var body: some View {
        VStack {
            // Messages List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isCurrentUser: message.senderId == "1")
                    }
                }
                .padding(.top, 10)
            }
            
            // Input Field
            HStack {
                TextField("Type a message...", text: $messageText)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.boilermakerGold, lineWidth: 1)
                    )
                
                Button(action: sendMessage) {
                    Text("Send")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(AppColors.boilermakerGold)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(AppColors.coolGray.opacity(0.1))
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Chat")
                    .font(.headline)
                    .foregroundColor(AppColors.black)
            }
        }
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
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
            HStack {
                if isCurrentUser { Spacer() }
                
                Text(message.content)
                    .padding(12)
                    .background(isCurrentUser ? AppColors.boilermakerGold : AppColors.coolGray.opacity(0.3))
                    .foregroundColor(isCurrentUser ? Color.white : AppColors.black)
                    .cornerRadius(16)
                
                if !isCurrentUser { Spacer() }
            }
            
            // Timestamp
            Text(message.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(AppColors.coolGray.opacity(0.7))
                .padding(isCurrentUser ? EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 16) : EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 0))
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}
