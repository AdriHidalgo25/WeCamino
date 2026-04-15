import Foundation

/// Application composition root.
///
/// `AppDependencies` keeps the feature layer independent from concrete
/// persistence implementations while still making the live app easy to wire.
struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
    let officialRouteRepository: any OfficialRouteRepository
    let userProfileRepository: any UserProfileRepository
    let friendsRepository: any FriendsRepository
    let preferencesStore: AppPreferencesStore
}

// MARK: - Live

extension AppDependencies {
    @MainActor
    static var live: AppDependencies {
        let friendsRepository = LocalFriendsRepository()
        let routeRepository = LocalOfficialRouteRepository()

        return AppDependencies(
            welcomeRepository: LocalWelcomeRepository(),
            officialRouteRepository: routeRepository,
            userProfileRepository: LocalUserProfileRepository(),
            friendsRepository: friendsRepository,
            preferencesStore: AppPreferencesStore()
        )
    }
}

#if DEBUG
// MARK: - Previews

extension AppDependencies {
    /// Stable dependency graph for SwiftUI previews.
    ///
    /// A dedicated suite keeps preview state separate from the simulator state
    /// used during manual QA.
    @MainActor
    static var preview: AppDependencies {
        let userDefaults = UserDefaults(suiteName: "WeCamino.preview.dependencies") ?? .standard
        let friendsRepository = LocalFriendsRepository(userDefaults: userDefaults)
        let routeRepository = LocalOfficialRouteRepository()

        return AppDependencies(
            welcomeRepository: LocalWelcomeRepository(),
            officialRouteRepository: routeRepository,
            userProfileRepository: LocalUserProfileRepository(userDefaults: userDefaults),
            friendsRepository: friendsRepository,
            preferencesStore: AppPreferencesStore(userDefaults: userDefaults)
        )
    }
}
#endif
