import Foundation

/// Persistence contract for the local friendship graph shown in the Friends feature.
protocol FriendsRepository: Sendable {
    func fetchRelationships() async -> [FriendRelationship]
    func acceptRequest(from id: FriendRelationship.ID) async -> [FriendRelationship]
    func declineRequest(from id: FriendRelationship.ID) async -> [FriendRelationship]
    func sendRequest(to id: FriendRelationship.ID) async -> [FriendRelationship]
    func cancelRequest(to id: FriendRelationship.ID) async -> [FriendRelationship]
    func removeFriend(_ id: FriendRelationship.ID) async -> [FriendRelationship]
}

/// UserDefaults-backed storage for the local friendship graph.
actor LocalFriendsRepository: FriendsRepository {
    private enum StorageKey {
        static let relationships = "friends.relationships"
    }

    private let userDefaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        Self.bootstrapPendingNotificationCount(userDefaults: userDefaults)
    }

    func fetchRelationships() async -> [FriendRelationship] {
        let relationships = loadRelationships()
        syncPendingNotificationCount(for: relationships)
        return relationships
    }

    func acceptRequest(from id: FriendRelationship.ID) async -> [FriendRelationship] {
        updateRelationships(for: id) { relationship in
            guard relationship.status == .incomingRequest else { return relationship }

            var updatedRelationship = relationship
            updatedRelationship.status = .friends
            updatedRelationship.lastUpdatedAt = .now
            return updatedRelationship
        }
    }

    func declineRequest(from id: FriendRelationship.ID) async -> [FriendRelationship] {
        updateRelationships(for: id) { relationship in
            guard relationship.status == .incomingRequest else { return relationship }

            var updatedRelationship = relationship
            updatedRelationship.status = .none
            updatedRelationship.lastUpdatedAt = .now
            return updatedRelationship
        }
    }

    func sendRequest(to id: FriendRelationship.ID) async -> [FriendRelationship] {
        updateRelationships(for: id) { relationship in
            guard relationship.status == .none else { return relationship }

            var updatedRelationship = relationship
            updatedRelationship.status = .outgoingRequest
            updatedRelationship.lastUpdatedAt = .now
            return updatedRelationship
        }
    }

    func cancelRequest(to id: FriendRelationship.ID) async -> [FriendRelationship] {
        updateRelationships(for: id) { relationship in
            guard relationship.status == .outgoingRequest else { return relationship }

            var updatedRelationship = relationship
            updatedRelationship.status = .none
            updatedRelationship.lastUpdatedAt = .now
            return updatedRelationship
        }
    }

    func removeFriend(_ id: FriendRelationship.ID) async -> [FriendRelationship] {
        updateRelationships(for: id) { relationship in
            guard relationship.status == .friends else { return relationship }

            var updatedRelationship = relationship
            updatedRelationship.status = .none
            updatedRelationship.lastUpdatedAt = .now
            return updatedRelationship
        }
    }

    private func loadRelationships() -> [FriendRelationship] {
        guard
            let data = userDefaults.data(forKey: StorageKey.relationships),
            let relationships = try? decoder.decode([FriendRelationship].self, from: data)
        else {
            syncPendingNotificationCount(for: defaultRelationships)
            return defaultRelationships
        }

        return relationships
    }

    private func updateRelationships(
        for id: FriendRelationship.ID,
        mutation: (FriendRelationship) -> FriendRelationship
    ) -> [FriendRelationship] {
        let updatedRelationships = loadRelationships().map { relationship in
            guard relationship.id == id else { return relationship }
            return mutation(relationship)
        }

        persist(updatedRelationships)
        return updatedRelationships
    }

    private func persist(_ relationships: [FriendRelationship]) {
        guard let data = try? encoder.encode(relationships) else { return }
        userDefaults.set(data, forKey: StorageKey.relationships)
        syncPendingNotificationCount(for: relationships)
    }

    private func syncPendingNotificationCount(for relationships: [FriendRelationship]) {
        let count = relationships.reduce(into: 0) { partialResult, relationship in
            if relationship.status == .incomingRequest {
                partialResult += 1
            }
        }

        userDefaults.set(count, forKey: NotificationStorageKey.pendingFriendRequests)
    }

    private static func bootstrapPendingNotificationCount(userDefaults: UserDefaults) {
        let decoder = JSONDecoder()

        let relationships: [FriendRelationship]
        if
            let data = userDefaults.data(forKey: StorageKey.relationships),
            let storedRelationships = try? decoder.decode([FriendRelationship].self, from: data)
        {
            relationships = storedRelationships
        } else {
            relationships = defaultRelationships
        }

        let count = relationships.reduce(into: 0) { partialResult, relationship in
            if relationship.status == .incomingRequest {
                partialResult += 1
            }
        }

        userDefaults.set(count, forKey: NotificationStorageKey.pendingFriendRequests)
    }
}

private let defaultRelationships: [FriendRelationship] = [
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000001") ?? UUID(),
            name: "Lucia Varela",
            bio: "Walking slow, eating well and collecting sunrise moments on the Camino.",
            currentCity: "Portomarin",
            currentRouteID: .frances,
            currentStageNumber: 4,
            avatarImageData: nil
        ),
        status: .friends,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000002") ?? UUID(),
            name: "Mateo Pardo",
            bio: "Looking for the quiet side of the Camino and every old church on the way.",
            currentCity: "Lugo",
            currentRouteID: .primitivo,
            currentStageNumber: 3,
            avatarImageData: nil
        ),
        status: .friends,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000003") ?? UUID(),
            name: "Carla Souto",
            bio: "Atlantic lover. Doing the coastal route one coffee stop at a time.",
            currentCity: "Baiona",
            currentRouteID: .portuguesCoastal,
            currentStageNumber: 2,
            avatarImageData: nil
        ),
        status: .friends,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000004") ?? UUID(),
            name: "Sofia Rey",
            bio: "Starting from Ferrol and sharing every estuary, bridge and rainy day.",
            currentCity: "Neda",
            currentRouteID: .ingles,
            currentStageNumber: 1,
            avatarImageData: nil
        ),
        status: .incomingRequest,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000005") ?? UUID(),
            name: "Hugo Pena",
            bio: "North route pilgrim chasing long stages and Atlantic light.",
            currentCity: "Ribadeo",
            currentRouteID: .norte,
            currentStageNumber: 1,
            avatarImageData: nil
        ),
        status: .incomingRequest,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000006") ?? UUID(),
            name: "Emma Doval",
            bio: "Camino Frances for the first time. Trying to make every stage count.",
            currentCity: "Sarria",
            currentRouteID: .frances,
            currentStageNumber: 3,
            avatarImageData: nil
        ),
        status: .outgoingRequest,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000007") ?? UUID(),
            name: "Pablo Seoane",
            bio: "Doing the winter route and loving the quieter inland stretch.",
            currentCity: "Monforte de Lemos",
            currentRouteID: .invierno,
            currentStageNumber: 4,
            avatarImageData: nil
        ),
        status: .none,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000008") ?? UUID(),
            name: "Ines Figueroa",
            bio: "Already in Santiago and heading to the Atlantic for the final stretch.",
            currentCity: "Negreira",
            currentRouteID: .fisterraMuxia,
            currentStageNumber: 1,
            avatarImageData: nil
        ),
        status: .none,
        lastUpdatedAt: .now
    ),
    FriendRelationship(
        pilgrim: FriendProfile(
            id: UUID(uuidString: "A0000000-0000-0000-0000-000000000009") ?? UUID(),
            name: "Nora Campos",
            bio: "Cross-border Camino energy, small villages and long conversations.",
            currentCity: "Tui",
            currentRouteID: .portugues,
            currentStageNumber: 1,
            avatarImageData: nil
        ),
        status: .none,
        lastUpdatedAt: .now
    )
]
