//
//  PublicProfileView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct PublicProfileView: View {
    let images = ["profileImage", "image1", "image2", "image3", "image4"] // Replace with dynamic image array
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                Image(image) // Replace with dynamic image loading logic
                    .resizable()
                    .scaledToFit()
            }
        }
        .tabViewStyle(PageTabViewStyle()) // Swipeable carousel
        .navigationTitle("Public Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PublicProfileView()
    }
}
