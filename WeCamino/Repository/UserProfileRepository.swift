import Foundation

/// Persistence contract for the local pilgrim profile shown by the app.
protocol UserProfileRepository: Sendable {
    func fetchProfile() async -> UserProfile
    func saveProfile(_ profile: UserProfile) async
}

/// UserDefaults-backed storage for the local pilgrim profile.
actor LocalUserProfileRepository: UserProfileRepository {
    private enum StorageKey {
        static let profile = "user.profile"
    }

    private let userDefaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    // MARK: - Initialization

    /// Creates the local user profile repository.
    /// - Parameter userDefaults: Store used to persist the local pilgrim profile.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - UserProfileRepository

    func fetchProfile() async -> UserProfile {
        guard
            let data = userDefaults.data(forKey: StorageKey.profile),
            let profile = try? decoder.decode(UserProfile.self, from: data)
        else {
            return .default
        }

        return profile
    }

    func saveProfile(_ profile: UserProfile) async {
        guard let data = try? encoder.encode(profile) else { return }
        userDefaults.set(data, forKey: StorageKey.profile)
    }
}
