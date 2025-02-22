import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var currentIndex: Int = 0
    
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
                            .frame(height: geometry.size.width / 2)
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentItem: item)
                            }
                    }
                }
                .padding(.horizontal, 2)
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
    }
}

struct FeedItemView: View {
    let item: FeedItem
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .onTapGesture {
                    viewModel.navigateToProfile(item)
                }
            
            HStack {
                Text(item.name)
                    .font(.callout)
                    .foregroundColor(.white)
                    .padding(.trailing, 4)
                Text("\(item.age)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding(8)
            .shadow(color: .black, radius: 1)
        }
        .contentShape(Rectangle())
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
            .padding(0)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
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
