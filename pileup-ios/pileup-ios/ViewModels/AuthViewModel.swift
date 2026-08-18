import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let _ = UserDefaults.standard.string(forKey: "authToken") {
            isAuthenticated = true
        }
    }
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        let parameters = ["username": username, "password": password]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Data encoding error"
            self.isLoading = false
            return
        }
        
        NetworkManager.shared.request(endpoint: "auth/jwt/create/", method: "POST", body: body) { (result: Result<TokenResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.access, forKey: "authToken")
                    self.isAuthenticated = true
                case .failure(let error):
                    self.errorMessage = "Invalid credentials or network error. (\(error.localizedDescription))"
                }
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        isAuthenticated = false
    }
}
