import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var currentIndex: Int = 0
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(viewModel.feedItems) { item in
                        FeedItemView(item: item)
                            .frame(height: geometry.size.width / 3)
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentItem: item)
                            }
                    }
                }
                .padding(.horizontal, 2)
            }
            .overlay(
                VStack {
                    HeaderView(remainingViews: viewModel.dailyLimit - viewModel.viewCount)
                    Spacer()
                }
            )
        }
    }
}

struct FeedItemView: View {
    let item: FeedItem
    @State private var isLiked = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isLiked ? Color.blue : Color.clear, lineWidth: 2)
                )
                .onTapGesture(count: 2) {
                    handleDoubleTap()
                }
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
                
                Text(item.bio)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .shadow(color: .black, radius: 2)
            }
            .padding(8)
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button(action: { handleLike() }) {
                Label("Like", systemImage: "heart.fill")
            }
            Button(action: { handleDislike() }) {
                Label("Dislike", systemImage: "xmark.circle.fill")
            }
        }
    }
    
    private func handleDoubleTap() {
        withAnimation {
            isLiked = true
            // Send like to view model
        }
    }
    
    private func handleLike() {
        withAnimation {
            isLiked = true
            // Send like to view model
        }
    }
    
    private func handleDislike() {
        // Send dislike to view model
    }
}

struct HeaderView: View {
    let remainingViews: Int
    
    var body: some View {
        HStack {
            Text("BoilerMatch")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack {
                Image(systemName: "eye.fill")
                Text("\(remainingViews) left")
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
