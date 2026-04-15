import Foundation
import Observation

@MainActor
@Observable
/// Coordinates the notification center backed by pending friend requests.
final class NotificationsViewModel {
    private let friendsRepository: any FriendsRepository
    private let routeRepository: any OfficialRouteRepository

    private(set) var incomingRequests: [FriendRelationship] = []
    private(set) var routesByID: [OfficialRoute.ID: OfficialRoute] = [:]
    private(set) var isLoading = false

    init(
        friendsRepository: any FriendsRepository,
        routeRepository: any OfficialRouteRepository
    ) {
        self.friendsRepository = friendsRepository
        self.routeRepository = routeRepository
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true

        async let relationshipsTask = friendsRepository.fetchRelationships()
        async let routesTask = routeRepository.fetchRoutes()

        let relationships = await relationshipsTask
        let routes = await routesTask

        incomingRequests = relationships.filter { $0.status == .incomingRequest }
        routesByID = Dictionary(uniqueKeysWithValues: routes.map { ($0.id, $0) })
        isLoading = false
    }

    func accept(_ relationshipID: FriendRelationship.ID) async {
        let updated = await friendsRepository.acceptRequest(from: relationshipID)
        incomingRequests = updated.filter { $0.status == .incomingRequest }
    }

    func decline(_ relationshipID: FriendRelationship.ID) async {
        let updated = await friendsRepository.declineRequest(from: relationshipID)
        incomingRequests = updated.filter { $0.status == .incomingRequest }
    }

    func routeName(for relationship: FriendRelationship, language: AppLanguage) -> String {
        routesByID[relationship.pilgrim.currentRouteID]?.localizedName(for: language) ?? ""
    }
}
