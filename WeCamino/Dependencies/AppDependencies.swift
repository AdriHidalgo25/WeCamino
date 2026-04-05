import Foundation

struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
    let officialRouteRepository: any OfficialRouteRepository
}

extension AppDependencies {
    static let live = AppDependencies(
        welcomeRepository: LocalWelcomeRepository(),
        officialRouteRepository: LocalOfficialRouteRepository()
    )
}
