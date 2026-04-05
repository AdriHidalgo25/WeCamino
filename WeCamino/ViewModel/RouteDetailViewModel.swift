import Foundation
import Observation
import MapKit

@MainActor
@Observable
final class RouteDetailViewModel {
    private let repository: any OfficialRouteRepository
    private let routeID: OfficialRoute.ID

    private(set) var route: OfficialRoute?
    private(set) var isLoading = false
    private(set) var hasLoaded = false
    private(set) var routeStops: [RouteStopAnnotation] = []
    private(set) var routeMapRect: MKMapRect?
    private(set) var isResolvingRouteStops = false
    private(set) var hasResolvedRouteStops = false

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

    func loadRouteStopsIfNeeded() async {
        guard !hasResolvedRouteStops, let route else { return }

        isResolvingRouteStops = true

        let resolvedStops = await RouteStopResolver.shared.resolve(stops: route.stops)
        routeStops = resolvedStops
        routeMapRect = Self.makeMapRect(for: resolvedStops)
        hasResolvedRouteStops = true
        isResolvingRouteStops = false
    }

    private static func makeMapRect(for stops: [RouteStopAnnotation]) -> MKMapRect? {
        guard !stops.isEmpty else { return nil }

        let baseRect = stops.reduce(MKMapRect.null) { partialResult, stop in
            let mapPoint = MKMapPoint(stop.coordinate)
            let pointRect = MKMapRect(
                x: mapPoint.x,
                y: mapPoint.y,
                width: 1,
                height: 1
            )

            if partialResult.isNull {
                return pointRect
            }

            return partialResult.union(pointRect)
        }

        return baseRect.insetBy(
            dx: -max(baseRect.size.width * 0.35, 14_000),
            dy: -max(baseRect.size.height * 0.35, 14_000)
        )
    }
}

struct RouteStopAnnotation: Identifiable {
    let stop: OfficialRoute.Stop
    let coordinate: CLLocationCoordinate2D

    var id: String {
        stop.id
    }
}

actor RouteStopResolver {
    static let shared = RouteStopResolver()

    private var cache: [String: CLLocationCoordinate2D] = [:]

    func resolve(stops: [OfficialRoute.Stop]) async -> [RouteStopAnnotation] {
        var resolvedStops: [RouteStopAnnotation] = []

        for stop in stops {
            if let coordinate = await coordinate(for: stop) {
                resolvedStops.append(
                    RouteStopAnnotation(
                        stop: stop,
                        coordinate: coordinate
                    )
                )
            }
        }

        return resolvedStops
    }

    private func coordinate(for stop: OfficialRoute.Stop) async -> CLLocationCoordinate2D? {
        if let persistedCoordinate = stop.coordinate?.clLocationCoordinate2D {
            cache[stop.id] = persistedCoordinate
            return persistedCoordinate
        }

        if let cachedCoordinate = cache[stop.id] {
            return cachedCoordinate
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = stop.searchQuery

        do {
            let response = try await MKLocalSearch(request: request).start()
            let coordinate = response.mapItems.first?.placemark.coordinate
            cache[stop.id] = coordinate
            return coordinate
        } catch {
            return nil
        }
    }
}

private extension OfficialRoute.Coordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
