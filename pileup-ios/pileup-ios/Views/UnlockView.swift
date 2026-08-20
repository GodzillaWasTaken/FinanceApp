import SwiftUI
import LocalAuthentication

struct UnlockView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var password = ""
    
    @State private var isFaceIDAvailable = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                let username = UserDefaults.standard.string(forKey: "username") ?? "Utente"
                Text("Ciao, \(username)!")
                    .font(.montserrat(size: 28, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("Sblocca per accedere ai tuoi dati")
                    .font(.montserrat(size: 15))
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 20)
                
                if isFaceIDAvailable {
                    Button(action: {
                        viewModel.unlockWithBiometrics()
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            Text("Sblocca con Face ID")
                                .font(.montserrat(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    Spacer().frame(height: 20)
                    
                    Text("Oppure usa la password")
                        .font(.montserrat(size: 12))
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                }
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.montserrat(size: 13))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    viewModel.unlockWithPassword(password)
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sblocca")
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
                .disabled(viewModel.isLoading || password.isEmpty)
                
                Spacer()
                
                Button(action: {
                    viewModel.logout()
                }) {
                    Text("Esci e usa un altro account")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .onAppear {
                checkBiometrics()
            }
        }
    }
    
    func checkBiometrics() {
        let context = LAContext()
        var error: NSError?
        isFaceIDAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let err = error {
            print("Biometrics check failed: \(err.localizedDescription)")
        } else {
            print("Biometrics available: \(isFaceIDAvailable)")
        }
    }
}
