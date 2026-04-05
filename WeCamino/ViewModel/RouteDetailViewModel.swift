import Foundation
import Observation

@MainActor
@Observable
final class RouteDetailViewModel {
    private let repository: any OfficialRouteRepository
    private let routeID: OfficialRoute.ID

    private(set) var route: OfficialRoute?
    private(set) var isLoading = false
    private(set) var hasLoaded = false

    init(
        repository: any OfficialRouteRepository,
        routeID: OfficialRoute.ID
    ) {
        self.repository = repository
        self.routeID = routeID
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        isLoading = true
        route = await repository.fetchRoute(id: routeID)
        hasLoaded = true
        isLoading = false
    }
}
