import SwiftUI

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var showPublicProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // User's Primary Profile Image
            Image("profileImage") // Replace with dynamic user image
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            // User Information
            Text("John Doe") // Replace with dynamic user name
                .font(.title)
                .fontWeight(.bold)
            
            Text("Age: 25") // Replace with dynamic user age
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Loves hiking, coffee, and coding!") // Replace with dynamic bio
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    showEditProfile = true
                }) {
                    Text("Edit Profile")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.boilermakerGold)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showEditProfile) {
                    EditProfileView() // Navigate to Edit Profile screen
                }
                
                Button(action: {
                    showPublicProfile = true
                }) {
                    Text("View Public Profile")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.coolGray.opacity(0.3))
                        .foregroundColor(AppColors.black)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showPublicProfile) {
                    PublicProfileView() // Navigate to Public Profile screen
                }
                
                Button(action: {
                    showSettings = true
                }) {
                    Text("Settings")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView() // Navigate to Settings screen
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Your Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
