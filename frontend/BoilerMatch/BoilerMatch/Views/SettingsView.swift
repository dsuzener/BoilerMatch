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
        VStack(spacing: 20) {
            // Title
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer(minLength: 20)
            
            // Gender Preference Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("Show Me")
                    .font(.headline)
                
                HStack {
                    Button(action: { genderPreference = "Everyone" }) {
                        Text("Everyone")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(genderPreference == "Everyone" ? AppColors.boilermakerGold : AppColors.coolGray.opacity(0.3))
                            .foregroundColor(genderPreference == "Everyone" ? .white : AppColors.black)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { genderPreference = "Men" }) {
                        Text("Men")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(genderPreference == "Men" ? AppColors.boilermakerGold : AppColors.coolGray.opacity(0.3))
                            .foregroundColor(genderPreference == "Men" ? .white : AppColors.black)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { genderPreference = "Women" }) {
                        Text("Women")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(genderPreference == "Women" ? AppColors.boilermakerGold : AppColors.coolGray.opacity(0.3))
                            .foregroundColor(genderPreference == "Women" ? .white : AppColors.black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 20)
            
            // Age Range Slider
            VStack(alignment: .leading, spacing: 10) {
                Text("Age Range")
                    .font(.headline)
                
                Text("\(Int(minAge)) - \(Int(maxAge)) years")
                    .font(.subheadline)
                    .foregroundColor(AppColors.coolGray.opacity(0.7))
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Min Age")
                        Slider(value: $minAge, in: 18...maxAge, step: 1) // Min age slider
                            .accentColor(AppColors.boilermakerGold)
                        Text("\(Int(minAge))")
                    }
                    
                    HStack {
                        Text("Max Age")
                        Slider(value: $maxAge, in: minAge...100, step: 1) // Max age slider
                            .accentColor(AppColors.boilermakerGold)
                        Text("\(Int(maxAge))")
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 20)
            
            // Logout Button
            Button(action: logOut) {
                HStack {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundColor(.white)
                    
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.8))
                .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray.opacity(0.1), Color.white]),
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

#Preview {
    SettingsView()
}
