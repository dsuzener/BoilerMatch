import SwiftUI

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var showPublicProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Hero Section
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.boilermakerGold.opacity(0.2), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 10) {
                    // User's Primary Profile Image
                    Image("HotChick") // Placeholder image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
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
                }
            }
            
            Spacer(minLength: 20)
            
            // Action Buttons
            VStack(spacing: 16) {
                ProfileActionButton(
                    title: "Edit Profile",
                    iconName: "pencil.circle.fill",
                    backgroundColor: AppColors.boilermakerGold,
                    action: { showEditProfile = true }
                )
                .sheet(isPresented: $showEditProfile) {
                    EditProfileView() // Navigate to Edit Profile screen
                }
                
                ProfileActionButton(
                    title: "View Public Profile",
                    iconName: "eye.circle.fill",
                    backgroundColor: AppColors.coolGray.opacity(0.3),
                    action: { showPublicProfile = true }
                )
                .sheet(isPresented: $showPublicProfile) {
                    PublicProfileView() // Navigate to Public Profile screen
                }
                
                ProfileActionButton(
                    title: "Settings",
                    iconName: "gearshape.fill",
                    backgroundColor: Color.red.opacity(0.8),
                    action: { showSettings = true }
                )
                .sheet(isPresented: $showSettings) {
                    SettingsView() // Navigate to Settings screen
                }
            }
            
            Spacer()
        }
        .padding()
//        .background(Color.white.edgesIgnoringSafeArea(.all))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("Your Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable Button Component for Actions
struct ProfileActionButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: backgroundColor.opacity(0.5), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
