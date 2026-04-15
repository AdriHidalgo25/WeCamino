import Foundation

/// Type-safe destinations pushed on the root `NavigationStack`.
enum AppDestination: Hashable {
    case routeCatalog
    case routeDetail(OfficialRoute.ID)
    case notifications
    case profileEdit
    case friendDetail(FriendRelationship.ID)
}
