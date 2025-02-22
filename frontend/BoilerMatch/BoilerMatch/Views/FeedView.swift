import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var currentIndex: Int = 0
    @State private var isLoading = true
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(viewModel.feedItems) { item in
                        FeedItemView(item: item, viewModel: viewModel)
                            .frame(width: geometry.size.width / 2,
                                   height: geometry.size.width / 1.5)
                            .redacted(reason: isLoading ? .placeholder : [])
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                        isLoading = false
                                    }
                                viewModel.loadMoreContentIfNeeded(currentItem: item)
                            }
                    }
                }
//                .padding(.horizontal, 2)
                .padding(.top, 32)
            }
            .overlay(
                VStack {
                    HeaderView(remainingViews: viewModel.remainingViews)
                    Spacer()
                }
            )
        }
        .customColorScheme($viewModel.customColorScheme)
//        .background(.black)
    }
}

struct FeedItemView: View {
    let item: FeedItem
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: item.imageName)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                case .failure:
                    Image("HotChick")
                        .resizable()
                        .scaledToFill()
//                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.top, 16)
            .overlay(
                HStack {
                    Spacer()
                    Text(item.name)
                        .font(.callout)
                        .padding(.trailing, 4)
                        .foregroundColor(.black)
                    Text("\(item.age)")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 32)
                .padding(.horizontal, 4)
                .shadow(color: .black, radius: 1)
                .background(.white.opacity(0.15))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .shadow(color: .white, radius: 4),
                alignment: .bottomTrailing
            )
            .onTapGesture {
                viewModel.navigateToProfile(item)
            }
            .contentShape(Rectangle())
        }
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct HeaderView: View {
    let remainingViews: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Image(systemName: "eye.fill")
                Text("\(remainingViews) left")
            }
            .padding(2)
            .background(AppColors.mediumBeige)
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background(AppColors.lightBeige)
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
