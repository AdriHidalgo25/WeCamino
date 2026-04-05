import SwiftUI

struct WelcomeScene: View {
    @Environment(AppPreferencesStore.self) private var preferences

    private let heroNamespace: Namespace.ID

    @State private var viewModel: WelcomeViewModel

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
