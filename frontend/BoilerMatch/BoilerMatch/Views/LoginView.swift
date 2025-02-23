import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
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
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .autocapitalization(.none)
                
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
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.boilermakerGold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8) // Use RoundedRectangle for the background
                                .fill(Color.white) // Fill it with white color
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8) // Ensure overlay matches the background's shape
                                .stroke(AppColors.boilermakerGold, lineWidth: 2)
                        )
                        .shadow(radius: 1)
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
