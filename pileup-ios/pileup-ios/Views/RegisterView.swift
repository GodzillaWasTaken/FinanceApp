import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var inviteCode = ""
    
    @State private var recoveryKey: String? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let key = recoveryKey {
                    // Registration Success State
                    Text("Registrazione Completata!")
                        .font(.montserrat(size: 24, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    Text("Questa è la tua Recovery Key. Salvala in un posto sicuro. Se perdi la password e questa chiave, perderai tutti i tuoi dati E2E.")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(key)
                        .font(.system(size: 16, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .textSelection(.enabled)
                        .padding(.horizontal)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Ho salvato la chiave, vai al Login")
                            .font(.montserrat(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                } else {
                    // Registration Form State
                    Text("Registrati")
                        .font(.montserrat(size: 34, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                        
                        SecureField("Password (questa cifrerà i dati)", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        if viewModel.globalSettings?.is_initialized == true {
                            TextField("Codice d'Invito", text: $inviteCode)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .autocapitalization(.none)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.montserrat(size: 13))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        viewModel.register(username: username, email: email, password: password, inviteCode: inviteCode) { generatedRecoveryKey in
                            if let key = generatedRecoveryKey {
                                self.recoveryKey = key
                            }
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Registrati")
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
                    .disabled(viewModel.isLoading || username.isEmpty || email.isEmpty || password.isEmpty || (viewModel.globalSettings?.is_initialized == true && inviteCode.isEmpty))
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
