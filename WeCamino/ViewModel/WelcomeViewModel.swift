import Foundation
import Observation

@MainActor
@Observable
final class WelcomeViewModel {
    private let repository: any WelcomeRepository
    private let navigator: any WelcomeRouting
    private var loadedLanguage: AppLanguage?

    private(set) var content: WelcomeContent?
    private(set) var isLoading = false

    init(
        repository: any WelcomeRepository,
        navigator: any WelcomeRouting
    ) {
        self.repository = repository
        self.navigator = navigator
    }

    func loadIfNeeded(for language: AppLanguage) async {
        guard loadedLanguage != language else { return }

        isLoading = true
        content = await repository.fetchWelcomeContent(for: language)
        loadedLanguage = language
        isLoading = false
    }

    func primaryActionTapped() {
        navigator.showRouteCatalog()
    }
}
