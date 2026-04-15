import Foundation

/// Represents the local pilgrim identity shown in the Profile feature.
struct UserProfile: Codable, Equatable, Sendable {
    var name: String
    var phoneNumber: String
    var city: String
    var bio: String
    var avatarImageData: Data?
    var currentRouteID: OfficialRoute.ID
    var currentStageNumber: Int

    // MARK: - Defaults

    static let `default` = UserProfile(
        name: "Alex Camino",
        phoneNumber: "+34 600 123 456",
        city: "Sarria",
        bio: "",
        avatarImageData: nil,
        currentRouteID: .portugues,
        currentStageNumber: 3
    )

    // MARK: - Display

    var initials: String {
        let words = name
            .split(whereSeparator: \.isWhitespace)
            .prefix(2)

        let initials = words.compactMap { $0.first }
        return initials.isEmpty ? "WC" : String(initials).uppercased()
    }
}
