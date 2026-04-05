import Foundation

protocol WelcomeRepository: Sendable {
    func fetchWelcomeContent() async -> WelcomeContent
}

struct LocalWelcomeRepository: WelcomeRepository {
    func fetchWelcomeContent() async -> WelcomeContent {
        WelcomeContent(
            title: "Bienvenido a WeCamino",
            message: "Una base SwiftUI con arquitectura MVVM, navegación desacoplada y dependencias inyectadas desde el composition root.",
            primaryActionTitle: "Comenzar"
        )
    }
}
