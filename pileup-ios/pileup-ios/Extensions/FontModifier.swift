import SwiftUI

extension Font {
    /// Helper for the Montserrat custom font with Dynamic Type support.
    /// Automatically scales with the text size configured in iOS Settings (Dynamic Type).
    static func montserrat(size: CGFloat, weight: Font.Weight = .regular, relativeTo: Font.TextStyle? = nil) -> Font {
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
        
        let textStyle: Font.TextStyle
        if let relativeTo = relativeTo {
            textStyle = relativeTo
        } else {
            // Automatic mapping to standard iOS Dynamic Type scale
            switch size {
            case 34...: textStyle = .largeTitle
            case 28..<34: textStyle = .title
            case 22..<28: textStyle = .title2
            case 20..<22: textStyle = .title3
            case 17..<20: textStyle = .headline
            case 15..<17: textStyle = .body
            case 13..<15: textStyle = .subheadline
            case 11..<13: textStyle = .footnote
            default: textStyle = .caption2
            }
        }
        
        return .custom(fontName, size: size, relativeTo: textStyle)
    }
}
