//
//  EditProfileView.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/22/25.
//

import SwiftUI

struct EditProfileView: View {
    @State private var name = "John Doe" // Replace with dynamic user data
    @State private var age = "25"
    @State private var bio = "Loves hiking, coffee, and coding!"
    @State private var images = ["profileImage", "image1", "image2"] // Replace with dynamic image array
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Editable User Information
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $bio)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5))
                    )
                
                Divider()
                
                // Image Management Section
                Text("Manage Images")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(images, id: \.self) { image in
                            VStack {
                                Image(image) // Replace with dynamic image loading logic
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Button(action: {
                                    deleteImage(imageName: image) // Add delete logic here
                                }) {
                                    Text("Delete")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Button(action: addImage) { // Add upload logic here
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(AppColors.boilermakerGold)

                                Text("Add Image")
                                    .font(.caption)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    func deleteImage(imageName: String) {
        images.removeAll { $0 == imageName } // Simple delete logic (replace with real implementation).
    }

    func addImage() {
        print("Add new image") // Add upload logic here.
    }
}

#Preview {
    NavigationView {
        EditProfileView()
    }
}
