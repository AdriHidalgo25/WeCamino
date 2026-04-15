import Foundation

@MainActor
protocol WelcomeRouting: AnyObject {
    func showRouteCatalog()
    func showNotifications()
}
