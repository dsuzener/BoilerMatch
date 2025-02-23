import SwiftUI

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
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
                        ForEach(viewModel.matches) { match in
                            MatchCard(match: match)
                        }
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                viewModel.fetchMatches() // Fetch matches when the view appears
            }
//            .navigationTitle("Matches")
//            .navigationBarTitleDisplayMode(.inline)
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
                Text(match.id)
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
//            if let unreadCount = Int(match.unread), unreadCount > 0 {
//                Text("\(unreadCount)")
//                    .font(.caption2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(6)
//                    .background(Color.red)
//                    .clipShape(Circle())
//                    .offset(x: -10, y: 10) // Position badge at the top-right corner
//            }
        }
        // Add subtle animation on tap
        .scaleEffect(1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                print("Tapped on \(match.id)")
            }
        }
    }
}

#Preview {
    MatchesView()
}
