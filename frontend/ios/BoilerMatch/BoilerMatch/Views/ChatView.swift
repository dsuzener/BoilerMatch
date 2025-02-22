//
//  ChatView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/21/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [String] = ["Hi there!", "Hello! How are you?"]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            Text(message)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if !messageText.isEmpty {
                        messages.append(messageText)
                        messageText = ""
                    }
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
}

#Preview {
    ChatView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
