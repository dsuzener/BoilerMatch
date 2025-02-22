import SwiftUI

struct MatchesView: View {
    @State private var matches: [Match] = [
        Match(id: "1", userId: "User 1", unread: "2", createdAt: Date(), status: "Matched"),
        Match(id: "2", userId: "User 2", unread: "0", createdAt: Date(), status: "Matched"),
        Match(id: "3", userId: "User 3", unread: "5", createdAt: Date(), status: "Matched"),
        Match(id: "4", userId: "User 4", unread: "0", createdAt: Date(), status: "Matched"),
        Match(id: "5", userId: "User 5", unread: "1", createdAt: Date(), status: "Matched")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Your Matches")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.boilermakerGold)
                    .padding(.top, 20)
                
                // Matches Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(matches) { match in
                            MatchCard(match: match)
                        }
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.coolGray.opacity(0.1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MatchCard: View {
    let match: Match
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                // Profile Image
                Image("HotChick") // Placeholder image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                // User Name
                Text(match.userId)
                    .font(.headline)
                    .foregroundColor(AppColors.black)
                
                // Status (Optional)
                Text(match.status)
                    .font(.subheadline)
                    .foregroundColor(AppColors.coolGray.opacity(0.7))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: AppColors.coolGray.opacity(0.5), radius: 4, x: 0, y: 2)
            
            // Unread Messages Badge
            if let unreadCount = Int(match.unread), unreadCount > 0 {
                Text("\(unreadCount)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: -10, y: 10) // Position badge at the top-right corner
            }
        }
        // Add subtle animation on tap
        .scaleEffect(1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                print("Tapped on \(match.userId)")
            }
        }
    }
}

#Preview {
    MatchesView()
}
