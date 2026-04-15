import Foundation

struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
    let officialRouteRepository: any OfficialRouteRepository
    let userProfileRepository: any UserProfileRepository
    let friendsRepository: any FriendsRepository
    let preferencesStore: AppPreferencesStore
}

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
