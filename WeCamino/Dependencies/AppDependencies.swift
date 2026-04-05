import Foundation

struct AppDependencies {
    let welcomeRepository: any WelcomeRepository
}

extension AppDependencies {
    static let live = AppDependencies(
        welcomeRepository: LocalWelcomeRepository()
    )
}
