import SwiftUI
import MapKit

struct RouteDetailScene: View {
    let routeID: OfficialRoute.ID
    let heroNamespace: Namespace.ID

    @State private var viewModel: RouteDetailViewModel
    @State private var hasExpandedHero = false
    @State private var mapPosition: MapCameraPosition = .automatic

    init(
        repository: any OfficialRouteRepository,
        routeID: OfficialRoute.ID,
        heroNamespace: Namespace.ID
    ) {
        self.routeID = routeID
        self.heroNamespace = heroNamespace
        _viewModel = State(
            initialValue: RouteDetailViewModel(
                repository: repository,
                routeID: routeID
            )
        )
    }

    var body: some View {
        ZStack {
            routeDetailBackground

            Group {
                if let route = viewModel.route {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 22) {
                            heroCard(route)

                            detailSection(
                                title: "Origin",
                                body: route.origin
                            )

                            detailSection(
                                title: "Route character",
                                body: route.terrain
                            )

                            detailSection(
                                title: "Why it matters",
                                body: route.officialContext
                            )

                            routeHighlightsSection

                            routeMapSection(route)

                            stagesSection(route)
                        }
                        .padding(.horizontal, 20)
                        .safeAreaPadding(.top, 16)
                        .safeAreaPadding(.bottom, 36)
                    }
                } else if viewModel.isLoading {
                    ProgressView("Loading route")
                        .tint(Color(red: 0.08, green: 0.11, blue: 0.16))
                        .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
                        .safeAreaPadding(.top, 12)
                } else {
                    ContentUnavailableView(
                        "Route unavailable",
                        systemImage: "map",
                        description: Text("We could not load this official route.")
                    )
                }
            }
        }
        .navigationTitle("Route")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTransition(.zoom(sourceID: routeID, in: heroNamespace))
        .task {
            await loadRouteAndAnimateHero()
        }
    }

    private var routeDetailBackground: some View {
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
                .fill(Color.white.opacity(0.82))
                .frame(width: 280, height: 280)
                .blur(radius: 28)
                .offset(x: 128, y: -280)

            Circle()
                .fill(Color(red: 0.82, green: 0.93, blue: 1.00).opacity(0.56))
                .frame(width: 320, height: 320)
                .blur(radius: 40)
                .offset(x: -150, y: -80)
        }
    }

    private func heroCard(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle
        return VStack(alignment: .leading, spacing: 18) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: style.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Circle()
                    .fill(Color.white.opacity(0.86))
                    .frame(width: 92, height: 92)
                    .blur(radius: 8)
                    .offset(x: 208, y: 18)

                Capsule()
                    .fill(Color.white.opacity(0.88))
                    .frame(width: 86, height: 22)
                    .offset(x: 34, y: 28)

                Circle()
                    .fill(Color(red: 1.00, green: 0.78, blue: 0.38))
                    .frame(width: 52, height: 52)
                    .offset(x: 214, y: 126)

                PathShape()
                    .fill(Color(red: 0.97, green: 0.91, blue: 0.73))
                    .frame(width: 140, height: 58)
                    .offset(x: 48, y: 134)

                MountainShape()
                    .fill(Color.white.opacity(0.26))
                    .frame(height: 72)
                    .offset(y: 92)

                HStack(alignment: .top) {
                    routeIcon(style: style)
                    Spacer()
                    RouteHeroPreview(stop: route.heroStop)
                        .frame(width: 164, height: hasExpandedHero ? 126 : 112)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.white.opacity(0.28), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 14, y: 8)
                        .scaleEffect(hasExpandedHero ? 1 : 0.94)
                        .animation(.snappy(duration: 0.55, extraBounce: 0.03), value: hasExpandedHero)
                }
                .padding(18)
            }
            .frame(height: 226)

            VStack(alignment: .leading, spacing: 12) {
                Text(route.name)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                Text(route.shortDescription)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.56))
                    .lineLimit(3)

                routeMetaRow(route: route, style: style)
                    .opacity(hasExpandedHero ? 1 : 0.88)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(Color.white.opacity(0.98))
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.08), radius: 20, y: 10)
        .opacity(hasExpandedHero ? 1 : 0.96)
        .scaleEffect(hasExpandedHero ? 1 : 0.98)
    }

    private func routeMapSection(_ route: OfficialRoute) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            routeMapHeader(route)
            routeMapCard
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 14, y: 8)
    }

    private var routeHighlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Real highlights")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                Spacer()

                Text("\(min(viewModel.routeStops.count, 4)) spots")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(red: 1.00, green: 0.94, blue: 0.84), in: Capsule())
            }

            if viewModel.routeStops.isEmpty, viewModel.isResolvingRouteStops {
                ProgressView("Loading imagery")
                    .tint(Color(red: 0.08, green: 0.11, blue: 0.16))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(Array(viewModel.routeStops.prefix(4))) { stop in
                            RouteHighlightCard(stop: stop)
                        }
                    }
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 14, y: 8)
    }

    private func routeMapHeader(_ route: OfficialRoute) -> some View {
        HStack {
            Text("Route map")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            Spacer()

            Text("\(route.stops.count) stops")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 1.00, green: 0.94, blue: 0.84), in: Capsule())
        }
    }

    private var routeMapCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(red: 0.96, green: 0.98, blue: 1.00))

            routeMapContent
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var routeMapContent: some View {
        if !viewModel.routeStops.isEmpty {
            routeMapView
        } else if viewModel.isResolvingRouteStops {
            ProgressView("Loading route map")
                .tint(Color(red: 0.08, green: 0.11, blue: 0.16))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
        } else {
            ContentUnavailableView(
                "Map unavailable",
                systemImage: "map",
                description: Text("We could not resolve the stage stops for this route.")
            )
        }
    }

    private var routeMapView: some View {
        Map(position: $mapPosition) {
            routeMapElements
        }
        .mapStyle(.standard(elevation: .realistic))
    }

    @MapContentBuilder
    private var routeMapElements: some MapContent {
        ForEach(viewModel.routeStops) { stop in
            Annotation(stop.stop.name, coordinate: stop.coordinate) {
                routeMarker(for: stop)
            }
        }

        if viewModel.routeStops.count > 1 {
            MapPolyline(coordinates: viewModel.routeStops.map(\.coordinate))
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color(red: 1.0, green: 0.84, blue: 0.42)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
        }
    }

    private func routeMarker(for stop: RouteStopAnnotation) -> some View {
        VStack(spacing: 6) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.95, green: 0.54, blue: 0.20))
                .background(Color.white, in: Circle())

            Text(stop.stop.name)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.94), in: Capsule())
        }
    }

    private func stagesSection(_ route: OfficialRoute) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Stages")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                    Text("\(route.stages.count) stages · \(route.totalDistanceKilometers.formatted(.number.precision(.fractionLength(1)))) km")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.56))
                }

                Spacer()
            }

            ForEach(Array(route.stages.enumerated()), id: \.element.id) { index, stage in
                stageRow(
                    index: index + 1,
                    stage: stage
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 14, y: 8)
    }

    private func detailSection(
        title: String,
        body: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            Text(body)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.56))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, y: 6)
    }

    private func routeIcon(style: OfficialRouteVisualStyle) -> some View {
        Image(systemName: style.symbol)
            .font(.system(size: hasExpandedHero ? 32 : 26, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: hasExpandedHero ? 72 : 58, height: hasExpandedHero ? 72 : 58)
            .background(Color.black.opacity(0.14), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func routeMetaRow(
        route: OfficialRoute,
        style: OfficialRouteVisualStyle
    ) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 10) {
                routeMetaPill(style.mood, systemImage: style.symbol)
                routeMetaPill(route.origin, systemImage: "flag.pattern.checkered")
            }

            VStack(alignment: .leading, spacing: 8) {
                routeMetaPill(style.mood, systemImage: style.symbol)
                routeMetaPill(route.origin, systemImage: "flag.pattern.checkered")
            }
        }
    }

    private func routeMetaPill(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.05), in: Capsule())
    }

    private func stageRow(
        index: Int,
        stage: OfficialRoute.Stage
    ) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text("\(index)")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
                .frame(width: 34, height: 34)
                .background(Color(red: 1.00, green: 0.94, blue: 0.84), in: Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text("\(stage.start.name) -> \(stage.end.name)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                Text(stage.mode == .maritime ? "Maritime segment" : "Walking stage")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.54))
            }

            Spacer()

            Text("\(stage.distanceKilometers.formatted(.number.precision(.fractionLength(1)))) km")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 1.00, green: 0.94, blue: 0.84), in: Capsule())
        }
        .padding(18)
        .background(Color(red: 0.98, green: 0.98, blue: 0.97), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func loadRouteAndAnimateHero() async {
        hasExpandedHero = false
        await viewModel.loadIfNeeded()
        await viewModel.loadRouteStopsIfNeeded()

        guard viewModel.route != nil else { return }

        if let routeMapRect = viewModel.routeMapRect {
            mapPosition = .rect(routeMapRect)
        }

        try? await Task.sleep(for: .milliseconds(180))

        withAnimation(.snappy(duration: 0.6, extraBounce: 0.02)) {
            hasExpandedHero = true
        }
    }
}

private struct RouteHeroPreview: View {
    let stop: OfficialRoute.Stop?

    @State private var scene: MKLookAroundScene?
    @State private var isLoading = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.11, green: 0.29, blue: 0.39),
                            Color(red: 0.13, green: 0.51, blue: 0.47)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            if let scene {
                LookAroundPreview(scene: .constant(scene), allowsNavigation: false)
                    .allowsHitTesting(false)
            } else if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "camera.macro")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white.opacity(0.92))

                    Text(stop?.name ?? "Camino view")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .padding(16)
            }

            LinearGradient(
                colors: [
                    .clear,
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Real scenery")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))

                Text(stop?.name ?? "Stage stop")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(14)
        }
        .task {
            await loadLookAroundSceneIfNeeded()
        }
    }

    private func loadLookAroundSceneIfNeeded() async {
        guard scene == nil, !isLoading, let coordinate = stop?.coordinate else { return }

        isLoading = true

        let request = MKLookAroundSceneRequest(
            coordinate: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        scene = try? await request.scene

        isLoading = false
    }
}

private struct RouteHighlightCard: View {
    let stop: RouteStopAnnotation

    @State private var scene: MKLookAroundScene?
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.30, blue: 0.40),
                                Color(red: 0.16, green: 0.56, blue: 0.47)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                if let scene {
                    LookAroundPreview(scene: .constant(scene), allowsNavigation: false)
                        .allowsHitTesting(false)
                } else if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9))

                        Text(stop.stop.name)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                    }
                }
            }
            .frame(width: 220, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )

            Text(stop.stop.name)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
                .lineLimit(2)

            Text("Stage stop")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.54))
        }
        .frame(width: 220, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.99, green: 0.99, blue: 0.98))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .task {
            await loadLookAroundSceneIfNeeded()
        }
    }

    private func loadLookAroundSceneIfNeeded() async {
        guard scene == nil, !isLoading else { return }

        isLoading = true

        let request = MKLookAroundSceneRequest(coordinate: stop.coordinate)
        scene = try? await request.scene

        isLoading = false
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
