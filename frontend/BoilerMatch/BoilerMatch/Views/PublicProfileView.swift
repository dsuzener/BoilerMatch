//
//  PublicProfileView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct PublicProfileView: View {
    let images = ["HotChick", "HotChick", "HotChick", "HotChick"] // Placeholder images
    
    var body: some View {
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
        .navigationTitle("Public Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PublicProfileView()
    }
}
