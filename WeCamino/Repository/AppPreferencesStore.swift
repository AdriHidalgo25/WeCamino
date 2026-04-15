import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
/// Persists language and appearance choices and exposes resolved UI settings.
final class AppPreferencesStore {
    private enum StorageKey {
        static let language = "app.preferences.language"
        static let appearance = "app.preferences.appearance"
    }

    private let userDefaults: UserDefaults

    // MARK: - Stored Preferences

    var language: AppLanguage {
        didSet {
            userDefaults.set(language.rawValue, forKey: StorageKey.language)
        }
    }

    var appearance: AppAppearance {
        didSet {
            userDefaults.set(appearance.rawValue, forKey: StorageKey.appearance)
        }
    }

    // MARK: - Initialization

    /// Creates the preferences store.
    /// - Parameter userDefaults: Store used to persist language and appearance choices.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        language = AppLanguage(rawValue: userDefaults.string(forKey: StorageKey.language) ?? "") ?? .system
        appearance = AppAppearance(rawValue: userDefaults.string(forKey: StorageKey.appearance) ?? "") ?? .system
    }

    // MARK: - Resolved Values

    var locale: Locale {
        language.locale
    }

    var resolvedLanguage: AppLanguage {
        switch language {
        case .system:
            AppLanguage.resolved(from: .autoupdatingCurrent)
        case .english, .spanish, .french:
            language
        }
    }

    var colorScheme: ColorScheme? {
        appearance.colorScheme
    }

    var strings: AppStrings {
        AppStrings.make(for: resolvedLanguage)
    }
}
