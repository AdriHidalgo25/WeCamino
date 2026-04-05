import SwiftUI

struct WelcomeScene: View {
    @State private var viewModel: WelcomeViewModel

    init(
        repository: any WelcomeRepository,
        navigator: any WelcomeRouting
    ) {
        _viewModel = State(
            initialValue: WelcomeViewModel(
                repository: repository,
                navigator: navigator
            )
        )
    }

    var body: some View {
        WelcomeView(viewModel: viewModel)
            .task {
                await viewModel.loadIfNeeded()
            }
    }
}
