import Foundation

struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
    let officialRouteRepository: any OfficialRouteRepository
    let preferencesStore: AppPreferencesStore
}

extension AppDependencies {
    @MainActor
    static var live: AppDependencies {
        AppDependencies(
            welcomeRepository: LocalWelcomeRepository(),
            officialRouteRepository: LocalOfficialRouteRepository(),
            preferencesStore: AppPreferencesStore()
        )
    }
}
