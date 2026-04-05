import Foundation
import Observation

@MainActor
@Observable
final class WelcomeViewModel {
    private let repository: any WelcomeRepository
    private let navigator: any WelcomeRouting

    private(set) var content: WelcomeContent?
    private(set) var isLoading = false
    private(set) var hasLoaded = false

    init(
        repository: any WelcomeRepository,
        navigator: any WelcomeRouting
    ) {
        self.repository = repository
        self.navigator = navigator
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        isLoading = true
        content = await repository.fetchWelcomeContent()
        hasLoaded = true
        isLoading = false
    }

    func primaryActionTapped() {
        navigator.showRouteCatalog()
    }
}
