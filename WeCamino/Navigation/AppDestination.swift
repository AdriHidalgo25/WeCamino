import Foundation

enum AppDestination: Hashable {
    case routeCatalog
    case routeDetail(OfficialRoute.ID)
    case notifications
    case profileEdit
    case friendDetail(FriendRelationship.ID)
}
