import SwiftUI

struct RouteDetailScene: View {
    let routeID: OfficialRoute.ID
    let heroNamespace: Namespace.ID

    @State private var viewModel: RouteDetailViewModel

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
            RouteBackground(style: .atlantic)

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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 28)
                    }
                } else if viewModel.isLoading {
                    ProgressView("Loading route")
                        .tint(.white)
                        .foregroundStyle(.white)
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
            await viewModel.loadIfNeeded()
        }
    }

    private func heroCard(_ route: OfficialRoute) -> some View {
        let style = route.id.visualStyle

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: style.symbol)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(Color.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                Spacer()

                Text(style.mood)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.16), in: Capsule())
            }

            Text(route.name)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(route.shortDescription)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.84))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: style.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: style.gradient.last?.opacity(0.28) ?? .black.opacity(0.2), radius: 20, y: 14)
    }

    private func detailSection(
        title: String,
        body: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(body)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.82))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )
        )
    }
}
