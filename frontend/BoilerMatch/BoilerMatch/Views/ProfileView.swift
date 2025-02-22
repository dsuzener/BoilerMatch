import SwiftUI

struct ProfileView: View {
    @State private var name = ""
    @State private var bio = ""
    @State private var interests: [String] = []
    @State private var newInterest = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $name)
                    TextEditor(text: $bio)
                        .frame(height: 100)
                }
                
                Section(header: Text("Interests")) {
                    ForEach(interests, id: \.self) { interest in
                        Text(interest)
                    }
                    .onDelete(perform: deleteInterest)
                    
                    HStack {
                        TextField("Add interest", text: $newInterest)
                        Button(action: addInterest) {
                            Text("Add")
                        }
                    }
                }
                
                Section {
                    Button(action: saveProfile) {
                        Text("Save Profile")
                    }
                }
            }
            .navigationTitle("My Profile")
        }
    }
    
    func addInterest() {
        if !newInterest.isEmpty {
            interests.append(newInterest)
            newInterest = ""
        }
    }
    
    func deleteInterest(at offsets: IndexSet) {
        interests.remove(atOffsets: offsets)
    }
    
    func saveProfile() {
        // Save profile logic here
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
