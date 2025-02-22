import SwiftUI

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var showPublicProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // User's Primary Profile Image
            Image("HotChick") // Placeholder image
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
                .foregroundColor(AppColors.coolGray.opacity(0.7))
            
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
                        .shadow(color: AppColors.boilermakerGold.opacity(0.5), radius: 4, x: 0, y: 2)
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
                        .shadow(color: AppColors.coolGray.opacity(0.5), radius: 4, x: 0, y: 2)
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
                        .shadow(color: Color.red.opacity(0.5), radius: 4, x: 0, y: 2)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView() // Navigate to Settings screen
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("Your Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
