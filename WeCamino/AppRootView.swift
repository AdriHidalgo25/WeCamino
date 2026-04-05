import SwiftUI

struct AppRootView: View {
    private let dependencies: AppDependencies

    @Namespace private var heroNamespace
    @State private var router: AppRouter

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _router = State(initialValue: AppRouter())
    }

    var body: some View {
        let appRouter = router
        @Bindable var bindableRouter = appRouter

        NavigationStack(path: $bindableRouter.path) {
            WelcomeScene(
                repository: dependencies.welcomeRepository,
                navigator: appRouter,
                heroNamespace: heroNamespace
            )
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .home:
                    HomePlaceholderView(heroNamespace: heroNamespace)
                }
            }
        }
    }
}
