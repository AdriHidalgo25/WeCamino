import SwiftUI

struct WelcomeView: View {
    let heroNamespace: Namespace.ID

    @Bindable var viewModel: WelcomeViewModel
    @State private var hasAnimatedIn = false

    var body: some View {
        ZStack {
            homeBackground

            Group {
                if let content = viewModel.content {
                    loadedState(content: content)
                } else if viewModel.isLoading {
                    ProgressView("Loading home")
                        .tint(Color(red: 0.09, green: 0.12, blue: 0.17))
                } else {
                    ContentUnavailableView(
                        "Home unavailable",
                        systemImage: "exclamationmark.triangle"
                    )
                }
            }
            .padding(.horizontal, 20)
            .safeAreaPadding(.top, 16)
            .safeAreaPadding(.bottom, 112)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            guard !hasAnimatedIn else { return }

            withAnimation(.smooth(duration: 0.85)) {
                hasAnimatedIn = true
            }
        }
    }

    private var homeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 0.97),
                    Color(red: 0.92, green: 0.96, blue: 1.00),
                    Color(red: 0.95, green: 0.94, blue: 0.90)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.84))
                .frame(width: 280, height: 280)
                .blur(radius: 24)
                .offset(x: 110, y: -300)

            Circle()
                .fill(Color(red: 0.77, green: 0.92, blue: 1.00).opacity(0.55))
                .frame(width: 320, height: 320)
                .blur(radius: 36)
                .offset(x: -150, y: -120)
        }
    }

    @ViewBuilder
    private func loadedState(content: WelcomeContent) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 12)

                heroCard(content: content)
                    .matchedTransitionSource(id: "welcome.hero.card", in: heroNamespace)
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .scaleEffect(hasAnimatedIn ? 1 : 0.96)
                    .offset(y: hasAnimatedIn ? 0 : 18)

                statusStrip
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 22)
                    .animation(.smooth(duration: 0.8).delay(0.08), value: hasAnimatedIn)

                quickActions
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 28)
                    .animation(.smooth(duration: 0.8).delay(0.14), value: hasAnimatedIn)

                featuredRoutes
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 32)
                    .animation(.smooth(duration: 0.8).delay(0.18), value: hasAnimatedIn)
            }
            .padding(.vertical, 6)
        }
    }

    private var header: some View {
        HStack {
            Label {
                Text("WeCamino")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            } icon: {
                Image(systemName: "figure.hiking.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
            }
            .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))

            Spacer()

            Button {} label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.92), in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private func heroCard(content: WelcomeContent) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(content.title)
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            Text("Follow the Camino with official routes, check-ins and pilgrim groups in one bright, social experience.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.56))

            Spacer(minLength: 0)

            CaminoHeroIllustration()
                .frame(height: 300)
                .padding(.horizontal, -24)
                .padding(.bottom, -24)

            Button(action: viewModel.primaryActionTapped) {
                Text(content.primaryActionTitle)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.10, green: 0.12, blue: 0.17))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(red: 0.85, green: 0.98, blue: 1.00))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .stroke(Color.white.opacity(0.92), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.09), radius: 24, y: 12)
    }

    private var statusStrip: some View {
        HStack(spacing: 12) {
            compactStatusCard(
                title: "Official routes",
                value: "10",
                tint: Color(red: 0.84, green: 0.95, blue: 0.83),
                systemImage: "map.fill"
            )

            compactStatusCard(
                title: "Check-ins",
                value: "Manual",
                tint: Color(red: 1.00, green: 0.94, blue: 0.82),
                systemImage: "location.fill"
            )
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            quickActionCard(
                title: "Explore official routes",
                subtitle: "Jump into the Camino catalog and compare the mood of each route.",
                systemImage: "point.bottomleft.forward.to.point.topright.scurvepath.fill",
                accent: Color(red: 0.98, green: 0.66, blue: 0.18)
            )

            quickActionCard(
                title: "Pilgrim groups are next",
                subtitle: "The social layer is ready for routes, companions and future profile motion.",
                systemImage: "person.3.fill",
                accent: Color(red: 0.56, green: 0.78, blue: 0.40)
            )
        }
    }

    private var featuredRoutes: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Featured routes")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                Spacer()

                Button(action: viewModel.primaryActionTapped) {
                    Text("See all")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.95, green: 0.48, blue: 0.15))
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    featuredRouteCard(
                        title: "Camino Frances",
                        subtitle: "The most iconic route into Santiago.",
                        colors: [Color(red: 0.40, green: 0.73, blue: 0.99), Color(red: 0.99, green: 0.84, blue: 0.48)]
                    )

                    featuredRouteCard(
                        title: "Camino del Norte",
                        subtitle: "Atlantic energy and rugged coastline.",
                        colors: [Color(red: 0.47, green: 0.84, blue: 0.98), Color(red: 0.31, green: 0.64, blue: 0.86)]
                    )
                }
            }
        }
    }

    private func compactStatusCard(
        title: String,
        value: String,
        tint: Color,
        systemImage: String
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(red: 0.98, green: 0.56, blue: 0.15))
                .frame(width: 42, height: 42)
                .background(Color.white, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.56))

                Text(value)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(tint)
        )
    }

    private func quickActionCard(
        title: String,
        subtitle: String,
        systemImage: String,
        accent: Color
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(accent, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.54))
            }

            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 14, y: 8)
    }

    private func featuredRouteCard(
        title: String,
        subtitle: String,
        colors: [Color]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            MiniLandscapeCard(colors: colors)
                .frame(width: 230, height: 126)

            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.08, green: 0.11, blue: 0.16))

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.54))
        }
        .padding(16)
        .frame(width: 262, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 14, y: 8)
    }
}

private struct CaminoHeroIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.46, green: 0.80, blue: 1.00),
                            Color(red: 0.72, green: 0.91, blue: 1.00)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            cloud(width: 84, height: 26)
                .offset(x: 92, y: -82)

            cloud(width: 58, height: 18)
                .offset(x: -40, y: -62)

            Circle()
                .fill(Color(red: 1.00, green: 0.72, blue: 0.32))
                .frame(width: 70, height: 70)
                .offset(x: 86, y: 28)

            MountainShape()
                .fill(Color(red: 0.32, green: 0.58, blue: 0.33))
                .frame(height: 110)
                .offset(y: 44)

            MountainShape()
                .fill(Color(red: 0.22, green: 0.44, blue: 0.29))
                .frame(height: 82)
                .offset(x: 84, y: 68)

            PathShape()
                .fill(Color(red: 0.96, green: 0.88, blue: 0.70))
                .frame(width: 168, height: 90)
                .offset(x: 34, y: 116)

            CathedralShape()
                .fill(Color(red: 0.88, green: 0.96, blue: 0.92))
                .frame(width: 122, height: 120)
                .offset(x: -112, y: 86)

            PilgrimShape()
                .fill(Color(red: 0.16, green: 0.24, blue: 0.30))
                .frame(width: 80, height: 126)
                .overlay(alignment: .center) {
                    PilgrimAccentShape()
                        .fill(Color(red: 0.96, green: 0.46, blue: 0.31))
                        .frame(width: 44, height: 84)
                        .offset(x: 4, y: 18)
                }
                .offset(x: 116, y: 122)

            DroneShape()
                .stroke(Color(red: 0.18, green: 0.18, blue: 0.19), lineWidth: 4)
                .frame(width: 92, height: 50)
                .overlay {
                    Circle()
                        .fill(Color(red: 0.98, green: 0.55, blue: 0.18))
                        .frame(width: 16, height: 16)
                }
                .offset(x: -26, y: 24)

            Rectangle()
                .fill(Color(red: 0.52, green: 0.29, blue: 0.20))
                .frame(height: 44)
                .offset(y: 170)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func cloud(width: CGFloat, height: CGFloat) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.92))
            .frame(width: width, height: height)
            .overlay(alignment: .leading) {
                Circle()
                    .fill(Color.white.opacity(0.92))
                    .frame(width: height * 1.2, height: height * 1.2)
                    .offset(x: height * 0.16, y: -height * 0.16)
            }
            .overlay(alignment: .trailing) {
                Circle()
                    .fill(Color.white.opacity(0.92))
                    .frame(width: height * 1.36, height: height * 1.36)
                    .offset(x: -height * 0.24, y: -height * 0.2)
            }
    }
}

private struct MiniLandscapeCard: View {
    let colors: [Color]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            cloud
                .offset(x: 60, y: -38)

            MountainShape()
                .fill(Color(red: 0.36, green: 0.58, blue: 0.28))
                .frame(height: 48)
                .offset(y: 28)

            PathShape()
                .fill(Color(red: 0.97, green: 0.90, blue: 0.72))
                .frame(width: 92, height: 42)
                .offset(x: 20, y: 48)

            Rectangle()
                .fill(Color(red: 0.61, green: 0.36, blue: 0.24))
                .frame(height: 18)
                .offset(y: 62)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var cloud: some View {
        Capsule()
            .fill(Color.white.opacity(0.92))
            .frame(width: 54, height: 16)
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

private struct CathedralShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let towerWidth = rect.width * 0.18

        path.addRoundedRect(in: CGRect(x: rect.width * 0.18, y: rect.height * 0.38, width: rect.width * 0.64, height: rect.height * 0.44), cornerSize: CGSize(width: 6, height: 6))
        path.addRect(CGRect(x: rect.width * 0.24, y: rect.height * 0.12, width: towerWidth, height: rect.height * 0.34))
        path.addRect(CGRect(x: rect.width * 0.58, y: rect.height * 0.12, width: towerWidth, height: rect.height * 0.34))
        path.move(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.38))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.04))
        path.addLine(to: CGPoint(x: rect.width * 0.82, y: rect.height * 0.38))
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
