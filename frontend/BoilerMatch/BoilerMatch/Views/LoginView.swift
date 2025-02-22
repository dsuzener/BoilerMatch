import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    
    var body: some View {
        VStack {
            Text("BoilerMatch")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Picker(selection: $isLoginMode, label: Text("Login or Register")) {
                Text("Login").tag(true)
                Text("Register").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Perform login or registration
            }) {
                Text(isLoginMode ? "Login" : "Register")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
