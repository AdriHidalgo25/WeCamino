import SwiftUI

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
                case .settings:
                    SettingsScene()
                }
            }

            AppTabBar(selectedTab: $router.selectedTab)
                .padding(.horizontal, 18)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var shellBackground: some View {
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
    }
}

private struct AppTabBar: View {
    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    @Binding var selectedTab: AppTab

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab

                Button {
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0.02)) {
                        selectedTab = tab
                    }
                } label: {
                    let accent = tab.accentColor

                    HStack(spacing: 10) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(isSelected ? Color.white : palette.textSecondary)
                            .frame(width: 34, height: 34)
                            .background(
                                Circle()
                                    .fill(isSelected ? accent : palette.surfaceMuted)
                            )

                        if isSelected {
                            Text(tab.title(strings: strings))
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(palette.textPrimary)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: isSelected ? .leading : .center)
                    .padding(.horizontal, isSelected ? 14 : 0)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(isSelected ? palette.surface : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(isSelected ? palette.border : Color.clear, lineWidth: 1)
                            )
                    )
                    .shadow(color: isSelected ? palette.shadow.opacity(0.55) : .clear, radius: 10, y: 4)
                }
                .frame(width: isSelected ? nil : 56)
                .frame(maxWidth: isSelected ? .infinity : nil)
                .layoutPriority(isSelected ? 1 : 0)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(tabBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(palette.tabBarStroke, lineWidth: 1)
                )
        )
        .shadow(color: palette.shadow.opacity(0.85), radius: 22, y: 10)
    }

    private var tabBarBackground: some ShapeStyle {
        colorScheme == .dark
            ? AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.10, green: 0.12, blue: 0.16).opacity(0.94),
                        Color(red: 0.13, green: 0.15, blue: 0.19).opacity(0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            : AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.96),
                        Color(red: 0.97, green: 0.98, blue: 1.00).opacity(0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
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
        case .settings:
            Color(red: 0.47, green: 0.73, blue: 0.45)
        }
    }
}
