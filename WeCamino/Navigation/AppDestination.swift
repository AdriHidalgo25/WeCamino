import Foundation

enum AppDestination: Hashable {
    case routeCatalog
    case routeDetail(OfficialRoute.ID)
    case profileEdit
}
