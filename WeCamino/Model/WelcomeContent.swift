import Foundation

/// Localized copy and primary action shown on the Home screen.
struct WelcomeContent: Equatable, Sendable {
    let title: String
    let message: String
    let primaryActionTitle: String
}
