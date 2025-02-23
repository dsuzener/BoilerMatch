import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
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
                .autocapitalization(.none)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .autocapitalization(.none)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .autocapitalization(.none)
            
            Button(action: signUp) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.boilermakerGold)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                } else {
                    Text("Sign Up")
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
            
            Button {
                dismiss()
            } label: {
                Text("Already have an account? Log In")
                    .foregroundColor(AppColors.boilermakerGold)
                    .underline()
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 100)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.coolGray, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    func signUp() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        // Add validation
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            isLoading = false
            return
        }
        
        signUpUser(username: username, email: email, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    dismiss()
                } else {
                    errorMessage = error ?? "Registration failed"
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}