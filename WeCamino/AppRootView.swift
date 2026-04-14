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
        let appRouter = router
        let appPreferences = preferences
        @Bindable var bindableRouter = appRouter
        let strings = appPreferences.strings

        NavigationStack(path: $bindableRouter.path) {
            AppShellView(
                dependencies: dependencies,
                heroNamespace: heroNamespace,
                router: appRouter
            )
            .navigationDestination(for: AppDestination.self) { destination in
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
                case .profileEdit:
                    EditProfileScene(
                        profileRepository: dependencies.userProfileRepository,
                        routeRepository: dependencies.officialRouteRepository
                    )
                }
            }
        }
        .environment(appPreferences)
        .environment(\.appStrings, strings)
        .environment(\.locale, appPreferences.locale)
        .preferredColorScheme(appPreferences.colorScheme)
    }
}

private struct AppShellView: View {
    private enum Layout {
        static let tabBarHorizontalPadding: CGFloat = 18
        static let tabBarBottomPadding: CGFloat = 9
    }

    @Environment(\.colorScheme) private var colorScheme

    let dependencies: AppDependencies
    let heroNamespace: Namespace.ID

    @Bindable var router: AppRouter

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            shellBackground

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

            AppTabBar(selectedTab: $router.selectedTab)
                .padding(.horizontal, Layout.tabBarHorizontalPadding)
                .padding(.bottom, Layout.tabBarBottomPadding)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var shellBackground: some View {
        palette.backgroundMiddle
        .ignoresSafeArea()
    }
}

private struct AppTabBar: View {
    private enum Layout {
        static let stackSpacing: CGFloat = 6
        static let contentSpacing: CGFloat = 8
        static let iconSize: CGFloat = 15
        static let iconFrame: CGFloat = 20
        static let selectedHorizontalPadding: CGFloat = 12
        static let defaultHorizontalPadding: CGFloat = 10
        static let verticalPadding: CGFloat = 9
        static let barHorizontalPadding: CGFloat = 8
        static let barVerticalPadding: CGFloat = 8
        static let compactTabWidth: CGFloat = 64
        static let shadowRadius: CGFloat = 8
        static let shadowYOffset: CGFloat = 2
        static let shadowOpacity: CGFloat = 0.22
        static let titleFontSize: CGFloat = 13
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    @Binding var selectedTab: AppTab

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        HStack(spacing: Layout.stackSpacing) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab

                Button {
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0.02)) {
                        selectedTab = tab
                    }
                } label: {
                    let accent = tab.accentColor

                    HStack(spacing: Layout.contentSpacing) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: Layout.iconSize, weight: .medium))
                            .foregroundStyle(isSelected ? accent : palette.textSecondary)
                            .frame(width: Layout.iconFrame, height: Layout.iconFrame)

                        if isSelected {
                            Text(tab.title(strings: strings))
                                .font(.system(size: Layout.titleFontSize, weight: .semibold, design: .rounded))
                                .foregroundStyle(palette.textPrimary)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: isSelected ? .leading : .center)
                    .padding(.horizontal, isSelected ? Layout.selectedHorizontalPadding : Layout.defaultHorizontalPadding)
                    .padding(.vertical, Layout.verticalPadding)
                    .background(
                        Capsule(style: .continuous)
                            .fill(isSelected ? palette.selectedTabFill : Color.clear)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(isSelected ? palette.border : Color.clear, lineWidth: 1)
                            )
                    )
                }
                .frame(width: isSelected ? nil : Layout.compactTabWidth)
                .frame(maxWidth: isSelected ? .infinity : nil)
                .layoutPriority(isSelected ? 1 : 0)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Layout.barHorizontalPadding)
        .padding(.vertical, Layout.barVerticalPadding)
        .background(
            Capsule(style: .continuous)
                .fill(palette.surface)
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(palette.tabBarStroke, lineWidth: 1)
                )
        )
        .shadow(
            color: palette.shadow.opacity(Layout.shadowOpacity),
            radius: Layout.shadowRadius,
            y: Layout.shadowYOffset
        )
    }
}

private extension AppTab {
    func title(strings: AppStrings) -> String {
        switch self {
        case .home:
            strings.tabHome
        case .routes:
            strings.tabRoutes
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
        case .profile:
            Color(red: 0.47, green: 0.73, blue: 0.45)
        case .settings:
            Color(red: 0.70, green: 0.62, blue: 0.92)
        }
    }
}
