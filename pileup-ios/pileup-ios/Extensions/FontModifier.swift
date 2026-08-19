import SwiftUI

extension Font {
    /// Helper for the Montserrat custom font
    static func montserrat(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        
        switch weight {
        case .medium:
            fontName = "Montserrat-Medium"
        case .semibold:
            fontName = "Montserrat-SemiBold"
        case .bold:
            fontName = "Montserrat-Bold"
        default:
            fontName = "Montserrat-Regular"
        }
        return .custom(fontName, size: size)
    }
}
