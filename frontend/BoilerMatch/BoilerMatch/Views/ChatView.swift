import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = [
        Message(id: "1", senderId: "1", receiverId: "2", content: "Heyy ;)", timestamp: Date().addingTimeInterval(-3600)),
        Message(id: "2", senderId: "2", receiverId: "1", content: "Hello there.", timestamp: Date().addingTimeInterval(-3500)),
        Message(id: "3", senderId: "1", receiverId: "2", content: "General Kenobi.", timestamp: Date().addingTimeInterval(-3400))
    ]
    
    var body: some View {
        VStack {
            // Scrollable Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            MessageBubble(message: message, isCurrentUser: message.senderId == "1")
                                .id(message.id) // Assign ID for autoscroll
                        }
                    }
                    .padding(.top, 10)
                }
                .onChange(of: messages, initial: true) { _, _ in
                    // Autoscroll to latest message when messages change
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
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
        // Custom Navigation Bar
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("User Name") // Replace with dynamic user name
                        .font(.title)
                        .foregroundColor(AppColors.black)

                    Spacer()
                    
                    Button(action: {
                        // Action to close chat
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColors.black)
                            .padding(8)
                            .background(AppColors.mediumBeige.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 8)
                }
                .padding(.bottom, 8)
            }
        }
        // Set consistent navigation bar background and text color
        .toolbarBackground(AppColors.coolGray.opacity(0.8), for: .navigationBar) // Set background color
        .toolbarBackground(.visible, for: .navigationBar)           // Ensure background is always visible
        .toolbarColorScheme(.dark, for: .navigationBar)             // Set dark mode for text/icons
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
            HStack(alignment: .bottom) {
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
        // Add padding to prevent flush edges
        .padding(isCurrentUser ? EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 10) : EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 50))
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}
