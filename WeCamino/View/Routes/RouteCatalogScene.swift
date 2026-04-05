import SwiftUI

struct RouteCatalogScene: View {
    let heroNamespace: Namespace.ID

    @State private var viewModel: RouteCatalogViewModel
    @State private var hasAnimatedIn = false

    init(
        repository: any OfficialRouteRepository,
        heroNamespace: Namespace.ID
    ) {
        self.heroNamespace = heroNamespace
        _viewModel = State(initialValue: RouteCatalogViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            RouteBackground(style: .sunrise)

            Group {
                if viewModel.isLoading && viewModel.routes.isEmpty {
                    ProgressView("Loading official routes")
                        .tint(.white)
                        .foregroundStyle(.white)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 22) {
                            introCard
                                .navigationTransition(.zoom(sourceID: "welcome.hero.card", in: heroNamespace))
                                .opacity(hasAnimatedIn ? 1 : 0)
                                .offset(y: hasAnimatedIn ? 0 : 24)

                            routeList
                                .opacity(hasAnimatedIn ? 1 : 0)
                                .offset(y: hasAnimatedIn ? 0 : 30)
                                .animation(.smooth(duration: 0.9).delay(0.08), value: hasAnimatedIn)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 28)
                    }
                }
            }
        }
        .navigationTitle("Official Routes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .onAppear {
            guard !hasAnimatedIn else { return }

            withAnimation(.smooth(duration: 0.9)) {
                hasAnimatedIn = true
            }
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Official Camino routes")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("A curated catalog of the official Camino routes most relevant to the pilgrim experience, designed as the knowledge layer for the social network.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.84))

            HStack(spacing: 10) {
                statPill("\(viewModel.routes.count)", label: "Routes")
                statPill("Official", label: "Source")
                statPill("Modern", label: "UI")
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.16), radius: 20, y: 12)
    }

    private var routeList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pick a route to explore")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            ForEach(viewModel.routes) { route in
                NavigationLink(value: AppDestination.routeDetail(route.id)) {
                    routeCard(route)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func routeCard(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle

        return HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(route.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "arrow.up.right.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.92))
                }

                Text(route.shortDescription)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.84))

                HStack(spacing: 10) {
                    routeBadge(route.origin, systemImage: "flag.pattern.checkered")
                    routeBadge(style.mood, systemImage: style.symbol)
                }
            }

            VStack(spacing: 10) {
                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: style.symbol)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                    }

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 52, height: 82)
                    .overlay {
                        Text(style.miniLabel)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(-90))
                    }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: style.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: style.gradient.last?.opacity(0.28) ?? .black.opacity(0.18), radius: 18, y: 12)
        .matchedTransitionSource(id: route.id, in: heroNamespace)
    }

    private func statPill(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.72))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func routeBadge(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.14), in: Capsule())
    }
}

struct RouteBackground: View {
    let style: BackgroundStyle

    enum BackgroundStyle {
        case sunrise
        case atlantic

        var colors: [Color] {
            switch self {
            case .sunrise:
                [
                    Color(red: 0.94, green: 0.46, blue: 0.22),
                    Color(red: 0.96, green: 0.74, blue: 0.22),
                    Color(red: 0.15, green: 0.61, blue: 0.54)
                ]
            case .atlantic:
                [
                    Color(red: 0.04, green: 0.14, blue: 0.19),
                    Color(red: 0.10, green: 0.35, blue: 0.53),
                    Color(red: 0.10, green: 0.56, blue: 0.47)
                ]
            }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: style.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 12)
                .offset(x: 120, y: -250)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 320, height: 320)
                .blur(radius: 20)
                .offset(x: -160, y: 260)
        }
    }
}

struct OfficialRouteVisualStyle {
    let gradient: [Color]
    let symbol: String
    let mood: String
    let miniLabel: String
}

extension OfficialRoute.ID {
    var visualStyle: OfficialRouteVisualStyle {
        switch self {
        case .frances:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.98, green: 0.52, blue: 0.25), Color(red: 0.95, green: 0.70, blue: 0.24)],
                symbol: "sun.max.fill",
                mood: "Classic",
                miniLabel: "FR"
            )
        case .norte:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.09, green: 0.31, blue: 0.53), Color(red: 0.12, green: 0.58, blue: 0.64)],
                symbol: "water.waves",
                mood: "Atlantic",
                miniLabel: "NO"
            )
        case .primitivo:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.24, green: 0.33, blue: 0.20), Color(red: 0.48, green: 0.62, blue: 0.25)],
                symbol: "mountain.2.fill",
                mood: "Oldest",
                miniLabel: "PR"
            )
        case .ingles:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.36, green: 0.28, blue: 0.70), Color(red: 0.60, green: 0.44, blue: 0.92)],
                symbol: "ferry.fill",
                mood: "Maritime",
                miniLabel: "IN"
            )
        case .portugues:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.83, green: 0.20, blue: 0.28), Color(red: 0.94, green: 0.46, blue: 0.35)],
                symbol: "figure.walk",
                mood: "Popular",
                miniLabel: "PT"
            )
        case .portuguesCoastal:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.05, green: 0.51, blue: 0.69), Color(red: 0.20, green: 0.76, blue: 0.67)],
                symbol: "sailboat.fill",
                mood: "Coastal",
                miniLabel: "PC"
            )
        case .viaDeLaPlata:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.60, green: 0.32, blue: 0.15), Color(red: 0.85, green: 0.55, blue: 0.21)],
                symbol: "road.lanes",
                mood: "Southern",
                miniLabel: "VP"
            )
        case .invierno:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.22, green: 0.30, blue: 0.48), Color(red: 0.40, green: 0.55, blue: 0.78)],
                symbol: "snowflake",
                mood: "Alternative",
                miniLabel: "IV"
            )
        case .fisterraMuxia:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.11, green: 0.20, blue: 0.33), Color(red: 0.16, green: 0.43, blue: 0.62)],
                symbol: "sparkles",
                mood: "Atlantic end",
                miniLabel: "FM"
            )
        case .arousaUlla:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.12, green: 0.48, blue: 0.53), Color(red: 0.16, green: 0.72, blue: 0.57)],
                symbol: "drop.fill",
                mood: "Maritime",
                miniLabel: "AU"
            )
        }
    }
}
