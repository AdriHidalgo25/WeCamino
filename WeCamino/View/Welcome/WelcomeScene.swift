import SwiftUI

/// Scene adapter that connects the Welcome UI to app preferences and routing.
struct WelcomeScene: View {
    @Environment(AppPreferencesStore.self) private var preferences

    private let heroNamespace: Namespace.ID

    // MARK: - State

    @State private var viewModel: WelcomeViewModel

    // MARK: - Initialization

    /// Creates the Home scene and its view model.
    /// - Parameters:
    ///   - repository: Source of localized Home copy.
    ///   - navigator: Router used for Home actions.
    ///   - heroNamespace: Namespace shared with route transitions.
    init(
        repository: any WelcomeRepository,
        navigator: any WelcomeRouting,
        heroNamespace: Namespace.ID
    ) {
        self.heroNamespace = heroNamespace
        _viewModel = State(
            initialValue: WelcomeViewModel(
                repository: repository,
                navigator: navigator
            )
        )
    }

    // MARK: - Body

    var body: some View {
        WelcomeView(
            heroNamespace: heroNamespace,
            viewModel: viewModel
        )
            .task(id: preferences.resolvedLanguage) {
                await viewModel.loadIfNeeded(for: preferences.resolvedLanguage)
            }
    }
}

#if DEBUG
// MARK: - Previews

private struct WelcomeScenePreview: View {
    @Namespace private var heroNamespace
    private let navigator = PreviewWelcomeRouter()

    var body: some View {
        NavigationStack {
            WelcomeScene(
                repository: LocalWelcomeRepository(),
                navigator: navigator,
                heroNamespace: heroNamespace
            )
        }
        .weCaminoPreviewEnvironment()
    }
}

@MainActor
private final class PreviewWelcomeRouter: WelcomeRouting {
    func showRouteCatalog() {}
    func showNotifications() {}
}

#Preview("Welcome Scene") {
    WelcomeScenePreview()
}
#endif
