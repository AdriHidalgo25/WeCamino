import Foundation
import Observation

@MainActor
@Observable
/// Coordinates the read-only profile surface shown in the Profile tab.
final class ProfileViewModel {
    private let profileRepository: any UserProfileRepository
    private let routeRepository: any OfficialRouteRepository
    private let navigator: any ProfileRouting

    private(set) var profile: UserProfile?
    private(set) var routesByID: [OfficialRoute.ID: OfficialRoute] = [:]
    private(set) var isLoading = false

    init(
        profileRepository: any UserProfileRepository,
        routeRepository: any OfficialRouteRepository,
        navigator: any ProfileRouting
    ) {
        self.profileRepository = profileRepository
        self.routeRepository = routeRepository
        self.navigator = navigator
    }

    var currentRoute: OfficialRoute? {
        guard let profile else { return nil }
        return routesByID[profile.currentRouteID]
    }

    func load() async {
        isLoading = true

        async let profileTask = profileRepository.fetchProfile()
        async let routesTask = routeRepository.fetchRoutes()

        let loadedProfile = await profileTask
        let routes = await routesTask

        profile = loadedProfile
        routesByID = Dictionary(uniqueKeysWithValues: routes.map { ($0.id, $0) })
        isLoading = false
    }

    func showEditProfile() {
        navigator.showProfileEdit()
    }
}
