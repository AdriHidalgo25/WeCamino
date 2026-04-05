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
            routeCatalogBackground

            Group {
                if viewModel.isLoading && viewModel.routes.isEmpty {
                    ProgressView("Loading routes")
                        .tint(Color(red: 0.08, green: 0.11, blue: 0.16))
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            routeStats
                                .opacity(hasAnimatedIn ? 1 : 0)
                                .offset(y: hasAnimatedIn ? 0 : 14)
                                .animation(.smooth(duration: 0.8).delay(0.04), value: hasAnimatedIn)

                            routeList
                                .opacity(hasAnimatedIn ? 1 : 0)
                                .offset(y: hasAnimatedIn ? 0 : 20)
                                .animation(.smooth(duration: 0.8).delay(0.1), value: hasAnimatedIn)
                        }
                        .padding(.horizontal, 20)
                        .safeAreaPadding(.top, 24)
                        .safeAreaPadding(.bottom, 112)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .onAppear {
            guard !hasAnimatedIn else { return }

            withAnimation(.smooth(duration: 0.85)) {
                hasAnimatedIn = true
            }
        }
    }

    private var routeCatalogBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 0.97),
                    Color(red: 0.94, green: 0.97, blue: 1.00),
                    Color(red: 0.98, green: 0.95, blue: 0.91)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: 280, height: 280)
                .blur(radius: 26)
                .offset(x: 140, y: -280)
        }
    }

    private var routeStats: some View {
        HStack(spacing: 12) {
            statTile(title: "Routes", value: "\(viewModel.routes.count)", tint: Color(red: 0.86, green: 0.96, blue: 0.84))
            statTile(title: "Source", value: "Official", tint: Color(red: 1.00, green: 0.94, blue: 0.84))
            statTile(title: "Layers", value: "Stages", tint: Color(red: 0.85, green: 0.93, blue: 1.00))
        }
    }

    private var routeList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse routes")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            ForEach(viewModel.routes) { route in
                NavigationLink(value: AppDestination.routeDetail(route.id)) {
                    routeCard(route)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func statTile(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.54))

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(tint)
        )
    }

    private func routeCard(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle

        return VStack(alignment: .leading, spacing: 16) {
            RouteLandscapeArt(style: style)
                .frame(height: 160)

            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(route.name)
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                    Text(route.shortDescription)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.56))
                        .lineLimit(2)
                }

                Spacer(minLength: 10)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
                    .frame(width: 42, height: 42)
                    .background(Color(red: 1.00, green: 0.95, blue: 0.87), in: Circle())
            }

            HStack(spacing: 10) {
                routeBadge(style.mood, systemImage: style.symbol, tint: style.gradient.first ?? .orange)
                routeBadge("\(route.stages.count) stages", systemImage: "point.topleft.down.curvedto.point.bottomright.up", tint: Color(red: 0.56, green: 0.79, blue: 0.41))

                Spacer()

                Text(style.miniLabel)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.6))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.05), in: Capsule())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 16, y: 8)
        .matchedTransitionSource(id: route.id, in: heroNamespace)
    }

    private func routeBadge(_ text: String, systemImage: String, tint: Color) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(tint.opacity(0.18), in: Capsule())
    }
}

private struct RouteLandscapeArt: View {
    let style: OfficialRouteVisualStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: style.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Capsule()
                .fill(Color.white.opacity(0.88))
                .frame(width: 76, height: 20)
                .offset(x: 78, y: -48)

            Circle()
                .fill(Color(red: 1.00, green: 0.80, blue: 0.36).opacity(0.92))
                .frame(width: 46, height: 46)
                .offset(x: 94, y: 26)

            MountainShape()
                .fill(Color.white.opacity(0.24))
                .frame(height: 60)
                .offset(y: 26)

            PathShape()
                .fill(Color(red: 0.97, green: 0.92, blue: 0.78))
                .frame(width: 118, height: 50)
                .offset(x: 22, y: 50)

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(style.mood)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.82))

                    Image(systemName: style.symbol)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                }

                Spacer()
            }
            .padding(18)

            Rectangle()
                .fill(Color(red: 0.47, green: 0.28, blue: 0.18))
                .frame(height: 22)
                .offset(y: 69)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
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
                gradient: [Color(red: 0.40, green: 0.72, blue: 1.00), Color(red: 0.98, green: 0.75, blue: 0.36)],
                symbol: "sun.max.fill",
                mood: "Classic",
                miniLabel: "FR"
            )
        case .norte:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.33, green: 0.76, blue: 0.97), Color(red: 0.21, green: 0.58, blue: 0.84)],
                symbol: "water.waves",
                mood: "Atlantic",
                miniLabel: "NO"
            )
        case .primitivo:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.53, green: 0.77, blue: 0.42), Color(red: 0.28, green: 0.56, blue: 0.28)],
                symbol: "mountain.2.fill",
                mood: "Oldest",
                miniLabel: "PR"
            )
        case .ingles:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.53, green: 0.77, blue: 0.98), Color(red: 0.88, green: 0.95, blue: 1.00)],
                symbol: "ferry.fill",
                mood: "Maritime",
                miniLabel: "IN"
            )
        case .portugues:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.99, green: 0.54, blue: 0.44), Color(red: 0.98, green: 0.77, blue: 0.48)],
                symbol: "figure.walk",
                mood: "Popular",
                miniLabel: "PT"
            )
        case .portuguesCoastal:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.31, green: 0.78, blue: 0.84), Color(red: 0.61, green: 0.90, blue: 0.70)],
                symbol: "sailboat.fill",
                mood: "Coastal",
                miniLabel: "PC"
            )
        case .viaDeLaPlata:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.95, green: 0.67, blue: 0.31), Color(red: 0.78, green: 0.49, blue: 0.24)],
                symbol: "road.lanes",
                mood: "Southern",
                miniLabel: "VP"
            )
        case .invierno:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.67, green: 0.74, blue: 0.98), Color(red: 0.48, green: 0.58, blue: 0.86)],
                symbol: "snowflake",
                mood: "Alternative",
                miniLabel: "IV"
            )
        case .fisterraMuxia:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.32, green: 0.56, blue: 0.88), Color(red: 0.15, green: 0.31, blue: 0.53)],
                symbol: "sparkles",
                mood: "Atlantic end",
                miniLabel: "FM"
            )
        case .arousaUlla:
            OfficialRouteVisualStyle(
                gradient: [Color(red: 0.36, green: 0.84, blue: 0.78), Color(red: 0.16, green: 0.63, blue: 0.59)],
                symbol: "drop.fill",
                mood: "River-sea",
                miniLabel: "AU"
            )
        }
    }
}

private struct MountainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.width * 0.32, y: rect.height * 0.55))
        path.addLine(to: CGPoint(x: rect.width * 0.52, y: rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.width * 0.68, y: rect.height * 0.46))
        path.addLine(to: CGPoint(x: rect.width * 0.86, y: rect.height * 0.24))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct PathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.62, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.36, y: rect.height * 0.18),
            control: CGPoint(x: rect.width * 0.80, y: rect.height * 0.54)
        )
        path.addLine(to: CGPoint(x: rect.width * 0.22, y: rect.height * 0.18))
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.40, y: rect.maxY),
            control: CGPoint(x: rect.width * 0.06, y: rect.height * 0.58)
        )
        path.closeSubpath()
        return path
    }
}

private struct PilgrimShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.width * 0.28, y: 0, width: rect.width * 0.28, height: rect.height * 0.22))
        path.move(to: CGPoint(x: rect.width * 0.16, y: rect.height * 0.36))
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.62, y: rect.height * 0.34),
            control: CGPoint(x: rect.width * 0.44, y: rect.height * 0.16)
        )
        path.addLine(to: CGPoint(x: rect.width * 0.70, y: rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.width * 0.54, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.36, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.74))
        path.addLine(to: CGPoint(x: rect.width * 0.04, y: rect.height * 0.86))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.74))
        path.addLine(to: CGPoint(x: rect.width * 0.20, y: rect.height * 0.62))
        path.closeSubpath()
        return path
    }
}

private struct PilgrimAccentShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.width * 0.82, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.78))
        path.addLine(to: CGPoint(x: rect.width * 0.54, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.40))
        path.closeSubpath()
        return path
    }
}

private struct DroneShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - 14, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX + 14, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.midY - 8))
        path.addLine(to: CGPoint(x: rect.width * 0.06, y: rect.height * 0.18))
        path.move(to: CGPoint(x: rect.midX + 20, y: rect.midY - 8))
        path.addLine(to: CGPoint(x: rect.width * 0.94, y: rect.height * 0.18))
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.midY + 8))
        path.addLine(to: CGPoint(x: rect.width * 0.10, y: rect.height * 0.88))
        path.move(to: CGPoint(x: rect.midX + 20, y: rect.midY + 8))
        path.addLine(to: CGPoint(x: rect.width * 0.90, y: rect.height * 0.88))
        return path
    }
}
