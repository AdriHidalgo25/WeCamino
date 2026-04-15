import SwiftUI

private enum WelcomeLayout {
    static let horizontalPadding: CGFloat = 20
    static let topSafeAreaPadding: CGFloat = 16
    static let bottomSafeAreaPadding: CGFloat = 112
    static let contentSpacing: CGFloat = 24
    static let contentVerticalPadding: CGFloat = 6

    static let heroPadding: CGFloat = 20
    static let heroCornerRadius: CGFloat = 20
    static let featuredCardPadding: CGFloat = 14
    static let featuredCardCornerRadius: CGFloat = 18
    static let featuredCardSpacing: CGFloat = 14
    static let featuredThumbnailSize: CGFloat = 92

    static let miniLandscapeCornerRadius: CGFloat = 22
    static let miniLandscapeOrbSize: CGFloat = 52
    static let miniLandscapeOrbOffset = CGSize(width: 24, height: -18)
    static let miniLandscapeSymbolSize: CGFloat = 28

    static let notificationButtonSize: CGFloat = 44
    static let notificationContainerSize = CGSize(width: 52, height: 52)
    static let notificationBadgeMinSize: CGFloat = 20
    static let notificationBadgePadding = CGSize(width: 4, height: 4)
}

/// Home surface focused on quick route discovery and future social entry points.
struct WelcomeView: View {
    // MARK: - Environment

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage(NotificationStorageKey.pendingFriendRequests) private var pendingNotificationCount = 0

    let heroNamespace: Namespace.ID

    // MARK: - State

    @Bindable var viewModel: WelcomeViewModel
    @State private var hasAnimatedIn = false

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            homeBackground

            Group {
                if let content = viewModel.content {
                    loadedState(content: content)
                } else if viewModel.isLoading {
                    ProgressView(strings.homeLoading)
                        .tint(palette.textPrimary)
                } else {
                    ContentUnavailableView(
                        strings.homeUnavailable,
                        systemImage: "exclamationmark.triangle"
                    )
                }
            }
            .padding(.horizontal, WelcomeLayout.horizontalPadding)
            .safeAreaPadding(.top, WelcomeLayout.topSafeAreaPadding)
            .safeAreaPadding(.bottom, WelcomeLayout.bottomSafeAreaPadding)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            guard !hasAnimatedIn else { return }

            withAnimation(.smooth(duration: 0.85)) {
                hasAnimatedIn = true
            }
        }
    }

    // MARK: - Background

    private var homeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    palette.backgroundTop,
                    palette.backgroundMiddle,
                    palette.backgroundBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(palette.glowPrimary)
                .frame(width: 280, height: 280)
                .blur(radius: 24)
                .offset(x: 110, y: -300)

            Circle()
                .fill(palette.glowSecondary)
                .frame(width: 320, height: 320)
                .blur(radius: 36)
                .offset(x: -150, y: -120)
        }
    }

    // MARK: - Loaded Content

    @ViewBuilder
    private func loadedState(content: WelcomeContent) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: WelcomeLayout.contentSpacing) {
                header
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 12)

                heroCard(content: content)
                    .matchedTransitionSource(id: "welcome.hero.card", in: heroNamespace)
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 16)

                quickActions
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 20)
                    .animation(.smooth(duration: 0.55).delay(0.06), value: hasAnimatedIn)

                featuredRoutes
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 24)
                    .animation(.smooth(duration: 0.55).delay(0.1), value: hasAnimatedIn)
            }
            .padding(.vertical, WelcomeLayout.contentVerticalPadding)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Label {
                Text("WeCamino")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            } icon: {
                Image(systemName: "figure.hiking.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(palette.accent)
            }
            .foregroundStyle(palette.textPrimary)

            Spacer()

            Button(action: viewModel.notificationsTapped) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: pendingNotificationCount == 0 ? "bell" : "bell.badge.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)
                        .frame(
                            width: WelcomeLayout.notificationButtonSize,
                            height: WelcomeLayout.notificationButtonSize
                        )
                        .background(palette.surfaceMuted, in: Circle())

                    if pendingNotificationCount > 0 {
                        Text("\(min(pendingNotificationCount, 9))")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(
                                minWidth: WelcomeLayout.notificationBadgeMinSize,
                                minHeight: WelcomeLayout.notificationBadgeMinSize
                            )
                            .background(Color.red, in: Capsule())
                            .padding(.top, WelcomeLayout.notificationBadgePadding.height)
                            .padding(.trailing, WelcomeLayout.notificationBadgePadding.width)
                    }
                }
                .frame(
                    width: WelcomeLayout.notificationContainerSize.width,
                    height: WelcomeLayout.notificationContainerSize.height
                )
            }
            .accessibilityLabel(strings.notificationsTitle)
            .accessibilityValue("\(pendingNotificationCount)")
            .buttonStyle(.plain)
        }
    }

    // MARK: - Hero

    private func heroCard(content: WelcomeContent) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("WeCamino")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            Text(content.title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(content.message)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            Divider()

            Button(action: viewModel.primaryActionTapped) {
                HStack {
                    Text(content.primaryActionTitle)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(palette.textPrimary)
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
        .padding(WelcomeLayout.heroPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: WelcomeLayout.heroCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: WelcomeLayout.heroCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    // MARK: - Quick Actions

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(strings.quickActionsTitle.uppercased())
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            quickActionCard(
                title: strings.exploreRoutesTitle,
                subtitle: strings.exploreRoutesSubtitle,
                systemImage: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                accent: Color(red: 0.98, green: 0.66, blue: 0.18)
            )

            quickActionCard(
                title: strings.groupsSoonTitle,
                subtitle: strings.groupsSoonSubtitle,
                systemImage: "person.3.fill",
                accent: Color(red: 0.56, green: 0.78, blue: 0.40)
            )
        }
    }

    // MARK: - Featured Routes

    private var featuredRoutes: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(strings.featuredRoutesTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Spacer()

                Button(action: viewModel.primaryActionTapped) {
                    Text(strings.seeAll)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.accent)
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 12) {
                    featuredRouteCard(
                        title: "Camino Frances",
                        subtitle: strings.featuredFrancesSubtitle,
                        systemImage: "sun.max.fill",
                        colors: [Color(red: 0.40, green: 0.73, blue: 0.99), Color(red: 0.99, green: 0.84, blue: 0.48)]
                    )

                    featuredRouteCard(
                        title: "Camino del Norte",
                        subtitle: strings.featuredNorteSubtitle,
                        systemImage: "water.waves",
                        colors: [Color(red: 0.47, green: 0.84, blue: 0.98), Color(red: 0.31, green: 0.64, blue: 0.86)]
                    )
            }
        }
    }

    // MARK: - Components

    private func quickActionCard(
        title: String,
        subtitle: String,
        systemImage: String,
        accent: Color
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 40, height: 40)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(palette.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func featuredRouteCard(
        title: String,
        subtitle: String,
        systemImage: String,
        colors: [Color]
    ) -> some View {
        HStack(alignment: .top, spacing: WelcomeLayout.featuredCardSpacing) {
            MiniLandscapeCard(systemImage: systemImage, colors: colors)
                .frame(width: WelcomeLayout.featuredThumbnailSize, height: WelcomeLayout.featuredThumbnailSize)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(WelcomeLayout.featuredCardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: WelcomeLayout.featuredCardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: WelcomeLayout.featuredCardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }
}

/// Decorative SF Symbols-based route thumbnail used by Home cards.
private struct MiniLandscapeCard: View {
    let systemImage: String
    let colors: [Color]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: WelcomeLayout.miniLandscapeCornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.white.opacity(0.14))
                .frame(width: WelcomeLayout.miniLandscapeOrbSize, height: WelcomeLayout.miniLandscapeOrbSize)
                .offset(
                    x: WelcomeLayout.miniLandscapeOrbOffset.width,
                    y: WelcomeLayout.miniLandscapeOrbOffset.height
                )

            Image(systemName: systemImage)
                .font(.system(size: WelcomeLayout.miniLandscapeSymbolSize, weight: .bold))
                .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: WelcomeLayout.miniLandscapeCornerRadius, style: .continuous))
    }
}

#if DEBUG
// MARK: - Previews

private struct WelcomeViewPreview: View {
    @Namespace private var heroNamespace
    @State private var viewModel = WelcomeViewModel(
        repository: LocalWelcomeRepository(),
        navigator: PreviewWelcomeViewRouter()
    )

    var body: some View {
        WelcomeView(
            heroNamespace: heroNamespace,
            viewModel: viewModel
        )
        .task {
            await viewModel.loadIfNeeded(for: .spanish)
        }
        .weCaminoPreviewEnvironment()
    }
}

@MainActor
private final class PreviewWelcomeViewRouter: WelcomeRouting {
    func showRouteCatalog() {}
    func showNotifications() {}
}

#Preview("Welcome View") {
    WelcomeViewPreview()
}
#endif
