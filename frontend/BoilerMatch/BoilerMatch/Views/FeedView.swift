import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var isLoading = true
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Updated background gradient
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        HeaderView(remainingViews: viewModel.remainingViews)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.feedItems) { item in
                                FeedItemView(item: item, viewModel: viewModel)
                                    .frame(height: geometry.size.width / 1.5)
                                    .redacted(reason: isLoading ? .placeholder : [])
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                                            isLoading = false
                                        }
                                        viewModel.loadMoreContentIfNeeded(currentItem: item)
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                }
            }
        }
    }
}

struct FeedItemView: View {
    let item: FeedItem
    @ObservedObject var viewModel: FeedViewModel
    @State private var isLiked = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: item.imageName)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image("HotChick")
                        .resizable()
                        .scaledToFill()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.boilermakerGold.opacity(0.5), lineWidth: 1) // Subtle gold border
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.rushGold) // Rush Gold for name
                    
                    Text("\(item.age) years old")
                        .font(.subheadline)
                        .foregroundColor(Color.white) // White for age text
                }
                
                Spacer()
                
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? AppColors.boilermakerGold : Color.white) // Gold when liked
                        .font(.title2)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.5)))
                }
            }
            .padding(12)
        }
        .onTapGesture {
            viewModel.navigateToProfile(item)
        }
    }
}

struct HeaderView: View {
    let remainingViews: Int
    
    var body: some View {
        HStack {
            Text("Discover")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.black) // Black for header text

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "eye.fill")
                    .foregroundColor(AppColors.black)

                Text("\(remainingViews) left")
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.black) // Black for remaining views indicator
            }
            .padding(8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        // Add subtle background for header
        .background(AppColors.boilermakerGold.opacity(0.2))
        // Add rounded corners to header background
        .cornerRadius(16)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
