import Foundation

struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
    let officialRouteRepository: any OfficialRouteRepository
    let userProfileRepository: any UserProfileRepository
    let preferencesStore: AppPreferencesStore
}

extension AppDependencies {
    @MainActor
    static var live: AppDependencies {
        AppDependencies(
            welcomeRepository: LocalWelcomeRepository(),
            officialRouteRepository: LocalOfficialRouteRepository(),
            userProfileRepository: LocalUserProfileRepository(),
            preferencesStore: AppPreferencesStore()
        )
    }
}
