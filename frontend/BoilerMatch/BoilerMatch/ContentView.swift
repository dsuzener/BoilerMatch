//
//  ContentView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false // Persistent login state
    
    var body: some View {
        if isLoggedIn {
            MainTabView() // Show main app after login
        } else {
            LoginView() // Show login screen
        }
    }
}

#Preview {
    ContentView()
}
