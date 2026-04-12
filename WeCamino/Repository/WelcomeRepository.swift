import Foundation

protocol WelcomeRepository: Sendable {
    func fetchWelcomeContent(for language: AppLanguage) async -> WelcomeContent
}

struct LocalWelcomeRepository: WelcomeRepository {
    func fetchWelcomeContent(for language: AppLanguage) async -> WelcomeContent {
        switch language {
        case .spanish:
            WelcomeContent(
                title: "Vive el Camino a tu manera",
                message: "Rutas oficiales, check-ins sociales y una experiencia más visual para peregrinos que van hacia Santiago.",
                primaryActionTitle: "Explorar rutas"
            )
        case .french:
            WelcomeContent(
                title: "Vivez le Camino à votre façon",
                message: "Routes officielles, check-ins sociaux et une expérience plus visuelle pour les pèlerins en route vers Saint-Jacques.",
                primaryActionTitle: "Explorer les routes"
            )
        case .system, .english:
            WelcomeContent(
                title: "Walk the Camino your way",
                message: "Official routes, social check-ins and a brighter home for pilgrims heading to Santiago.",
                primaryActionTitle: "Explore routes"
            )
        }
    }
}
