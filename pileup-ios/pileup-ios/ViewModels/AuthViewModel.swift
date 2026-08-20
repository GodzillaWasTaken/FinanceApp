import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var needsUnlock: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var userProfile: UserProfile? = nil
    @Published var masterKey: String? = nil
    @Published var globalSettings: GlobalSettings? = nil
    
    init() {
        checkAuthStatus()
        fetchGlobalSettings()
    }
    
    func checkAuthStatus() {
        if let _ = UserDefaults.standard.string(forKey: "authToken") {
            // Token is present, we need to unlock the master key
            needsUnlock = true
        }
    }
    
    // Fetches global settings from the API to check if the register feature with invite code is enabled
    func fetchGlobalSettings() {
        NetworkManager.shared.request(endpoint: "settings/", method: "GET") { [weak self] (result: Result<GlobalSettings, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let settings):
                    self.globalSettings = settings
                case .failure(let error):
                    print("Error fetching settings: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Called by UnlockView when Face ID button is clicked
    func unlockWithBiometrics() {
        if let key = KeychainManager.shared.getMasterKey() {
            DispatchQueue.main.async {
                self.masterKey = key
                self.isAuthenticated = true
                self.needsUnlock = false
                self.errorMessage = nil
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Face ID non riuscito o annullato. Inserisci la password."
            }
        }
    }
    
    // Called by UnlockView when user manually enters password
    func unlockWithPassword(_ password: String) {
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        fetchProfileAndDeriveKey(password: password, username: username)
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
        
        NetworkManager.shared.request(endpoint: "auth/jwt/create/", method: "POST", body: body) { [weak self] (result: Result<TokenResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.access, forKey: "authToken")
                    UserDefaults.standard.set(username, forKey: "username") // Save username right after successful login
                    self.fetchProfileAndDeriveKey(password: password, username: username)
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Invalid credentials or network error. (\(error.localizedDescription))"
                }
            }
        }
    }
    
    private func fetchProfileAndDeriveKey(password: String, username: String) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.request(endpoint: "auth/profile/", method: "GET") { [weak self] (result: Result<UserProfile, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                    
                    if let encryptedMasterKey = profile.encrypted_master_key, !encryptedMasterKey.isEmpty {
                        // Rileva se è la vecchia versione
                        let isLegacy = encryptedMasterKey.hasPrefix("U2FsdGVkX1")
                        
                        // Derive KEK (210k per V2, 100k per V1)
                        let kek = CryptoHelper.deriveKeyEncryptionKey(password: password, salt: username, isLegacyV1: isLegacy)
                        
                        // Decrypt Master Key
                        if let decryptedKey = CryptoHelper.decryptData(encryptedMasterKey, key: kek) {
                            self.masterKey = decryptedKey
                            // Save to Keychain for future Face ID unlocks
                            _ = KeychainManager.shared.saveMasterKey(decryptedKey)
                            
                            self.isAuthenticated = true
                            self.needsUnlock = false
                        } else {
                            self.errorMessage = "Password non valida per la decrittografia E2E."
                        }
                    } else {
                        // Registration hasn't set an E2E key yet, or older account.
                        // Ideally shouldn't happen with new flow.
                        self.isAuthenticated = true
                        self.needsUnlock = false
                    }
                    
                case .failure(let error):
                    self.errorMessage = "Errore durante il recupero del profilo: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func register(username: String, email: String, password: String, inviteCode: String?, completion: @escaping (String?) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // 1. Genera chiavi E2E
        let newMasterKey = CryptoHelper.generateMasterKey()
        let kek = CryptoHelper.deriveKeyEncryptionKey(password: password, salt: username)
        guard let encryptedMasterKey = CryptoHelper.encryptData(newMasterKey, key: kek) else {
            self.errorMessage = "Errore nella generazione delle chiavi crittografiche."
            self.isLoading = false
            return
        }
        
        var parameters: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "encrypted_master_key": encryptedMasterKey
        ]
        
        if let invite = inviteCode, !invite.isEmpty {
            parameters["invite_code"] = invite
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.errorMessage = "Data encoding error"
            self.isLoading = false
            return
        }
        
        NetworkManager.shared.request(endpoint: "auth/register/", method: "POST", body: body) { [weak self] (result: Result<UserProfile, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(_):
                    // Registration successful, login automatically or just return the recovery key?
                    // Actually frontend generates recovery key too!
                    // I will just return the newMasterKey as the "Recovery Key" for them to save.
                    completion(newMasterKey)
                case .failure(let error):
                    self.errorMessage = "Errore durante la registrazione. L'username potrebbe essere già in uso. (\(error.localizedDescription))"
                    completion(nil)
                }
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        _ = KeychainManager.shared.deleteMasterKey()
        isAuthenticated = false
        needsUnlock = false
        masterKey = nil
        userProfile = nil
    }
}
