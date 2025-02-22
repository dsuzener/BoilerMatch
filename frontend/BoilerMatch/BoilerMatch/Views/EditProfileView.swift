import SwiftUI

struct EditProfileView: View {
    @State private var name = "John Doe" // Replace with dynamic user data
    @State private var age = "25"
    @State private var bio = "Loves hiking, coffee, and coding!"
    @State private var images = ["HotChick", "HotChick", "HotChick"] // Placeholder images
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Editable User Information Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name")
                        .font(.headline)
                    
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    
                    Text("Age")
                        .font(.headline)

                    TextField("Enter your age", text: $age)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)

                    Text("Bio")
                        .font(.headline)

                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
                
                Divider()
                
                // Image Management Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Manage Images")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(images, id: \.self) { image in
                                VStack {
                                    Image(image) // Placeholder image logic
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    Button(action: { deleteImage(imageName: image) }) {
                                        Text("Delete")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                            }

                            Button(action: addImage) {
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
                }

                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
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
