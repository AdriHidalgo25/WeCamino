import Foundation
import Observation
import UIKit

@MainActor
@Observable
/// Holds the editable pilgrim state before saving it back to local storage.
final class EditProfileViewModel {
    private let profileRepository: any UserProfileRepository
    private let routeRepository: any OfficialRouteRepository

    private(set) var routes: [OfficialRoute] = []
    private(set) var isLoading = false
    private(set) var isSaving = false
    private(set) var hasLoaded = false

    var name = ""
    var phoneNumber = ""
    var city = ""
    var bio = ""
    var avatarImageData: Data?
    var currentRouteID: OfficialRoute.ID = .portugues
    var currentStageNumber = 1

    init(
        profileRepository: any UserProfileRepository,
        routeRepository: any OfficialRouteRepository
    ) {
        self.profileRepository = profileRepository
        self.routeRepository = routeRepository
    }

    var selectedRoute: OfficialRoute? {
        routes.first { $0.id == currentRouteID }
    }

    var avatarInitials: String {
        UserProfile(
            name: name,
            phoneNumber: phoneNumber,
            city: city,
            bio: bio,
            avatarImageData: avatarImageData,
            currentRouteID: currentRouteID,
            currentStageNumber: currentStageNumber
        ).initials
    }

    var stageOptions: [Int] {
        let count = selectedRoute?.stages.count ?? 1
        return Array(1...max(count, 1))
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isSaving
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        isLoading = true

        async let profileTask = profileRepository.fetchProfile()
        async let routesTask = routeRepository.fetchRoutes()

        let loadedProfile = await profileTask
        let loadedRoutes = await routesTask

        routes = loadedRoutes
        apply(profile: loadedProfile)

        hasLoaded = true
        isLoading = false
    }

    func updateRoute(to routeID: OfficialRoute.ID) {
        currentRouteID = routeID
        currentStageNumber = normalizedStageNumber(
            currentStageNumber,
            for: routeID
        )
    }

    func updateStage(to stageNumber: Int) {
        currentStageNumber = normalizedStageNumber(
            stageNumber,
            for: currentRouteID
        )
    }

    func save() async {
        guard canSave else { return }

        isSaving = true
        await profileRepository.saveProfile(makeProfile())
        isSaving = false
    }

    func updateAvatarImageData(_ data: Data?) {
        avatarImageData = normalizedAvatarData(from: data)
    }

    private func apply(profile: UserProfile) {
        name = profile.name
        phoneNumber = profile.phoneNumber
        city = profile.city
        bio = profile.bio
        avatarImageData = profile.avatarImageData
        currentRouteID = profile.currentRouteID
        currentStageNumber = normalizedStageNumber(
            profile.currentStageNumber,
            for: profile.currentRouteID
        )
    }

    private func makeProfile() -> UserProfile {
        UserProfile(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            bio: bio.trimmingCharacters(in: .whitespacesAndNewlines),
            avatarImageData: avatarImageData,
            currentRouteID: currentRouteID,
            currentStageNumber: normalizedStageNumber(
                currentStageNumber,
                for: currentRouteID
            )
        )
    }

    private func normalizedStageNumber(
        _ stageNumber: Int,
        for routeID: OfficialRoute.ID
    ) -> Int {
        let count = routes.first(where: { $0.id == routeID })?.stages.count ?? 1
        return min(max(stageNumber, 1), max(count, 1))
    }

    private func normalizedAvatarData(from data: Data?) -> Data? {
        guard
            let data,
            let image = UIImage(data: data)
        else {
            return nil
        }

        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1

        let targetSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: rendererFormat)

        let renderedImage = renderer.image { _ in
            let sourceSize = image.size
            let scale = max(
                targetSize.width / max(sourceSize.width, 1),
                targetSize.height / max(sourceSize.height, 1)
            )

            let drawSize = CGSize(
                width: sourceSize.width * scale,
                height: sourceSize.height * scale
            )

            let origin = CGPoint(
                x: (targetSize.width - drawSize.width) / 2,
                y: (targetSize.height - drawSize.height) / 2
            )

            image.draw(in: CGRect(origin: origin, size: drawSize))
        }

        return renderedImage.jpegData(compressionQuality: 0.82)
    }
}
