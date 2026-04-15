import Foundation
import Observation

@MainActor
@Observable
/// Coordinates the friendship lists and local actions for the Friends tab.
final class FriendsViewModel {
    enum Section: String, CaseIterable, Hashable {
        case friends
        case requests
        case discover
    }

    private let repository: any FriendsRepository
    private let routeRepository: any OfficialRouteRepository

    private(set) var relationships: [FriendRelationship] = []
    private(set) var routesByID: [OfficialRoute.ID: OfficialRoute] = [:]
    private(set) var isLoading = false
    var selectedSection: Section = .friends

    init(
        repository: any FriendsRepository,
        routeRepository: any OfficialRouteRepository
    ) {
        self.repository = repository
        self.routeRepository = routeRepository
    }

    var friends: [FriendRelationship] {
        relationships.filter { $0.status == .friends }
    }

    var incomingRequests: [FriendRelationship] {
        relationships.filter { $0.status == .incomingRequest }
    }

    var outgoingRequests: [FriendRelationship] {
        relationships.filter { $0.status == .outgoingRequest }
    }

    var discoverablePilgrims: [FriendRelationship] {
        relationships.filter { $0.status == .none }
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true

        async let relationshipsTask = repository.fetchRelationships()
        async let routesTask = routeRepository.fetchRoutes()

        relationships = await relationshipsTask
        let routes = await routesTask
        routesByID = Dictionary(uniqueKeysWithValues: routes.map { ($0.id, $0) })

        isLoading = false
    }

    func accept(_ relationshipID: FriendRelationship.ID) async {
        relationships = await repository.acceptRequest(from: relationshipID)
    }

    func decline(_ relationshipID: FriendRelationship.ID) async {
        relationships = await repository.declineRequest(from: relationshipID)
    }

    func send(_ relationshipID: FriendRelationship.ID) async {
        relationships = await repository.sendRequest(to: relationshipID)
    }

    func cancel(_ relationshipID: FriendRelationship.ID) async {
        relationships = await repository.cancelRequest(to: relationshipID)
    }

    func remove(_ relationshipID: FriendRelationship.ID) async {
        relationships = await repository.removeFriend(relationshipID)
    }

    func routeName(for relationship: FriendRelationship, language: AppLanguage) -> String {
        routesByID[relationship.pilgrim.currentRouteID]?.localizedName(for: language) ?? ""
    }
}
