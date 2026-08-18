import Foundation

struct TokenResponse: Codable {
    let access: String
    let refresh: String
}

struct UserProfile: Codable {
    let id: Int
    let username: String
    let email: String
    // Add other fields as necessary from the backend
}

struct GlobalSettings: Codable {
    let is_initialized: Bool
    // Add other fields based on the API response
}
