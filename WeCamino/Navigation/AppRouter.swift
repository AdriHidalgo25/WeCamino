import Foundation
import Observation

enum AppTab: String, CaseIterable, Hashable {
    case home
    case routes
    case friends
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

    func showNotifications() {
        path.append(.notifications)
    }

    func showProfileEdit() {
        path.append(.profileEdit)
    }

    func showFriendDetail(_ relationshipID: FriendRelationship.ID) {
        path.append(.friendDetail(relationshipID))
    }

    func popToRoot() {
        path.removeAll()
    }
}
