import Foundation
import Security
import LocalAuthentication

class KeychainManager {
    static let shared = KeychainManager()
    private let account = "E2E_MasterKey"
    
    func saveMasterKey(_ key: String) -> Bool {
        guard let data = key.data(using: .utf8) else { return false }
        
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .biometryAny, // Requires Face ID / Touch ID
            nil
        )
        
        guard let access = accessControl else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessControl as String: access
        ]
        
        // Delete any existing key first
        _ = deleteMasterKey()
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getMasterKey() -> String? {
        let context = LAContext()
        context.localizedReason = "Autenticati per sbloccare la tua chiave di crittografia."
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    func deleteMasterKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
