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
                    gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)]),
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
        .customColorScheme($viewModel.customColorScheme)
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
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(item.age) years old")
                    .font(.subheadline)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? Color.red : Color.white)
                            .font(.title2)
                            .padding(8)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                }
            }
            .padding(12)
            .foregroundColor(.white)
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

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "eye.fill")
                    .foregroundColor(.white)

                Text("\(remainingViews) left")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        // Add subtle background for header
        .background(Color.white.opacity(0.1))
        // Add rounded corners to header background
        .cornerRadius(16)
    }
}



struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

enum CustomColorScheme: Int, CaseIterable, Identifiable, Codable {
    case system = 0
    case light = 1
    case dark = 2
    
    var id: Int { self.rawValue }
}

struct CustomColorSchemeViewModifier: ViewModifier {
    @Binding var customColorScheme: CustomColorScheme
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(customColorScheme == .system ? nil : (customColorScheme == .light ? .light : .dark))
    }
}

extension View {
    func customColorScheme(_ customColorScheme: Binding<CustomColorScheme>) -> some View {
        self.modifier(CustomColorSchemeViewModifier(customColorScheme: customColorScheme))
    }
}
