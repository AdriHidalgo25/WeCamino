import Foundation
import Observation

@MainActor
@Observable
final class AppRouter: WelcomeRouting {
    var path: [AppDestination] = []

    func showHome() {
        path.append(.home)
    }

    func popToRoot() {
        path.removeAll()
    }
}
