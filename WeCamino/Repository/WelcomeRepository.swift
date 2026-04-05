import Foundation

protocol WelcomeRepository: Sendable {
    func fetchWelcomeContent() async -> WelcomeContent
}

struct LocalWelcomeRepository: WelcomeRepository {
    func fetchWelcomeContent() async -> WelcomeContent {
        WelcomeContent(
            title: "Walk the Camino your way",
            message: "Official routes, social check-ins and a brighter home for pilgrims heading to Santiago.",
            primaryActionTitle: "Explore routes"
        )
    }
}
