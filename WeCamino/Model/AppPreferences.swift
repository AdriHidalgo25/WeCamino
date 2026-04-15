import Foundation
import SwiftUI

/// Supported app languages, including a device-driven system option.
enum AppLanguage: String, CaseIterable, Codable, Sendable {
    case system
    case english
    case spanish
    case french

    // MARK: - Resolution

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

    // MARK: - Locale

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

/// Supported appearance modes for the app shell.
enum AppAppearance: String, CaseIterable, Codable, Sendable {
    case system
    case light
    case dark

    // MARK: - SwiftUI

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
