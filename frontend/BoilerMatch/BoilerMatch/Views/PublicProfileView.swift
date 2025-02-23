//
//  PublicProfileView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct PublicProfileView: View {
    let images = ["HotChick", "HotChick", "HotChick", "HotChick"] // Placeholder images
    let profileName: String // The name of the profile being viewed
    let bio: String
    @State private var isLiked = false // Tracks if the profile is liked
    @State private var hasSentLike = false // Prevents multiple like requests

    var body: some View {
        VStack {
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image) // Placeholder logic for public profile images
                        .resizable()
                        .scaledToFit()
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .tabViewStyle(PageTabViewStyle()) // Swipeable carousel style
            
            Spacer()
            
            // Bio section
            VStack(alignment: .leading, spacing: 8) {
                Text("About \(profileName)")
                    .font(.title.bold())
                    .foregroundColor(AppColors.boilermakerGold)
                
                Text(bio)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                if !hasSentLike { // Prevent sending multiple likes
                    isLiked = true
                    hasSentLike = true
                    sendLikeRequest(receiverUsername: profileName)
                }
            }) {
                HStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? AppColors.boilermakerGold : Color.white)
                        .font(.title)
                    
                    Text(isLiked ? "Liked" : "Like")
                        .foregroundColor(isLiked ? AppColors.boilermakerGold : Color.white)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isLiked ? AppColors.coolGray : AppColors.boilermakerGold)
                .cornerRadius(10)
            }
            // Disable the button after liking
            .disabled(hasSentLike)
            .padding()
        }
//        .navigationTitle(profileName)
//        .navigationBarTitleDisplayMode(.large)
    }
    
    private func sendLikeRequest(receiverUsername: String) {
        guard let url = URL(string: "http://localhost:8000/api/like") else {
            print("Invalid URL")
            return
        }
    
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("No username found in UserDefaults")
            return
        }
        print(username)
        print(receiverUsername)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue(username, forHTTPHeaderField: "Sender")
        request.addValue(receiverUsername, forHTTPHeaderField: "Receiver")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending like request:", error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No response from server")
                return
            }
            
            print("HTTP Response Status Code:", httpResponse.statusCode)
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from server:", responseString)
            }
        }.resume()
    }
}

#Preview {
    NavigationView {
        PublicProfileView(profileName: "douglasdavis", bio: "Hello, world!") // Example profile name
    }
}
