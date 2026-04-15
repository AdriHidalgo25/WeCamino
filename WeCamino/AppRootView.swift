import SwiftUI

/// Owns the app shell, global preferences and the main navigation stack.
struct AppRootView: View {
    private let dependencies: AppDependencies

    @Namespace private var heroNamespace
    @State private var router: AppRouter
    @State private var preferences: AppPreferencesStore

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _router = State(initialValue: AppRouter())
        _preferences = State(initialValue: dependencies.preferencesStore)
    }

    var body: some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            shellView
                .navigationDestination(for: AppDestination.self, destination: destinationView)
        }
        .environment(preferences)
        .environment(\.appStrings, preferences.strings)
        .environment(\.locale, preferences.locale)
        .preferredColorScheme(preferences.colorScheme)
    }

    private var shellView: some View {
        AppShellView(
            dependencies: dependencies,
            heroNamespace: heroNamespace,
            router: router
        )
    }

    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .routeCatalog:
            RouteCatalogScene(
                repository: dependencies.officialRouteRepository,
                heroNamespace: heroNamespace
            )
        case .routeDetail(let routeID):
            RouteDetailScene(
                repository: dependencies.officialRouteRepository,
                routeID: routeID,
                heroNamespace: heroNamespace
            )
        case .notifications:
            NotificationsScene(
                friendsRepository: dependencies.friendsRepository,
                routeRepository: dependencies.officialRouteRepository
            )
        case .profileEdit:
            EditProfileScene(
                profileRepository: dependencies.userProfileRepository,
                routeRepository: dependencies.officialRouteRepository
            )
        case .friendDetail(let relationshipID):
            FriendProfileDetailScene(
                repository: dependencies.friendsRepository,
                routeRepository: dependencies.officialRouteRepository,
                relationshipID: relationshipID
            )
        }
    }
}

private struct AppShellView: View {
    @Environment(\.colorScheme) private var colorScheme

    let dependencies: AppDependencies
    let heroNamespace: Namespace.ID
    @Bindable var router: AppRouter

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        shellBackground
            .overlay {
                Group {
                    switch router.selectedTab {
                    case .home:
                        WelcomeScene(
                            repository: dependencies.welcomeRepository,
                            navigator: router,
                            heroNamespace: heroNamespace
                        )
                    case .routes:
                        RouteCatalogScene(
                            repository: dependencies.officialRouteRepository,
                            heroNamespace: heroNamespace
                        )
                    case .friends:
                        FriendsScene(
                            repository: dependencies.friendsRepository,
                            routeRepository: dependencies.officialRouteRepository,
                            onFriendSelected: router.showFriendDetail
                        )
                    case .profile:
                        ProfileScene(
                            profileRepository: dependencies.userProfileRepository,
                            routeRepository: dependencies.officialRouteRepository,
                            navigator: router
                        )
                    case .settings:
                        SettingsScene()
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                AppTabBar(selectedTab: $router.selectedTab)
            }
    }

    private var shellBackground: some View {
        palette.backgroundMiddle
        .ignoresSafeArea()
    }
}

private struct AppTabBar: View {
    private enum Layout {
        static let stackSpacing: CGFloat = 6
        static let contentSpacing: CGFloat = 6
        static let iconSize: CGFloat = 15
        static let iconFrame: CGFloat = 20
        static let tabHorizontalPadding: CGFloat = 10
        static let tabVerticalPadding: CGFloat = 10
        static let barHorizontalPadding: CGFloat = 16
        static let barTopPadding: CGFloat = 10
        static let barBottomPadding: CGFloat = 8
        static let titleFontSize: CGFloat = 12
        static let selectedCornerRadius: CGFloat = 14
        static let glassOpacity: CGFloat = 0.78
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    @Binding var selectedTab: AppTab

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(palette.tabBarStroke)
                .frame(height: 1)

            HStack(spacing: Layout.stackSpacing) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    let isSelected = selectedTab == tab

                    Button {
                        withAnimation(.snappy(duration: 0.28, extraBounce: 0.02)) {
                            selectedTab = tab
                        }
                    } label: {
                        let accent = tab.accentColor

                        VStack(spacing: Layout.contentSpacing) {
                            Image(systemName: tab.iconName)
                                .font(.system(size: Layout.iconSize, weight: .semibold))
                                .foregroundStyle(isSelected ? accent : palette.textSecondary)
                                .frame(width: Layout.iconFrame, height: Layout.iconFrame)

                            Text(tab.title(strings: strings))
                                .font(.system(size: Layout.titleFontSize, weight: .semibold, design: .rounded))
                                .foregroundStyle(isSelected ? palette.textPrimary : palette.textSecondary)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, Layout.tabHorizontalPadding)
                        .padding(.vertical, Layout.tabVerticalPadding)
                        .background(
                            RoundedRectangle(
                                cornerRadius: Layout.selectedCornerRadius,
                                style: .continuous
                            )
                            .fill(isSelected ? palette.selectedTabFill : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Layout.barHorizontalPadding)
            .padding(.top, Layout.barTopPadding)
            .padding(.bottom, Layout.barBottomPadding)
        }
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                Rectangle()
                    .fill(palette.surface.opacity(Layout.glassOpacity))
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

private extension AppTab {
    func title(strings: AppStrings) -> String {
        switch self {
        case .home:
            strings.tabHome
        case .routes:
            strings.tabRoutes
        case .friends:
            strings.tabFriends
        case .profile:
            strings.tabProfile
        case .settings:
            strings.tabSettings
        }
    }

    var iconName: String {
        switch self {
        case .home:
            "house.fill"
        case .routes:
            "map"
        case .friends:
            "person.2.fill"
        case .profile:
            "person.crop.circle"
        case .settings:
            "gearshape"
        }
    }

    var accentColor: Color {
        switch self {
        case .home:
            Color(red: 0.99, green: 0.63, blue: 0.24)
        case .routes:
            Color(red: 0.33, green: 0.66, blue: 0.96)
        case .friends:
            Color(red: 0.88, green: 0.52, blue: 0.35)
        case .profile:
            Color(red: 0.47, green: 0.73, blue: 0.45)
        case .settings:
            Color(red: 0.70, green: 0.62, blue: 0.92)
        }
    }
}
