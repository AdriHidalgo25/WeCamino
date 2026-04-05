import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class AppPreferencesStore {
    private enum StorageKey {
        static let language = "app.preferences.language"
        static let appearance = "app.preferences.appearance"
    }

    private let userDefaults: UserDefaults

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

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        language = AppLanguage(rawValue: userDefaults.string(forKey: StorageKey.language) ?? "") ?? .system
        appearance = AppAppearance(rawValue: userDefaults.string(forKey: StorageKey.appearance) ?? "") ?? .system
    }

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
