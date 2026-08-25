import SwiftUI

/// Shared App Theme matching the frontend UI palette.
struct AppTheme {
    struct Colors {
        static let primary = Color(hex: "#6366f1")
        static let primaryLight = Color(hex: "#818cf8")
        static let primaryHover = Color(hex: "#4f46e5")
        
        static let accent = Color(hex: "#8b5cf6")
        static let accentClear = Color(hex: "#8b5cf6").opacity(0.1)
        static let accentHover = Color(hex: "#7c3aed")
        
        static let text = Color(hex: "#1f2937")
        static let textLight = Color(hex: "#6b7280")
        
        static let background = Color(hex: "#f9fafb")
        static let cardBackground = Color(hex: "#ffffff")
        
        static let success = Color(hex: "#10b981")
        static let negative = Color(hex: "#ef4444")
        static let nett = Color(hex: "#3b82f6")
        
        static let neutral = Color(hex: "#9ca3af")
        static let menuBorder = Color(hex: "#e5e7eb")
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
