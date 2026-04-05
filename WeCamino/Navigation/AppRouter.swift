import Foundation
import Observation

@MainActor
@Observable
final class AppRouter: WelcomeRouting {
    var path: [AppDestination] = []

    func showRouteCatalog() {
        guard path.last != .routeCatalog else { return }
        path.append(.routeCatalog)
    }

    func popToRoot() {
        path.removeAll()
    }
}
