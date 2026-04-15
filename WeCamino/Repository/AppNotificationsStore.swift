import Foundation
import Combine

@MainActor
/// Global notification store used for app-wide badges and notification views.
final class AppNotificationsStore: ObservableObject {
    private let friendsRepository: any FriendsRepository

    @Published private(set) var notifications: [AppNotification] = []
    @Published private(set) var isLoading = false

    /// Creates the badge store.
    /// - Parameter friendsRepository: Source used to derive friend request notifications.
    init(friendsRepository: any FriendsRepository) {
        self.friendsRepository = friendsRepository
    }

    var pendingCount: Int {
        notifications.count
    }

    func reload() async {
        guard !isLoading else { return }
        isLoading = true

        let relationships = await friendsRepository.fetchRelationships()
        notifications = relationships
            .filter { $0.status == .incomingRequest }
            .sorted { $0.lastUpdatedAt > $1.lastUpdatedAt }
            .map { relationship in
                AppNotification(
                    id: relationship.id,
                    kind: .friendRequest,
                    title: notificationTitle(for: relationship),
                    message: notificationMessage(for: relationship),
                    friendName: relationship.pilgrim.name,
                    createdAt: relationship.lastUpdatedAt
                )
            }

        isLoading = false
    }

    private func notificationTitle(for relationship: FriendRelationship) -> String {
        "\(relationship.pilgrim.name) sent you a friend request"
    }

    private func notificationMessage(for relationship: FriendRelationship) -> String {
        "\(relationship.pilgrim.currentCity) · Stage \(relationship.pilgrim.currentStageNumber)"
    }
}
