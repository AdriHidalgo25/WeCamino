import Foundation
import Observation

/// Top-level tabs available in the app shell.
enum AppTab: String, CaseIterable, Hashable {
    case home
    case routes
    case friends
    case profile
    case settings
}

@MainActor
@Observable
/// Central navigation coordinator shared by tab content and pushed screens.
final class AppRouter: WelcomeRouting, ProfileRouting {
    // MARK: - State

    var selectedTab: AppTab = .home
    var path: [AppDestination] = []

    // MARK: - WelcomeRouting

    func showRouteCatalog() {
        selectedTab = .routes
    }

    func showNotifications() {
        path.append(.notifications)
    }

    // MARK: - ProfileRouting

    func showProfileEdit() {
        path.append(.profileEdit)
    }

    // MARK: - Friends

    func showFriendDetail(_ relationshipID: FriendRelationship.ID) {
        path.append(.friendDetail(relationshipID))
    }

    // MARK: - Stack

    func popToRoot() {
        path.removeAll()
    }
}
