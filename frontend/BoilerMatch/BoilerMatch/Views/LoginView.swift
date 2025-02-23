import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false // Persistent login state
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("BoilerMatch")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.boilermakerGold)
                .shadow(radius: 2)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
            
//            Button(action: logIn) {
//                Text("Log In")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(AppColors.boilermakerGold)
//                    .cornerRadius(8)
//                    .shadow(radius: 1)
//            }
            
            Button(action: logIn) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.boilermakerGold)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                } else {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.boilermakerGold)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                }
            }
            .disabled(isLoading)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 175)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    func logIn() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        loginUser(username: username, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    isLoggedIn = true
                } else {
                    errorMessage = error ?? "Login failed"
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

