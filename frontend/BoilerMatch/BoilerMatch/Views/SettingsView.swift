//
//  SettingsView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false // Persistent login state
    @State private var genderPreference = "Everyone" // Default gender preference
    @State private var minAge: Double = 18 // Minimum age for range slider
    @State private var maxAge: Double = 30 // Maximum age for range slider
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.boilermakerGold)
                .padding(.top, 20)
            
            Spacer(minLength: 10)
            
            // Gender Preference Picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Show Me")
                    .font(.headline)
                    .foregroundColor(AppColors.black)
                
                HStack(spacing: 10) {
                    GenderPreferenceButton(label: "Everyone", selected: $genderPreference, value: "Everyone")
                    GenderPreferenceButton(label: "Men", selected: $genderPreference, value: "Men")
                    GenderPreferenceButton(label: "Women", selected: $genderPreference, value: "Women")
                }
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 10)
            
            // Age Range Slider
            VStack(alignment: .leading, spacing: 15) {
                Text("Age Range")
                    .font(.headline)
                    .foregroundColor(AppColors.black)
                
                Text("\(Int(minAge)) - \(Int(maxAge)) years")
                    .font(.subheadline)
                    .foregroundColor(AppColors.coolGray.opacity(0.7))
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Min Age")
                            .font(.subheadline)
                            .foregroundColor(AppColors.black)
                        Slider(
                            value: $minAge,
                            in: 18...max(maxAge - 1, 19), // Prevent overlap with maxAge
                            step: 1
                        )
                        .accentColor(AppColors.boilermakerGold)
                        Text("\(Int(minAge))")
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.boilermakerGold)
                    }
                    
                    HStack {
                        Text("Max Age")
                            .font(.subheadline)
                            .foregroundColor(AppColors.black)
                        Slider(
                            value: $maxAge,
                            in: min(minAge + 1, 99)...100, // Prevent overlap with minAge
                            step: 1
                        )
                        .accentColor(AppColors.boilermakerGold)
                        Text("\(Int(maxAge))")
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.boilermakerGold)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 10)
            
            // Logout Button
            Button(action: logOut) {
                HStack {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .cornerRadius(12)
                .shadow(color: Color.red.opacity(0.5), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    func logOut() {
        isLoggedIn = false // Reset login state
    }
}

// Custom Button for Gender Preferences
struct GenderPreferenceButton: View {
    let label: String
    @Binding var selected: String
    let value: String
    
    var body: some View {
        Button(action: { selected = value }) {
            Text(label)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selected == value ? AppColors.boilermakerGold : AppColors.coolGray.opacity(0.3))
                .foregroundColor(selected == value ? Color.white : AppColors.black)
                .cornerRadius(8)
                .shadow(color: selected == value ? AppColors.boilermakerGold.opacity(0.5) : Color.clear, radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView()
}
