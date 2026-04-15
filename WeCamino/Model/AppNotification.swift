import Foundation

enum NotificationStorageKey {
    static let pendingFriendRequests = "notifications.pendingFriendRequests"
}

/// Represents a user-facing in-app notification generated from local product state.
struct AppNotification: Identifiable, Equatable, Sendable {
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
