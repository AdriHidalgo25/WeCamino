import Foundation
import Observation

enum AppTab: String, CaseIterable, Hashable {
    case home
    case routes
    case profile
    case settings
}

@MainActor
@Observable
final class AppRouter: WelcomeRouting, ProfileRouting {
    var selectedTab: AppTab = .home
    var path: [AppDestination] = []

    func showRouteCatalog() {
        selectedTab = .routes
    }

    func showProfileEdit() {
        path.append(.profileEdit)
    }

    func popToRoot() {
        path.removeAll()
    }
}
