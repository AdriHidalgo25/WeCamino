import SwiftUI
import MapKit

/// Presents the official route detail with a single visual focal point and
/// the supporting information needed to understand the route quickly.
struct RouteDetailScene: View {
    // MARK: - Environment

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    let routeID: OfficialRoute.ID
    let heroNamespace: Namespace.ID

    // MARK: - State

    @State private var viewModel: RouteDetailViewModel
    @State private var hasExpandedHero = false
    @State private var mapPosition: MapCameraPosition = .automatic

    // MARK: - Layout

    private enum Layout {
        static let contentSpacing: CGFloat = 22
        static let horizontalPadding: CGFloat = 20
        static let topSafeAreaPadding: CGFloat = 16
        static let bottomSafeAreaPadding: CGFloat = 36
        static let loadingTopPadding: CGFloat = 12

        static let backgroundGlowPrimarySize: CGFloat = 280
        static let backgroundGlowPrimaryBlur: CGFloat = 28
        static let backgroundGlowPrimaryOffset = CGSize(width: 128, height: -280)
        static let backgroundGlowSecondarySize: CGFloat = 320
        static let backgroundGlowSecondaryBlur: CGFloat = 40
        static let backgroundGlowSecondaryOffset = CGSize(width: -150, height: -80)

        static let heroContentSpacing: CGFloat = 18
        static let heroBannerCornerRadius: CGFloat = 30
        static let heroBannerHeight: CGFloat = 180
        static let heroPrimaryOrbSize: CGFloat = 110
        static let heroPrimaryOrbOffset = CGSize(width: 118, height: -28)
        static let heroSecondaryOrbSize: CGFloat = 72
        static let heroSecondaryOrbOffset = CGSize(width: -110, height: 34)
        static let heroSymbolSize: CGFloat = 76
        static let heroBannerPadding: CGFloat = 18
        static let heroCardPadding: CGFloat = 18
        static let heroCardCornerRadius: CGFloat = 34
        static let heroTitleSize: CGFloat = 32
        static let bodyTextSize: CGFloat = 15
        static let heroDescriptionLineLimit = 3
        static let collapsedHeroOpacity: CGFloat = 0.96
        static let collapsedHeroScale: CGFloat = 0.98

        static let mapSectionPadding: CGFloat = 22
        static let sectionCornerRadius: CGFloat = 30
        static let sectionBodySpacing: CGFloat = 16
        static let mapHeight: CGFloat = 260
        static let badgeHorizontalPadding: CGFloat = 12
        static let badgeVerticalPadding: CGFloat = 8
        static let badgeFontSize: CGFloat = 13

        static let detailSectionSpacing: CGFloat = 10
        static let detailSectionPadding: CGFloat = 20
        static let detailSectionCornerRadius: CGFloat = 28
        static let detailTitleSize: CGFloat = 18

        static let stageRowSpacing: CGFloat = 14
        static let stageSectionHeaderSpacing: CGFloat = 6
        static let stageIndexSize: CGFloat = 34
        static let stageRowPadding: CGFloat = 18
        static let stageRowCornerRadius: CGFloat = 24
        static let stageTitleSize: CGFloat = 16
        static let stageSubtitleSize: CGFloat = 13
        static let stageDistanceSize: CGFloat = 14

        static let metaSpacing: CGFloat = 10
        static let metaFallbackSpacing: CGFloat = 8
        static let pillFontSize: CGFloat = 12
        static let pillHorizontalPadding: CGFloat = 12
        static let pillVerticalPadding: CGFloat = 8
        static let codeBadgeFontSize: CGFloat = 12
        static let codeBadgeHorizontalPadding: CGFloat = 10
        static let codeBadgeVerticalPadding: CGFloat = 8

        static let routeMarkerSpacing: CGFloat = 6
        static let routeMarkerSize: CGFloat = 24
        static let routeMarkerLabelSize: CGFloat = 11
        static let routeMarkerLabelHorizontalPadding: CGFloat = 8
        static let routeMarkerLabelVerticalPadding: CGFloat = 5
        static let mapLineWidth: CGFloat = 4

        static let heroAnimationDelayMilliseconds: UInt64 = 180
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    // MARK: - Initialization

    /// Creates a route detail scene for a single official route.
    /// - Parameters:
    ///   - repository: Source of route metadata and stages.
    ///   - routeID: Stable identifier of the route to render.
    ///   - heroNamespace: Namespace shared with the catalog transition source.
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

    // MARK: - Body

    var body: some View {
        ZStack {
            routeDetailBackground

            Group {
                if let route = viewModel.route {
                    let localizedOrigin = route.localizedOrigin(for: strings.language)
                    let localizedTerrain = route.localizedTerrain(for: strings.language)
                    let localizedOfficialContext = route.localizedOfficialContext(for: strings.language)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                            heroCard(route)

                            detailSection(
                                title: strings.originTitle,
                                body: localizedOrigin
                            )

                            detailSection(
                                title: strings.routeCharacterTitle,
                                body: localizedTerrain
                            )

                            detailSection(
                                title: strings.whyItMattersTitle,
                                body: localizedOfficialContext
                            )

                            routeMapSection(route)

                            stagesSection(route)
                        }
                        .padding(.horizontal, Layout.horizontalPadding)
                        .safeAreaPadding(.top, Layout.topSafeAreaPadding)
                        .safeAreaPadding(.bottom, Layout.bottomSafeAreaPadding)
                    }
                } else if viewModel.isLoading {
                    ProgressView(strings.routeLoading)
                        .tint(palette.textPrimary)
                        .foregroundStyle(palette.textPrimary)
                        .safeAreaPadding(.top, Layout.loadingTopPadding)
                } else {
                    ContentUnavailableView(
                        strings.routeUnavailable,
                        systemImage: "map",
                        description: Text(strings.routeMapUnavailableMessage)
                    )
                }
            }
        }
        .navigationTitle(strings.routeNavigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTransition(.zoom(sourceID: routeID, in: heroNamespace))
        .task {
            await loadRouteAndAnimateHero()
        }
    }

    // MARK: - Background

    private var routeDetailBackground: some View {
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
                .frame(width: Layout.backgroundGlowPrimarySize, height: Layout.backgroundGlowPrimarySize)
                .blur(radius: Layout.backgroundGlowPrimaryBlur)
                .offset(
                    x: Layout.backgroundGlowPrimaryOffset.width,
                    y: Layout.backgroundGlowPrimaryOffset.height
                )

            Circle()
                .fill(palette.glowSecondary)
                .frame(width: Layout.backgroundGlowSecondarySize, height: Layout.backgroundGlowSecondarySize)
                .blur(radius: Layout.backgroundGlowSecondaryBlur)
                .offset(
                    x: Layout.backgroundGlowSecondaryOffset.width,
                    y: Layout.backgroundGlowSecondaryOffset.height
                )
        }
    }

    // MARK: - Hero

    private func heroCard(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle
        let routeName = route.localizedName(for: strings.language)
        let routeDescription = route.localizedShortDescription(for: strings.language)
        return VStack(alignment: .leading, spacing: Layout.heroContentSpacing) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Layout.heroBannerCornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: style.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: Layout.heroPrimaryOrbSize, height: Layout.heroPrimaryOrbSize)
                    .offset(
                        x: Layout.heroPrimaryOrbOffset.width,
                        y: Layout.heroPrimaryOrbOffset.height
                    )

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: Layout.heroSecondaryOrbSize, height: Layout.heroSecondaryOrbSize)
                    .offset(
                        x: Layout.heroSecondaryOrbOffset.width,
                        y: Layout.heroSecondaryOrbOffset.height
                    )

                Image(systemName: style.symbol)
                    .font(.system(size: Layout.heroSymbolSize, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.94))

                HStack {
                    Spacer()
                    routeCodeBadge(style.miniLabel)
                }
                .padding(Layout.heroBannerPadding)
            }
            .frame(height: Layout.heroBannerHeight)
            .clipShape(RoundedRectangle(cornerRadius: Layout.heroBannerCornerRadius, style: .continuous))

            VStack(alignment: .leading, spacing: 12) {
                Text(routeName)
                    .font(.system(size: Layout.heroTitleSize, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(routeDescription)
                    .font(.system(size: Layout.bodyTextSize, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
                    .lineLimit(Layout.heroDescriptionLineLimit)

                routeMetaRow(route: route, style: style)
                    .opacity(hasExpandedHero ? 1 : 0.88)
            }
        }
        .padding(Layout.heroCardPadding)
        .background(
            RoundedRectangle(cornerRadius: Layout.heroCardCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.heroCardCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
        .opacity(hasExpandedHero ? 1 : Layout.collapsedHeroOpacity)
        .scaleEffect(hasExpandedHero ? 1 : Layout.collapsedHeroScale)
    }

    // MARK: - Map

    private func routeMapSection(_ route: OfficialRoute) -> some View {
        VStack(alignment: .leading, spacing: Layout.sectionBodySpacing) {
            routeMapHeader(route)
            routeMapCard
        }
        .padding(Layout.mapSectionPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func routeMapHeader(_ route: OfficialRoute) -> some View {
        HStack {
            Text(strings.routeMapTitle)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Spacer()

            Text("\(route.stops.count) \(strings.stopsLabel)")
                .font(.system(size: Layout.badgeFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.accent)
                .padding(.horizontal, Layout.badgeHorizontalPadding)
                .padding(.vertical, Layout.badgeVerticalPadding)
                .background(palette.accentSoft, in: Capsule())
        }
    }

    private var routeMapCard: some View {
        ZStack {
                RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                    .fill(palette.surfaceMuted)

            routeMapContent
        }
        .frame(height: Layout.mapHeight)
        .clipShape(RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                .stroke(palette.border, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var routeMapContent: some View {
        if !viewModel.routeStops.isEmpty {
            routeMapView
        } else if viewModel.isResolvingRouteStops {
            ProgressView(strings.routeLoading)
                .tint(palette.textPrimary)
                .foregroundStyle(palette.textPrimary)
        } else {
            ContentUnavailableView(
                strings.routeMapUnavailableTitle,
                systemImage: "map",
                description: Text(strings.routeMapUnavailableMessage)
            )
        }
    }

    private var routeMapView: some View {
        Map(position: $mapPosition, interactionModes: []) {
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
        VStack(spacing: Layout.routeMarkerSpacing) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: Layout.routeMarkerSize, weight: .bold))
                .foregroundStyle(Color(red: 0.95, green: 0.54, blue: 0.20))
                .background(Color.white, in: Circle())

            Text(stop.stop.name)
                .font(.system(size: Layout.routeMarkerLabelSize, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textPrimary)
                .padding(.horizontal, Layout.routeMarkerLabelHorizontalPadding)
                .padding(.vertical, Layout.routeMarkerLabelVerticalPadding)
                .background(palette.surfaceMuted, in: Capsule())
        }
    }

    // MARK: - Stages

    private func stagesSection(_ route: OfficialRoute) -> some View {
        VStack(alignment: .leading, spacing: Layout.sectionBodySpacing) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Layout.stageSectionHeaderSpacing) {
                    Text(strings.stagesTitle)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)

                    Text("\(route.stages.count) \(strings.layersValue.lowercased()) · \(route.totalDistanceKilometers.formatted(.number.precision(.fractionLength(1)))) km")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
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
        .padding(Layout.mapSectionPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.sectionCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    // MARK: - Detail Blocks

    private func detailSection(
        title: String,
        body: String
    ) -> some View {
        VStack(alignment: .leading, spacing: Layout.detailSectionSpacing) {
            Text(title)
                .font(.system(size: Layout.detailTitleSize, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(body)
                .font(.system(size: Layout.bodyTextSize, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
        .padding(Layout.detailSectionPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.detailSectionCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.detailSectionCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    // MARK: - Metadata

    private func routeCodeBadge(_ code: String) -> some View {
        Text(code)
            .font(.system(size: Layout.codeBadgeFontSize, weight: .bold, design: .rounded))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, Layout.codeBadgeHorizontalPadding)
            .padding(.vertical, Layout.codeBadgeVerticalPadding)
            .background(Color.black.opacity(0.18), in: Capsule())
    }

    private func routeMetaRow(
        route: OfficialRoute,
        style: OfficialRouteVisualStyle
    ) -> some View {
        let localizedOrigin = route.localizedOrigin(for: strings.language)
        let localizedMood = route.id.localizedMood(for: strings.language)
        return ViewThatFits(in: .horizontal) {
            HStack(spacing: Layout.metaSpacing) {
                routeMetaPill(localizedMood, systemImage: style.symbol)
                routeMetaPill(localizedOrigin, systemImage: "flag.pattern.checkered")
            }

            VStack(alignment: .leading, spacing: Layout.metaFallbackSpacing) {
                routeMetaPill(localizedMood, systemImage: style.symbol)
                routeMetaPill(localizedOrigin, systemImage: "flag.pattern.checkered")
            }
        }
    }

    private func routeMetaPill(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: Layout.pillFontSize, weight: .semibold, design: .rounded))
            .foregroundStyle(palette.textPrimary)
            .padding(.horizontal, Layout.pillHorizontalPadding)
            .padding(.vertical, Layout.pillVerticalPadding)
            .background(palette.surfaceMuted, in: Capsule())
    }

    private func stageRow(
        index: Int,
        stage: OfficialRoute.Stage
    ) -> some View {
        HStack(alignment: .top, spacing: Layout.stageRowSpacing) {
            Text("\(index)")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)
                .frame(width: Layout.stageIndexSize, height: Layout.stageIndexSize)
                .background(palette.accentSoft, in: Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text("\(stage.start.name) -> \(stage.end.name)")
                    .font(.system(size: Layout.stageTitleSize, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(stage.mode == .maritime ? strings.maritimeSegmentLabel : strings.walkingStageLabel)
                    .font(.system(size: Layout.stageSubtitleSize, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
            }

            Spacer()

            Text("\(stage.distanceKilometers.formatted(.number.precision(.fractionLength(1)))) km")
                .font(.system(size: Layout.stageDistanceSize, weight: .bold, design: .rounded))
                .foregroundStyle(palette.accent)
                .padding(.horizontal, Layout.badgeHorizontalPadding)
                .padding(.vertical, Layout.badgeVerticalPadding)
                .background(palette.accentSoft, in: Capsule())
        }
        .padding(Layout.stageRowPadding)
        .background(palette.surfaceMuted, in: RoundedRectangle(cornerRadius: Layout.stageRowCornerRadius, style: .continuous))
    }

    // MARK: - Loading

    private func loadRouteAndAnimateHero() async {
        hasExpandedHero = false
        await viewModel.loadIfNeeded()
        await viewModel.loadRouteStopsIfNeeded()

        guard viewModel.route != nil else { return }

        if let routeMapRect = viewModel.routeMapRect {
            mapPosition = .rect(routeMapRect)
        }

        try? await Task.sleep(for: .milliseconds(Layout.heroAnimationDelayMilliseconds))

        withAnimation(.snappy(duration: 0.6, extraBounce: 0.02)) {
            hasExpandedHero = true
        }
    }
}

#if DEBUG
// MARK: - Previews

private struct RouteDetailScenePreview: View {
    @Namespace private var heroNamespace

    var body: some View {
        NavigationStack {
            RouteDetailScene(
                repository: LocalOfficialRouteRepository(),
                routeID: .frances,
                heroNamespace: heroNamespace
            )
        }
        .weCaminoPreviewEnvironment()
    }
}

#Preview("Route Detail") {
    RouteDetailScenePreview()
}
#endif
