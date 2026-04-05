import Foundation
import Observation

enum AppTab: String, CaseIterable, Hashable {
    case home
    case routes
    case settings
}

@MainActor
@Observable
final class AppRouter: WelcomeRouting {
    var selectedTab: AppTab = .home
    var path: [AppDestination] = []

    func showRouteCatalog() {
        selectedTab = .routes
    }

    func popToRoot() {
        path.removeAll()
    }
}
