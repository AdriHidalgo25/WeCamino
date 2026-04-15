import Foundation

/// UserDefaults keys used to bridge notification counts into lightweight views.
enum NotificationStorageKey {
    static let pendingFriendRequests = "notifications.pendingFriendRequests"
}

/// Represents a user-facing in-app notification generated from local product state.
struct AppNotification: Identifiable, Equatable, Sendable {
    /// Product event represented by a notification.
    enum Kind: String, Sendable {
        case friendRequest
    }

    let id: FriendRelationship.ID
    let kind: Kind
    let title: String
    let message: String
    let friendName: String
    let createdAt: Date
}
