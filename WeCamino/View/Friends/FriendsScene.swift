import SwiftUI

/// Social management surface for friend requests and accepted Camino friends.
struct FriendsScene: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 132
        static let contentSpacing: CGFloat = 20
        static let sectionSpacing: CGFloat = 16
        static let cardSpacing: CGFloat = 14
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 24
        static let avatarSize: CGFloat = 56
        static let summarySpacing: CGFloat = 12
        static let summaryCardHeight: CGFloat = 86
        static let segmentedSpacing: CGFloat = 8
        static let segmentedPadding: CGFloat = 5
        static let actionSpacing: CGFloat = 10
        static let pillVerticalPadding: CGFloat = 8
        static let pillHorizontalPadding: CGFloat = 12
        static let swipeActionWidth: CGFloat = 108
        static let swipeTriggerThreshold: CGFloat = 56
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppPreferencesStore.self) private var preferences

    private let onFriendSelected: (FriendRelationship.ID) -> Void

    @State private var viewModel: FriendsViewModel
    @State private var pendingRemovalRelationship: FriendRelationship?

    init(
        repository: any FriendsRepository,
        routeRepository: any OfficialRouteRepository,
        onFriendSelected: @escaping (FriendRelationship.ID) -> Void
    ) {
        self.onFriendSelected = onFriendSelected
        _viewModel = State(
            initialValue: FriendsViewModel(
                repository: repository,
                routeRepository: routeRepository
            )
        )
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                header
                overview
                segmentedControl
                sectionContent
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
        .alert(
            strings.friendRemoveConfirmationTitle(
                pendingRemovalRelationship?.pilgrim.name ?? ""
            ),
            isPresented: pendingRemovalBinding,
            presenting: pendingRemovalRelationship
        ) { relationship in
            Button(strings.friendCancelAction, role: .cancel) {
                pendingRemovalRelationship = nil
            }

            Button(strings.friendRemoveAction, role: .destructive) {
                Task {
                    await viewModel.remove(relationship.id)
                    pendingRemovalRelationship = nil
                }
            }
        } message: { relationship in
            Text(strings.friendRemoveConfirmationMessage(relationship.pilgrim.name))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.friendsTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(strings.friendsSubtitle)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
    }

    private var overview: some View {
        HStack(spacing: Layout.summarySpacing) {
            summaryCard(
                title: strings.friendsCountTitle,
                value: "\(viewModel.friends.count)",
                accent: Color(red: 0.47, green: 0.73, blue: 0.45)
            )

            summaryCard(
                title: strings.requestsCountTitle,
                value: "\(viewModel.incomingRequests.count)",
                accent: Color(red: 0.96, green: 0.67, blue: 0.33)
            )

            summaryCard(
                title: strings.sentCountTitle,
                value: "\(viewModel.outgoingRequests.count)",
                accent: palette.accent
            )
        }
    }

    private var segmentedControl: some View {
        HStack(spacing: Layout.segmentedSpacing) {
            ForEach(FriendsViewModel.Section.allCases, id: \.self) { section in
                let isSelected = viewModel.selectedSection == section

                Button {
                    withAnimation(.snappy(duration: 0.28, extraBounce: 0.02)) {
                        viewModel.selectedSection = section
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(title(for: section))
                            .font(.system(size: 14, weight: .semibold, design: .rounded))

                        if let badgeValue = badgeValue(for: section) {
                            Text(badgeValue)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(isSelected ? Color.white.opacity(0.18) : palette.surfaceMuted, in: Capsule())
                        }
                    }
                    .foregroundStyle(isSelected ? Color.white : palette.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? palette.accent : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Layout.segmentedPadding)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    @ViewBuilder
    private var sectionContent: some View {
        switch viewModel.selectedSection {
        case .friends:
            friendsList
        case .requests:
            requestsList
        case .discover:
            discoverList
        }
    }

    private var friendsList: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            sectionHeader(
                title: strings.friendsListTitle,
                subtitle: strings.friendsListSubtitle
            )

            if viewModel.friends.isEmpty {
                emptyState(
                    title: strings.friendsEmptyTitle,
                    subtitle: strings.friendsEmptySubtitle,
                    symbolName: "person.2.slash"
                )
            } else {
                LazyVStack(spacing: Layout.cardSpacing) {
                    ForEach(viewModel.friends) { relationship in
                        SwipeRevealCard(
                            actionWidth: Layout.swipeActionWidth,
                            triggerThreshold: Layout.swipeTriggerThreshold,
                            onContentTap: {
                                onFriendSelected(relationship.id)
                            },
                            action: {
                                pendingRemovalRelationship = relationship
                            },
                            actionLabel: {
                                Label(strings.friendRemoveAction, systemImage: "trash")
                            },
                            actionBackground: {
                                RoundedRectangle(
                                    cornerRadius: Layout.cardCornerRadius,
                                    style: .continuous
                                )
                                .fill(Color.red)
                            },
                            content: {
                                compactFriendCard(
                                    relationship: relationship,
                                    tint: Color(red: 0.47, green: 0.73, blue: 0.45)
                                )
                            }
                        )
                    }
                }
            }
        }
    }

    private var requestsList: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            sectionHeader(
                title: strings.requestsListTitle,
                subtitle: strings.requestsListSubtitle
            )

            if viewModel.incomingRequests.isEmpty && viewModel.outgoingRequests.isEmpty {
                emptyState(
                    title: strings.requestsEmptyTitle,
                    subtitle: strings.requestsEmptySubtitle,
                    symbolName: "tray"
                )
            } else {
                if !viewModel.incomingRequests.isEmpty {
                    requestSectionTitle(strings.incomingRequestsTitle)

                    LazyVStack(spacing: Layout.cardSpacing) {
                        ForEach(viewModel.incomingRequests) { relationship in
                            friendCard(
                                relationship: relationship,
                                tint: Color(red: 0.96, green: 0.67, blue: 0.33),
                                footer: {
                                    HStack(spacing: Layout.actionSpacing) {
                                        inlineActionButton(
                                            title: strings.friendDeclineAction,
                                            fill: palette.surfaceMuted,
                                            foreground: palette.textSecondary
                                        ) {
                                            Task {
                                                await viewModel.decline(relationship.id)
                                            }
                                        }

                                        inlineActionButton(
                                            title: strings.friendAcceptAction,
                                            fill: Color(red: 0.96, green: 0.67, blue: 0.33),
                                            foreground: Color.white
                                        ) {
                                            Task {
                                                await viewModel.accept(relationship.id)
                                            }
                                        }
                                    }
                                }
                            )
                        }
                    }
                }

                if !viewModel.outgoingRequests.isEmpty {
                    requestSectionTitle(strings.outgoingRequestsTitle)

                    LazyVStack(spacing: Layout.cardSpacing) {
                        ForEach(viewModel.outgoingRequests) { relationship in
                            friendCard(
                                relationship: relationship,
                                tint: palette.accent,
                                footer: {
                                    HStack(spacing: Layout.actionSpacing) {
                                        statusPill(
                                            title: strings.friendPendingLabel,
                                            symbolName: "clock.fill",
                                            fill: palette.accentSoft,
                                            foreground: palette.accent
                                        )

                                        inlineActionButton(
                                            title: strings.friendCancelAction,
                                            fill: palette.surfaceMuted,
                                            foreground: palette.textSecondary
                                        ) {
                                            Task {
                                                await viewModel.cancel(relationship.id)
                                            }
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    private var discoverList: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            sectionHeader(
                title: strings.discoverListTitle,
                subtitle: strings.discoverListSubtitle
            )

            if viewModel.discoverablePilgrims.isEmpty {
                emptyState(
                    title: strings.discoverEmptyTitle,
                    subtitle: strings.discoverEmptySubtitle,
                    symbolName: "person.crop.circle.badge.plus"
                )
            } else {
                LazyVStack(spacing: Layout.cardSpacing) {
                    ForEach(viewModel.discoverablePilgrims) { relationship in
                        friendCard(
                            relationship: relationship,
                            tint: palette.accent,
                            footer: {
                                inlineActionButton(
                                    title: strings.friendAddAction,
                                    fill: palette.accent,
                                    foreground: .white
                                ) {
                                    Task {
                                        await viewModel.send(relationship.id)
                                    }
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
    }

    private func requestSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(palette.textPrimary)
            .padding(.top, 4)
    }

    private func summaryCard(title: String, value: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: Layout.summaryCardHeight, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(accent.opacity(0.22), lineWidth: 1)
                )
        )
    }

    private func friendCard<Footer: View>(
        relationship: FriendRelationship,
        tint: Color,
        @ViewBuilder footer: () -> Footer
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ProfileAvatarView(
                    initials: relationship.pilgrim.initials,
                    imageData: relationship.pilgrim.avatarImageData,
                    size: Layout.avatarSize,
                    accentColor: tint,
                    backgroundColor: tint.opacity(0.16)
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(relationship.pilgrim.name)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)

                    routeMeta(for: relationship)

                    Text(relationship.pilgrim.bio)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(3)
                }

                Spacer(minLength: 0)
            }

            footer()
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func compactFriendCard(relationship: FriendRelationship, tint: Color) -> some View {
        HStack(alignment: .center, spacing: 14) {
            ProfileAvatarView(
                initials: relationship.pilgrim.initials,
                imageData: relationship.pilgrim.avatarImageData,
                size: Layout.avatarSize,
                accentColor: tint,
                backgroundColor: tint.opacity(0.16)
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(relationship.pilgrim.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    miniMetaPill(
                        title: viewModel.routeName(for: relationship, language: preferences.resolvedLanguage),
                        symbolName: "map.fill"
                    )

                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12, weight: .semibold))

                        Text(relationship.pilgrim.currentCity)
                            .lineLimit(1)
                    }
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func routeMeta(for relationship: FriendRelationship) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                miniMetaPill(
                    title: viewModel.routeName(for: relationship, language: preferences.resolvedLanguage),
                    symbolName: "map.fill"
                )

                miniMetaPill(
                    title: strings.stageValue(relationship.pilgrim.currentStageNumber),
                    symbolName: "figure.walk"
                )
            }

            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 12, weight: .semibold))
                Text(relationship.pilgrim.currentCity)
                    .lineLimit(1)
            }
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(palette.textSecondary)
        }
    }

    private func miniMetaPill(title: String, symbolName: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: symbolName)
                .font(.system(size: 11, weight: .bold))
            Text(title)
                .lineLimit(1)
        }
        .font(.system(size: 12, weight: .semibold, design: .rounded))
        .foregroundStyle(palette.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(palette.surfaceMuted, in: Capsule())
    }

    private func inlineActionButton(
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

    private func statusPill(
        title: String,
        symbolName: String,
        fill: Color,
        foreground: Color
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbolName)
                .font(.system(size: 11, weight: .bold))

            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, Layout.pillHorizontalPadding)
        .padding(.vertical, Layout.pillVerticalPadding)
        .background(fill, in: Capsule())
    }

    private func emptyState(title: String, subtitle: String, symbolName: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: symbolName)
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(palette.accent)
                .frame(width: 52, height: 52)
                .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func title(for section: FriendsViewModel.Section) -> String {
        switch section {
        case .friends:
            strings.friendsSegmentFriends
        case .requests:
            strings.friendsSegmentRequests
        case .discover:
            strings.friendsSegmentDiscover
        }
    }

    private func badgeValue(for section: FriendsViewModel.Section) -> String? {
        switch section {
        case .friends:
            return viewModel.friends.isEmpty ? nil : "\(viewModel.friends.count)"
        case .requests:
            let count = viewModel.incomingRequests.count + viewModel.outgoingRequests.count
            return count == 0 ? nil : "\(count)"
        case .discover:
            return viewModel.discoverablePilgrims.isEmpty ? nil : "\(viewModel.discoverablePilgrims.count)"
        }
    }

    private var pendingRemovalBinding: Binding<Bool> {
        Binding(
            get: { pendingRemovalRelationship != nil },
            set: { isPresented in
                if !isPresented {
                    pendingRemovalRelationship = nil
                }
            }
        )
    }
}

struct FriendProfileDetailScene: View {
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 32
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 24
        static let avatarSize: CGFloat = 86
        static let infoSpacing: CGFloat = 12
        static let menuButtonSize: CGFloat = 36
        static let menuSymbolSize: CGFloat = 16
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(AppPreferencesStore.self) private var preferences

    private let repository: any FriendsRepository
    private let routeRepository: any OfficialRouteRepository
    private let relationshipID: FriendRelationship.ID

    @State private var relationship: FriendRelationship?
    @State private var routesByID: [OfficialRoute.ID: OfficialRoute] = [:]
    @State private var isRemovalConfirmationPresented = false

    init(
        repository: any FriendsRepository,
        routeRepository: any OfficialRouteRepository,
        relationshipID: FriendRelationship.ID
    ) {
        self.repository = repository
        self.routeRepository = routeRepository
        self.relationshipID = relationshipID
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        detailContent
        .background(palette.backgroundMiddle.ignoresSafeArea())
        .navigationTitle(relationship?.pilgrim.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            optionsToolbarItem
        }
        .alert(
            strings.friendRemoveConfirmationTitle(relationship?.pilgrim.name ?? ""),
            isPresented: $isRemovalConfirmationPresented,
            presenting: relationship
        ) { relationship in
            Button(strings.friendCancelAction, role: .cancel) {}

            Button(strings.friendRemoveAction, role: .destructive) {
                Task {
                    await remove(relationship)
                }
            }
        } message: { relationship in
            Text(strings.friendRemoveConfirmationMessage(relationship.pilgrim.name))
        }
        .task {
            await load()
        }
    }

    @ViewBuilder
    private var detailContent: some View {
        if let relationship {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                    header(for: relationship)
                    routeCard(for: relationship)
                    bioCard(for: relationship)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .safeAreaPadding(.top, Layout.topPadding)
                .safeAreaPadding(.bottom, Layout.bottomPadding)
            }
        } else {
            ContentUnavailableView(
                strings.friendsEmptyTitle,
                systemImage: "person.crop.circle.badge.questionmark"
            )
        }
    }

    @ToolbarContentBuilder
    private var optionsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if relationship != nil {
                Menu {
                    Button(role: .destructive) {
                        isRemovalConfirmationPresented = true
                    } label: {
                        Label(strings.friendRemoveAction, systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: Layout.menuSymbolSize, weight: .bold))
                        .foregroundStyle(palette.textPrimary)
                        .frame(width: Layout.menuButtonSize, height: Layout.menuButtonSize)
                        .background(palette.surface, in: Circle())
                }
            }
        }
    }

    private func header(for relationship: FriendRelationship) -> some View {
        VStack(spacing: 12) {
            ProfileAvatarView(
                initials: relationship.pilgrim.initials,
                imageData: relationship.pilgrim.avatarImageData,
                size: Layout.avatarSize,
                accentColor: palette.accent,
                backgroundColor: palette.accentSoft
            )

            VStack(spacing: 4) {
                Text(relationship.pilgrim.name)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
                    .multilineTextAlignment(.center)

                Text(routeName(for: relationship))
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Layout.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func routeCard(for relationship: FriendRelationship) -> some View {
        VStack(alignment: .leading, spacing: Layout.infoSpacing) {
            Text(strings.friendDetailRouteTitle)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            detailRow(
                title: strings.friendDetailRouteTitle,
                value: routeName(for: relationship),
                symbolName: "map.fill"
            )

            detailRow(
                title: strings.friendDetailStageTitle,
                value: strings.stageValue(relationship.pilgrim.currentStageNumber),
                symbolName: "figure.walk"
            )

            detailRow(
                title: strings.friendDetailLocationTitle,
                value: relationship.pilgrim.currentCity,
                symbolName: "mappin.and.ellipse"
            )
        }
        .padding(Layout.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func bioCard(for relationship: FriendRelationship) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(strings.friendDetailBioTitle)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(relationship.pilgrim.bio)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func detailRow(title: String, value: String, symbolName: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbolName)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(palette.accent)
                .frame(width: 30, height: 30)
                .background(palette.accentSoft, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.textSecondary)

                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
            }
        }
    }

    private func routeName(for relationship: FriendRelationship) -> String {
        routesByID[relationship.pilgrim.currentRouteID]?.localizedName(for: preferences.resolvedLanguage) ?? ""
    }

    private func remove(_ relationship: FriendRelationship) async {
        _ = await repository.removeFriend(relationship.id)
        dismiss()
    }

    private func load() async {
        async let relationshipsTask = repository.fetchRelationships()
        async let routesTask = routeRepository.fetchRoutes()

        let relationships = await relationshipsTask
        let routes = await routesTask

        relationship = relationships.first { $0.id == relationshipID }
        routesByID = Dictionary(uniqueKeysWithValues: routes.map { ($0.id, $0) })
    }
}

private struct SwipeRevealCard<Content: View, ActionLabel: View, ActionBackground: View>: View {
    @State private var settledOffset: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0

    let actionWidth: CGFloat
    let triggerThreshold: CGFloat
    let onContentTap: () -> Void
    let action: () -> Void
    @ViewBuilder let actionLabel: () -> ActionLabel
    @ViewBuilder let actionBackground: () -> ActionBackground
    @ViewBuilder let content: () -> Content

    private var totalOffset: CGFloat {
        max(-actionWidth, min(0, settledOffset + dragTranslation))
    }

    private var isActionVisible: Bool {
        abs(totalOffset) > 1
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Button(action: action) {
                actionLabel()
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: actionWidth)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(actionBackground())
            .opacity(isActionVisible ? 1 : 0)
            .allowsHitTesting(isActionVisible)
            .clipped()

            content()
                .contentShape(Rectangle())
                .offset(x: totalOffset)
                .simultaneousGesture(dragGesture)
                .onTapGesture {
                    guard settledOffset == 0 else { return }
                    onContentTap()
                }
                .overlay {
                    if settledOffset != 0 {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.22, extraBounce: 0.0)) {
                                    settledOffset = 0
                                }
                            }
                    }
                }
        }
        .clipped()
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 12, coordinateSpace: .local)
            .onChanged { value in
                let horizontalMovement = abs(value.translation.width)
                let verticalMovement = abs(value.translation.height)

                guard horizontalMovement > verticalMovement else { return }

                if settledOffset == 0 {
                    dragTranslation = min(0, value.translation.width)
                } else {
                    dragTranslation = min(actionWidth, max(-actionWidth, value.translation.width))
                }
            }
            .onEnded { value in
                defer { dragTranslation = 0 }

                let horizontalMovement = abs(value.translation.width)
                let verticalMovement = abs(value.translation.height)

                guard horizontalMovement > verticalMovement else { return }

                let shouldReveal: Bool
                if settledOffset == 0 {
                    shouldReveal = value.translation.width < -triggerThreshold
                } else {
                    shouldReveal = value.translation.width < triggerThreshold
                }

                withAnimation(.snappy(duration: 0.22, extraBounce: 0.0)) {
                    settledOffset = shouldReveal ? -actionWidth : 0
                }
            }
    }
}
