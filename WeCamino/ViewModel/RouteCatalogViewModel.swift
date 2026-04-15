import Foundation
import Observation

@MainActor
@Observable
/// Loads and exposes the official route catalog for SwiftUI.
final class RouteCatalogViewModel {
    // MARK: - Dependencies

    private let repository: any OfficialRouteRepository

    // MARK: - State

    private(set) var routes: [OfficialRoute] = []
    private(set) var isLoading = false
    private(set) var hasLoaded = false

    // MARK: - Initialization

    /// Creates the catalog view model.
    /// - Parameter repository: Source of official route data.
    init(repository: any OfficialRouteRepository) {
        self.repository = repository
    }

    // MARK: - Loading

    /// Fetches routes once for the lifetime of the view model.
    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        isLoading = true
        routes = await repository.fetchRoutes()
        hasLoaded = true
        isLoading = false
    }
}
