import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Codable, Sendable {
    case system
    case english
    case spanish
    case french

    static func resolved(from locale: Locale) -> AppLanguage {
        let identifier = locale.language.languageCode?.identifier ?? locale.identifier

        if identifier.hasPrefix("es") {
            return .spanish
        }

        if identifier.hasPrefix("fr") {
            return .french
        }

        return .english
    }

    var locale: Locale {
        switch self {
        case .system:
            .autoupdatingCurrent
        case .english:
            Locale(identifier: "en")
        case .spanish:
            Locale(identifier: "es")
        case .french:
            Locale(identifier: "fr")
        }
    }
}

enum AppAppearance: String, CaseIterable, Codable, Sendable {
    case system
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
