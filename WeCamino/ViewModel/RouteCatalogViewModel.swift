import Foundation
import Observation

@MainActor
@Observable
final class RouteCatalogViewModel {
    private let repository: any OfficialRouteRepository

    private(set) var routes: [OfficialRoute] = []
    private(set) var isLoading = false
    private(set) var hasLoaded = false

    init(repository: any OfficialRouteRepository) {
        self.repository = repository
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        isLoading = true
        routes = await repository.fetchRoutes()
        hasLoaded = true
        isLoading = false
    }
}
