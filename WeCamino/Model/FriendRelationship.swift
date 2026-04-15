import Foundation

/// Represents another pilgrim that can become part of the user's Camino circle.
struct FriendProfile: Codable, Equatable, Identifiable, Sendable {
    let id: UUID
    var name: String
    var bio: String
    var currentCity: String
    var currentRouteID: OfficialRoute.ID
    var currentStageNumber: Int
    var avatarImageData: Data?

    // MARK: - Display

    var initials: String {
        let words = name
            .split(whereSeparator: \.isWhitespace)
            .prefix(2)

        let initials = words.compactMap(\.first)
        return initials.isEmpty ? "WC" : String(initials).uppercased()
    }
}

/// Mirrors a simple Instagram-like friendship state machine for local app flows.
enum FriendshipStatus: String, Codable, CaseIterable, Sendable {
    case none
    case outgoingRequest
    case incomingRequest
    case friends
}

/// Couples a pilgrim profile with the current friendship state.
struct FriendRelationship: Codable, Equatable, Identifiable, Sendable {
    var pilgrim: FriendProfile
    var status: FriendshipStatus
    var lastUpdatedAt: Date

    // MARK: - Identifiable

    var id: UUID {
        pilgrim.id
    }
}
