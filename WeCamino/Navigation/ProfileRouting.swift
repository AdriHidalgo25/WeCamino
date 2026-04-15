import Foundation

@MainActor
/// Navigation actions the Profile feature can request.
protocol ProfileRouting: AnyObject {
    func showProfileEdit()
}
