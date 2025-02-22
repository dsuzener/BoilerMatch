//
//  ProfileView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/21/25.
//

import SwiftUI

struct ProfileView: View {
    // User Data
    var userName: String
    var userBio: String
    var major: String
    var graduationYear: String
    var interests: [String]
    var campusInvolvement: [String]
    var socialMediaLinks: [String]
    
    // UI Constants
    private let goldColor = Color(red: 206/255, green: 184/255, blue: 136/255)
    private let blackColor = Color.black
    private let columnGrid = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Profile Header
                ZStack(alignment: .bottomTrailing) {
                    Image("purdue-background") // Add your own asset
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, blackColor.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(goldColor, lineWidth: 2))
                            
                            VStack(alignment: .leading) {
                                Text(userName)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Text(major)
                                        .font(.subheadline)
                                        .foregroundColor(goldColor)
                                    
                                    Text("•")
                                        .foregroundColor(goldColor)
                                    
                                    Text(graduationYear)
                                        .font(.subheadline)
                                        .foregroundColor(goldColor)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .offset(y: 40)
                }
                
                // Main Content
                VStack(spacing: 20) {
                    // Bio Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Boiler Bio")
                            .font(.headline)
                            .foregroundColor(blackColor)
                        
                        Text(userBio)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(goldColor.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Interests Grid
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shared Interests")
                            .font(.headline)
                            .foregroundColor(blackColor)
                        
                        LazyVGrid(columns: columnGrid, spacing: 8) {
                            ForEach(interests, id: \.self) { interest in
                                Text(interest)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(goldColor.opacity(0.2))
                                    .cornerRadius(20)
                                    .font(.caption)
                                    .foregroundColor(blackColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Campus Involvement
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Campus Life")
                            .font(.headline)
                            .foregroundColor(blackColor)
                        
                        ForEach(campusInvolvement, id: \.self) { activity in
                            HStack {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(goldColor)
                                Text(activity)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(goldColor.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Social Links
                HStack(spacing: 20) {
                    ForEach(socialMediaLinks, id: \.self) { link in
                        Button {
                            // Handle social media action
                        } label: {
                            Image(systemName: link.lowercased() == "instagram" ? "camera.fill" : "link")
                                .font(.title2)
                                .foregroundColor(goldColor)
                                .padding(10)
                                .background(Circle().stroke(goldColor))
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle("Boiler Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Settings action
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(goldColor)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            userName: "BoilerEngineer24",
            userBio: "ME Major | Ross-Ade Stadium Regular | Coffee enthusiast looking for study buddies and game day partners!",
            major: "Mechanical Engineering",
            graduationYear: "2026",
            interests: ["Robotics Club", "Coffee Culture", "Football Games", "Hiking Trails", "Sustainable Energy", "3D Printing"],
            campusInvolvement: ["Purdue Engineering Student Council", "IEEE Member", "Intramural Basketball"],
            socialMediaLinks: ["Instagram", "LinkedIn"]
        )
    }
}
