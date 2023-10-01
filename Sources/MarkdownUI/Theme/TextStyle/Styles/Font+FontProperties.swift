import SwiftUI

extension Font {
    static func withProperties(_ fontProperties: FontProperties) -> Font {
        var font: Font
        let size = round(fontProperties.size * fontProperties.scale)
        
        switch fontProperties.family {
        case .system(let design):
            font = .system(size: size, design: design)
        case .custom(let name):
            font = .custom(name, size: size)
        }
        
        switch fontProperties.familyVariant {
        case .normal:
            break  // do nothing
        case .monospaced:
            font = font.monospaced()
        }
        
        switch fontProperties.capsVariant {
        case .normal:
            break  // do nothing
        case .smallCaps:
            font = font.smallCaps()
        case .lowercaseSmallCaps:
            font = font.lowercaseSmallCaps()
        case .uppercaseSmallCaps:
            font = font.uppercaseSmallCaps()
        }
        
        switch fontProperties.digitVariant {
        case .normal:
            break  // do nothing
        case .monospaced:
            font = font.monospacedDigit()
        }
        
        if fontProperties.weight != .regular {
            font = font.weight(fontProperties.weight)
        }
        
        switch fontProperties.style {
        case .normal:
            break  // do nothing
        case .italic:
            font = font.italic()
        }
        
        return font
    }
}

extension UIFont {
    static func withProperties(_ fontProperties: FontProperties) -> UIFont {
        var font: UIFont
        let size = round(fontProperties.size * fontProperties.scale)
        
        switch fontProperties.family {
        case .system(let design):
            font = .systemFont(ofSize: size)
        case .custom(let name):
            font = .init(name: name, size: size) ?? .systemFont(ofSize: size)
        }

        switch fontProperties.familyVariant {
        case .normal:
            break  // do nothing
        case .monospaced:
            font = .monospacedSystemFont(ofSize: size, weight: .regular)
        }

//        switch fontProperties.capsVariant {
//        case .normal:
//            break  // do nothing
//        case .smallCaps:
//            font = font.smallCaps()
//        case .lowercaseSmallCaps:
//            font = font.lowercaseSmallCaps()
//        case .uppercaseSmallCaps:
//            font = font.uppercaseSmallCaps()
//        }
//
        switch fontProperties.digitVariant {
        case .normal:
            break  // do nothing
        case .monospaced:
            font = .monospacedDigitSystemFont(ofSize: size, weight: .regular)
        }
        
        if fontProperties.weight != .regular {
            font = .systemFont(ofSize: size, weight: UIFont.getWeight(for: fontProperties.weight))
        }
        
        switch fontProperties.style {
        case .normal:
            break  // do nothing
        case .italic:
            font = .italicSystemFont(ofSize: size)
        }
        
        return font
    }
}

extension UIFont {
    
    static func getWeight(for weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case.ultraLight:
            return .ultraLight
        case.thin:
            return .thin
        case.light:
            return .light
        case.regular:
            return .regular
        case.medium:
            return .medium
        case.semibold:
            return .semibold
        case.bold:
            return .bold
        case.heavy:
            return .heavy
        case.black:
            return .black
        default:
            return .regular
        }
    }
}

//public static let ultraLight: Font.Weight
//
//public static let thin: Font.Weight
//
//public static let light: Font.Weight
//
//public static let regular: Font.Weight
//
//public static let medium: Font.Weight
//
//public static let semibold: Font.Weight
//
//public static let bold: Font.Weight
//
//public static let heavy: Font.Weight
//
//public static let black: Font.Weight

