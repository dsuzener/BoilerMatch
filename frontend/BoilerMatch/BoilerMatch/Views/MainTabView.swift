//
//  MainTabView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "person.3.fill")
                }
            
            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
            
//            StoreView()
//                .tabItem {
//                    Label("Store", systemImage: "cart.fill")
//                }
        }
        .accentColor(AppColors.boilermakerGold) // Purdue-themed accent color
    }
}

#Preview {
    MainTabView()
}
