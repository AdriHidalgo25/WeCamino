import SwiftUI

struct AppRootView: View {
    private let dependencies: AppDependencies

    @Namespace private var heroNamespace
    @State private var router: AppRouter

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _router = State(initialValue: AppRouter())
    }

    var body: some View {
        let appRouter = router
        @Bindable var bindableRouter = appRouter

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
    }
}

private struct AppShellView: View {
    let dependencies: AppDependencies
    let heroNamespace: Namespace.ID

    @Bindable var router: AppRouter

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
                Color(red: 0.98, green: 0.98, blue: 0.97),
                Color(red: 0.93, green: 0.96, blue: 1.00),
                Color(red: 0.97, green: 0.95, blue: 0.91)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

private struct AppTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 10) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0.02)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 18, weight: .semibold))

                        Text(tab.title)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.black : Color.black.opacity(0.44))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        Group {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color(red: 0.97, green: 0.99, blue: 1.00))
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.82), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.10), radius: 18, y: 8)
    }
}

private extension AppTab {
    var title: String {
        switch self {
        case .home:
            "Home"
        case .routes:
            "Routes"
        case .settings:
            "Settings"
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
}

private struct SettingsScene: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Settings")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))

                Text("Control your Camino preferences, privacy for manual check-ins and the social experience you want to share.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.56))

                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
                    .frame(height: 220)
                    .overlay(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 18) {
                            Label("Pilgrim profile", systemImage: "person.crop.circle.fill")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))

                            settingRow("Manual location updates", detail: "Only share your latest stop when you decide.")
                            settingRow("Route notifications", detail: "Stay in the loop for route changes and group activity.")
                            settingRow("Design system", detail: "New visual language applied across the app shell.")
                        }
                        .padding(24)
                    }
            }
            .padding(.horizontal, 20)
            .safeAreaPadding(.top, 24)
            .safeAreaPadding(.bottom, 120)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func settingRow(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))

            Text(detail)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.52))
        }
    }
}
