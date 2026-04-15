import SwiftUI

private enum RouteCatalogLayout {
    static let contentSpacing: CGFloat = 24
    static let horizontalPadding: CGFloat = 20
    static let topSafeAreaPadding: CGFloat = 24
    static let bottomSafeAreaPadding: CGFloat = 112
    static let initialHeaderOffset: CGFloat = 10
    static let initialSummaryOffset: CGFloat = 16
    static let initialRowsOffset: CGFloat = 22

    static let summarySpacing: CGFloat = 10
    static let summaryPillCornerRadius: CGFloat = 16
    static let summaryPillHorizontalPadding: CGFloat = 14
    static let summaryPillVerticalPadding: CGFloat = 10
    static let summaryTitleSize: CGFloat = 12
    static let summaryValueSize: CGFloat = 15

    static let routeRowSpacing: CGFloat = 14
    static let routeRowPadding: CGFloat = 14
    static let routeRowCornerRadius: CGFloat = 20
    static let routeRowInternalSpacing: CGFloat = 14
    static let routeTitleSize: CGFloat = 20
    static let routeDescriptionSize: CGFloat = 14
    static let routeTextSpacing: CGFloat = 6
    static let routeMetaSpacing: CGFloat = 12
    static let routeMetaHorizontalSpacing: CGFloat = 8
    static let routeMetaVerticalSpacing: CGFloat = 8

    static let thumbnailSize: CGFloat = 106
    static let thumbnailCornerRadius: CGFloat = 18
    static let thumbnailOrbSize: CGFloat = 56
    static let thumbnailOrbOffset = CGSize(width: 20, height: -22)
    static let thumbnailSymbolSize: CGFloat = 28
    static let thumbnailCodeFontSize: CGFloat = 10
    static let thumbnailCodeHorizontalPadding: CGFloat = 7
    static let thumbnailCodeVerticalPadding: CGFloat = 5
    static let thumbnailCodePadding: CGFloat = 8

    static let chipFontSize: CGFloat = 12
    static let chipHorizontalPadding: CGFloat = 10
    static let chipVerticalPadding: CGFloat = 6
    static let openButtonSize: CGFloat = 32
    static let openButtonSymbolSize: CGFloat = 14
}

/// Lists the official Camino routes with a compact, comparison-first layout.
struct RouteCatalogScene: View {
    // MARK: - Environment

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    let heroNamespace: Namespace.ID

    // MARK: - State

    @State private var viewModel: RouteCatalogViewModel
    @State private var hasAnimatedIn = false

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    // MARK: - Initialization

    /// Creates the route catalog scene.
    /// - Parameters:
    ///   - repository: Source of official Camino routes.
    ///   - heroNamespace: Namespace used to link catalog rows with route detail transitions.
    init(
        repository: any OfficialRouteRepository,
        heroNamespace: Namespace.ID
    ) {
        self.heroNamespace = heroNamespace
        _viewModel = State(initialValue: RouteCatalogViewModel(repository: repository))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            routeCatalogBackground

            if viewModel.isLoading && viewModel.routes.isEmpty {
                ProgressView(strings.routesLoading)
                    .tint(palette.textPrimary)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: RouteCatalogLayout.contentSpacing) {
                        routeHeader
                            .opacity(hasAnimatedIn ? 1 : 0)
                            .offset(y: hasAnimatedIn ? 0 : RouteCatalogLayout.initialHeaderOffset)

                        routeSummary
                            .opacity(hasAnimatedIn ? 1 : 0)
                            .offset(y: hasAnimatedIn ? 0 : RouteCatalogLayout.initialSummaryOffset)
                            .animation(.smooth(duration: 0.55).delay(0.04), value: hasAnimatedIn)

                        routeRows
                            .opacity(hasAnimatedIn ? 1 : 0)
                            .offset(y: hasAnimatedIn ? 0 : RouteCatalogLayout.initialRowsOffset)
                            .animation(.smooth(duration: 0.55).delay(0.08), value: hasAnimatedIn)
                    }
                    .padding(.horizontal, RouteCatalogLayout.horizontalPadding)
                    .safeAreaPadding(.top, RouteCatalogLayout.topSafeAreaPadding)
                    .safeAreaPadding(.bottom, RouteCatalogLayout.bottomSafeAreaPadding)
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

    // MARK: - Background

    private var routeCatalogBackground: some View {
        palette.backgroundMiddle
            .ignoresSafeArea()
    }

    // MARK: - Header

    private var routeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.routesTitle)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(strings.routesSubtitle)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
    }

    // MARK: - Summary

    private var routeSummary: some View {
        HStack(spacing: RouteCatalogLayout.summarySpacing) {
            summaryPill(title: strings.tabRoutes, value: "\(viewModel.routes.count)")
            summaryPill(title: strings.sourceTitle, value: strings.sourceValue)
            summaryPill(title: strings.layersTitle, value: strings.layersValue)
        }
    }

    // MARK: - Route List

    private var routeRows: some View {
        VStack(spacing: RouteCatalogLayout.routeRowSpacing) {
            ForEach(viewModel.routes) { route in
                NavigationLink(value: AppDestination.routeDetail(route.id)) {
                    routeRow(route)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Components

    private func summaryPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: RouteCatalogLayout.summaryTitleSize, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            Text(value)
                .font(.system(size: RouteCatalogLayout.summaryValueSize, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)
        }
        .padding(.horizontal, RouteCatalogLayout.summaryPillHorizontalPadding)
        .padding(.vertical, RouteCatalogLayout.summaryPillVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: RouteCatalogLayout.summaryPillCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: RouteCatalogLayout.summaryPillCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func routeRow(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle
        let routeName = route.localizedName(for: strings.language)
        let routeDescription = route.localizedShortDescription(for: strings.language)
        let routeMood = route.id.localizedMood(for: strings.language)

        return HStack(alignment: .top, spacing: RouteCatalogLayout.routeRowInternalSpacing) {
            RouteThumbnail(style: style, code: style.miniLabel)
                .frame(width: RouteCatalogLayout.thumbnailSize, height: RouteCatalogLayout.thumbnailSize)

            VStack(alignment: .leading, spacing: RouteCatalogLayout.routeMetaSpacing) {
                VStack(alignment: .leading, spacing: RouteCatalogLayout.routeTextSpacing) {
                    Text(routeName)
                        .font(.system(size: RouteCatalogLayout.routeTitleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(routeDescription)
                        .font(.system(size: RouteCatalogLayout.routeDescriptionSize, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(3)
                }

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: RouteCatalogLayout.routeMetaHorizontalSpacing) {
                        routeMetaChip(routeMood, systemImage: style.symbol)
                        routeMetaChip("\(route.stages.count) \(strings.layersValue.lowercased())", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                    }

                    VStack(alignment: .leading, spacing: RouteCatalogLayout.routeMetaVerticalSpacing) {
                        routeMetaChip(routeMood, systemImage: style.symbol)
                        routeMetaChip("\(route.stages.count) \(strings.layersValue.lowercased())", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                    }
                }
            }

            Spacer(minLength: 0)

            routeOpenButton
        }
        .padding(RouteCatalogLayout.routeRowPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: RouteCatalogLayout.routeRowCornerRadius, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: RouteCatalogLayout.routeRowCornerRadius, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
        .matchedTransitionSource(id: route.id, in: heroNamespace)
    }

    private func routeMetaChip(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: RouteCatalogLayout.chipFontSize, weight: .medium, design: .rounded))
            .foregroundStyle(palette.textSecondary)
            .lineLimit(1)
            .padding(.horizontal, RouteCatalogLayout.chipHorizontalPadding)
            .padding(.vertical, RouteCatalogLayout.chipVerticalPadding)
            .background(palette.surfaceMuted, in: Capsule())
    }

    private var routeOpenButton: some View {
        Image(systemName: "arrow.up.right")
            .font(.system(size: RouteCatalogLayout.openButtonSymbolSize, weight: .bold))
            .foregroundStyle(palette.accent)
            .frame(width: RouteCatalogLayout.openButtonSize, height: RouteCatalogLayout.openButtonSize)
            .background(palette.accentSoft, in: Circle())
    }
}

/// Compact visual identifier used by route rows.
private struct RouteThumbnail: View {
    let style: OfficialRouteVisualStyle
    let code: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: RouteCatalogLayout.thumbnailCornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: style.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.white.opacity(0.16))
                .frame(
                    width: RouteCatalogLayout.thumbnailOrbSize,
                    height: RouteCatalogLayout.thumbnailOrbSize
                )
                .offset(
                    x: RouteCatalogLayout.thumbnailOrbOffset.width,
                    y: RouteCatalogLayout.thumbnailOrbOffset.height
                )

            Image(systemName: style.symbol)
                .font(.system(size: RouteCatalogLayout.thumbnailSymbolSize, weight: .bold))
                .foregroundStyle(.white)
        }
        .overlay(alignment: .topTrailing) {
            Text(code)
                .font(.system(size: RouteCatalogLayout.thumbnailCodeFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
                .padding(.horizontal, RouteCatalogLayout.thumbnailCodeHorizontalPadding)
                .padding(.vertical, RouteCatalogLayout.thumbnailCodeVerticalPadding)
                .background(Color.black.opacity(0.28), in: Capsule())
                .padding(RouteCatalogLayout.thumbnailCodePadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: RouteCatalogLayout.thumbnailCornerRadius, style: .continuous))
    }
}

/// Centralizes the visual tokens that make a route recognizable across
/// catalog and detail surfaces.
struct OfficialRouteVisualStyle {
    let gradient: [Color]
    let symbol: String
    let mood: String
    let miniLabel: String
}

// MARK: - Route Visual Metadata

extension OfficialRoute.ID {
    func localizedMood(for language: AppLanguage) -> String {
        switch language {
        case .spanish:
            switch self {
            case .frances: "Clasico"
            case .norte: "Atlantico"
            case .primitivo: "Origen"
            case .ingles: "Maritimo"
            case .portugues: "Popular"
            case .portuguesCoastal: "Costero"
            case .viaDeLaPlata: "Sureño"
            case .invierno: "Alternativo"
            case .fisterraMuxia: "Final atlantico"
            case .arousaUlla: "Rio y mar"
            }
        case .french:
            switch self {
            case .frances: "Classique"
            case .norte: "Atlantique"
            case .primitivo: "Originel"
            case .ingles: "Maritime"
            case .portugues: "Populaire"
            case .portuguesCoastal: "Cotier"
            case .viaDeLaPlata: "Sud"
            case .invierno: "Alternative"
            case .fisterraMuxia: "Fin atlantique"
            case .arousaUlla: "Riviere-mer"
            }
        case .english, .system:
            visualStyle.mood
        }
    }

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

#if DEBUG
// MARK: - Previews

private struct RouteCatalogScenePreview: View {
    @Namespace private var heroNamespace

    var body: some View {
        NavigationStack {
            RouteCatalogScene(
                repository: LocalOfficialRouteRepository(),
                heroNamespace: heroNamespace
            )
        }
        .weCaminoPreviewEnvironment()
    }
}

#Preview("Route Catalog") {
    RouteCatalogScenePreview()
}
#endif
