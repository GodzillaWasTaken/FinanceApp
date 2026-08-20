import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Tasto impostazioni in alto a destra, indipendente dalla Navigation Bar
                HStack {
                    Spacer()
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                }
                .padding(.trailing, 10)
                
                Spacer()
                
                // Logo or Title
                Text("PILEUP")
                    .font(.montserrat(size: 34, weight: .bold))
                    .tracking(4) // space between letters
                    .foregroundColor(.blue)
                
                Text("Login to your account")
                    .font(.montserrat(size: 15))
                    .foregroundColor(.gray)
                
                // Form Fields
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.montserrat(size: 13))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Login Button
                Button(action: {
                    viewModel.login(username: username, password: password)
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .font(.montserrat(size: 16, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(viewModel.isLoading || username.isEmpty || password.isEmpty)
                
                // Se le registrazioni sono aperte
                if viewModel.globalSettings?.allow_registration == true {
                    NavigationLink(destination: RegisterView(viewModel: viewModel)) {
                        Text("Non hai un account? Registrati")
                            .font(.montserrat(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showSettings) {
                ServerSettingsView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
}
