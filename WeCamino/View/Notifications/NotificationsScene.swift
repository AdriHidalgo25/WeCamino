import SwiftUI

/// Notification center used to review and resolve pending friend requests.
struct NotificationsScene: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 40
        static let contentSpacing: CGFloat = 20
        static let cardSpacing: CGFloat = 14
        static let cardPadding: CGFloat = 18
        static let cornerRadius: CGFloat = 24
        static let avatarSize: CGFloat = 52
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppPreferencesStore.self) private var preferences

    // MARK: - State

    @State private var viewModel: NotificationsViewModel

    // MARK: - Initialization

    /// Creates the notification center scene.
    /// - Parameters:
    ///   - friendsRepository: Source of pending friend requests.
    ///   - routeRepository: Source used to describe each requester's active Camino.
    init(
        friendsRepository: any FriendsRepository,
        routeRepository: any OfficialRouteRepository
    ) {
        _viewModel = State(
            initialValue: NotificationsViewModel(
                friendsRepository: friendsRepository,
                routeRepository: routeRepository
            )
        )
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                header
                content
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .safeAreaPadding(.top, Layout.topPadding)
            .safeAreaPadding(.bottom, Layout.bottomPadding)
        }
        .navigationTitle(strings.notificationsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.notificationsTitle)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(strings.notificationsSubtitle)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.incomingRequests.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: Layout.cardSpacing) {
                ForEach(viewModel.incomingRequests) { relationship in
                    notificationCard(for: relationship)
                }
            }
        }
    }

    // MARK: - Components

    private func notificationCard(for relationship: FriendRelationship) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ProfileAvatarView(
                    initials: relationship.pilgrim.initials,
                    imageData: relationship.pilgrim.avatarImageData,
                    size: Layout.avatarSize,
                    accentColor: palette.accent,
                    backgroundColor: palette.accentSoft
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(strings.friendRequestNotificationTitle(relationship.pilgrim.name))
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)

                    Text(strings.friendRequestNotificationMessage(
                        route: viewModel.routeName(for: relationship, language: preferences.resolvedLanguage),
                        city: relationship.pilgrim.currentCity,
                        stage: strings.stageValue(relationship.pilgrim.currentStageNumber)
                    ))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)

                    Text(relationship.pilgrim.bio)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(2)
                }
            }

            HStack(spacing: 10) {
                actionButton(
                    title: strings.friendDeclineAction,
                    fill: palette.surfaceMuted,
                    foreground: palette.textSecondary
                ) {
                    Task {
                        await viewModel.decline(relationship.id)
                    }
                }

                actionButton(
                    title: strings.friendAcceptAction,
                    fill: palette.accent,
                    foreground: .white
                ) {
                    Task {
                        await viewModel.accept(relationship.id)
                    }
                }
            }
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func actionButton(
        title: String,
        fill: Color,
        foreground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(fill, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bell.slash")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(palette.accent)
                .frame(width: 52, height: 52)
                .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text(strings.notificationsEmptyTitle)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(strings.notificationsEmptySubtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
// MARK: - Previews

#Preview("Notifications") {
    NavigationStack {
        NotificationsScene(
            friendsRepository: AppDependencies.preview.friendsRepository,
            routeRepository: AppDependencies.preview.officialRouteRepository
        )
    }
    .weCaminoPreviewEnvironment()
}
#endif
