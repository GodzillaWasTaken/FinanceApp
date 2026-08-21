import Foundation

struct TokenResponse: Codable, Sendable {
    let access: String
    let refresh: String
}

struct TokenRefreshResponse: Sendable {
    let access: String
}
extension TokenRefreshResponse: Decodable {}



struct UserProfile: Codable {
    let encrypted_master_key: String?
    let recovery_encrypted_master_key: String?
}

struct GlobalSettings: Codable {
    let is_initialized: Bool
    let allow_registration: Bool
}
