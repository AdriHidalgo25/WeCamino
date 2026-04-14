import SwiftUI

/// Root profile screen for the local pilgrim identity.
struct ProfileScene: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let contentSpacing: CGFloat = 20
        static let topPadding: CGFloat = 24
        static let cardPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 16
        static let headerSpacing: CGFloat = 16
        static let avatarSize: CGFloat = 76
        static let statSpacing: CGFloat = 12
        static let rowSpacing: CGFloat = 12
        static let rowIconSize: CGFloat = 18
        static let rowIconFrame: CGFloat = 36
        static let cardCornerRadius: CGFloat = 28
        static let bottomPadding: CGFloat = 128
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppPreferencesStore.self) private var preferences

    @State private var viewModel: ProfileViewModel

    init(
        profileRepository: any UserProfileRepository,
        routeRepository: any OfficialRouteRepository,
        navigator: any ProfileRouting
    ) {
        _viewModel = State(
            initialValue: ProfileViewModel(
                profileRepository: profileRepository,
                routeRepository: routeRepository,
                navigator: navigator
            )
        )
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                profileHeader
                journeySection
                bioSection
                actionsSection
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .safeAreaPadding(.top, Layout.topPadding)
            .safeAreaPadding(.bottom, Layout.bottomPadding)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            Task {
                await viewModel.load()
            }
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: Layout.headerSpacing) {
            VStack(alignment: .leading, spacing: 8) {
                Text(strings.profileTitle)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(strings.profileSubtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
            }

            if let profile = viewModel.profile {
                VStack(alignment: .leading, spacing: Layout.headerSpacing) {
                    HStack(spacing: 14) {
                        profileAvatar(for: profile)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.name)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(palette.textPrimary)

                            Text(profile.phoneNumber)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(palette.textSecondary)
                        }

                        Spacer()

                        Button {
                            viewModel.showEditProfile()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(palette.accent)
                                .frame(width: 42, height: 42)
                                .background(palette.accentSoft, in: Circle())
                        }
                        .buttonStyle(.plain)
                    }

                    HStack(spacing: Layout.statSpacing) {
                        summaryPill(
                            title: strings.profileCityLabel,
                            value: profile.city,
                            systemImage: "location.fill"
                        )

                        summaryPill(
                            title: strings.profileStageLabel,
                            value: strings.stageValue(profile.currentStageNumber),
                            systemImage: "figure.walk"
                        )
                    }
                }
                .padding(Layout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
            }
        }
    }

    private var journeySection: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            sectionTitle(strings.profileJourneySectionTitle)

            if let profile = viewModel.profile {
                VStack(alignment: .leading, spacing: 14) {
                    profileInfoRow(
                        title: strings.profileRouteLabel,
                        value: viewModel.currentRoute?.localizedName(for: preferences.resolvedLanguage) ?? strings.routeUnavailable,
                        symbolName: "map.fill"
                    )

                    profileInfoRow(
                        title: strings.profileStageLabel,
                        value: stageDescription(for: profile),
                        symbolName: "figure.walk"
                    )

                    profileInfoRow(
                        title: strings.profileCityLabel,
                        value: profile.city,
                        symbolName: "mappin.and.ellipse"
                    )
                }
                .padding(Layout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
            }
        }
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            sectionTitle(strings.profileBioSectionTitle)

            Text(viewModel.profile?.bio.isEmpty == false ? viewModel.profile?.bio ?? "" : strings.profileBioPlaceholder)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(viewModel.profile?.bio.isEmpty == false ? palette.textPrimary : palette.textSecondary)
                .padding(Layout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            VStack(alignment: .leading, spacing: 6) {
                sectionTitle(strings.profileActionsSectionTitle)

                Text(strings.profileActionsSectionSubtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
            }

            VStack(spacing: Layout.rowSpacing) {
                actionRow(
                    title: strings.profileEditActionTitle,
                    subtitle: strings.profileEditActionSubtitle,
                    symbolName: "person.text.rectangle.fill"
                ) {
                    viewModel.showEditProfile()
                }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundStyle(palette.textPrimary)
    }

    private func profileAvatar(for profile: UserProfile) -> some View {
        ProfileAvatarView(
            initials: profile.initials,
            imageData: profile.avatarImageData,
            size: Layout.avatarSize,
            accentColor: palette.accent,
            backgroundColor: palette.accentSoft
        )
    }

    private func summaryPill(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(palette.accent)
                .frame(width: 28, height: 28)
                .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)

                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(palette.surfaceMuted)
        )
    }

    private func profileInfoRow(
        title: String,
        value: String,
        symbolName: String
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbolName)
                .font(.system(size: Layout.rowIconSize, weight: .semibold))
                .foregroundStyle(palette.accent)
                .frame(width: Layout.rowIconFrame, height: Layout.rowIconFrame)
                .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)

                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
            }

            Spacer()
        }
    }

    private func actionRow(
        title: String,
        subtitle: String,
        symbolName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: symbolName)
                    .font(.system(size: Layout.rowIconSize, weight: .semibold))
                    .foregroundStyle(palette.accent)
                    .frame(width: Layout.rowIconFrame, height: Layout.rowIconFrame)
                    .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(palette.textSecondary)
            }
            .padding(Layout.cardPadding)
            .background(cardBackground)
        }
        .buttonStyle(.plain)
    }

    private func stageDescription(for profile: UserProfile) -> String {
        let stageValue = strings.stageValue(profile.currentStageNumber)
        guard
            let route = viewModel.currentRoute,
            route.stages.indices.contains(profile.currentStageNumber - 1)
        else {
            return stageValue
        }

        let stage = route.stages[profile.currentStageNumber - 1]
        return "\(stageValue) - \(stage.start.name) / \(stage.end.name)"
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
            .fill(palette.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                    .stroke(palette.border, lineWidth: 1)
            )
    }
}
