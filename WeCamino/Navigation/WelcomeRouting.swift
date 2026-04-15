import Foundation

@MainActor
/// Navigation actions exposed to the Home feature.
protocol WelcomeRouting: AnyObject {
    func showRouteCatalog()
    func showNotifications()
}
