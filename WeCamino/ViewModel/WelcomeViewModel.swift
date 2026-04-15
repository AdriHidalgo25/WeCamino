import Foundation
import Observation

@MainActor
@Observable
/// Loads Home content and forwards Home actions to the app router.
final class WelcomeViewModel {
    // MARK: - Dependencies

    private let repository: any WelcomeRepository
    private let navigator: any WelcomeRouting
    private var loadedLanguage: AppLanguage?

    // MARK: - State

    private(set) var content: WelcomeContent?
    private(set) var isLoading = false

    // MARK: - Initialization

    /// Creates the Home view model.
    /// - Parameters:
    ///   - repository: Source of localized Home content.
    ///   - navigator: Router used to perform Home navigation actions.
    init(
        repository: any WelcomeRepository,
        navigator: any WelcomeRouting
    ) {
        self.repository = repository
        self.navigator = navigator
    }

    // MARK: - Loading

    /// Loads localized content once per language selection.
    func loadIfNeeded(for language: AppLanguage) async {
        guard loadedLanguage != language else { return }

        isLoading = true
        content = await repository.fetchWelcomeContent(for: language)
        loadedLanguage = language
        isLoading = false
    }

    // MARK: - Actions

    func primaryActionTapped() {
        navigator.showRouteCatalog()
    }

    func notificationsTapped() {
        navigator.showNotifications()
    }
}
