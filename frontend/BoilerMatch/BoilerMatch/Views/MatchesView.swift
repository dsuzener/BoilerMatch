import SwiftUI

struct MatchesView: View {
    let matches = [
        Match(id: "1", user1Id: "1", user2Id: "2", createdAt: Date(), status: "pending"),
        Match(id: "2", user1Id: "1", user2Id: "3", createdAt: Date(), status: "accepted")
    ]
    
    var body: some View {
        NavigationView {
            List(matches) { match in
                NavigationLink(destination: Text("Chat with user \(match.user2Id)")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("Match \(match.id)")
                                .font(.headline)
                            Text("Status: \(match.status)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Matches")
        }
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
