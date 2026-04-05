import SwiftUI

struct WelcomeView: View {
    let heroNamespace: Namespace.ID

    @Bindable var viewModel: WelcomeViewModel
    @State private var hasAnimatedIn = false

    var body: some View {
        ZStack {
            backgroundView

            Group {
                if let content = viewModel.content {
                    loadedState(content: content)
                } else if viewModel.isLoading {
                    ProgressView("Cargando experiencia")
                        .tint(.white)
                        .foregroundStyle(.white)
                } else {
                    ContentUnavailableView(
                        "No pudimos cargar la bienvenida",
                        systemImage: "exclamationmark.triangle"
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .navigationTitle("WeCamino")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            guard !hasAnimatedIn else { return }

            withAnimation(.smooth(duration: 0.9)) {
                hasAnimatedIn = true
            }
        }
    }

    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.49, blue: 0.21),
                    Color(red: 0.95, green: 0.78, blue: 0.24),
                    Color(red: 0.12, green: 0.66, blue: 0.52)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.22))
                .frame(width: 260, height: 260)
                .blur(radius: 12)
                .offset(x: hasAnimatedIn ? 120 : 170, y: -250)
                .animation(.smooth(duration: 1.6), value: hasAnimatedIn)

            Circle()
                .fill(Color(red: 0.02, green: 0.29, blue: 0.39).opacity(0.22))
                .frame(width: 320, height: 320)
                .blur(radius: 20)
                .offset(x: -140, y: hasAnimatedIn ? 280 : 330)
                .animation(.smooth(duration: 1.4), value: hasAnimatedIn)
        }
    }

    @ViewBuilder
    private func loadedState(content: WelcomeContent) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                heroCard(content: content)
                    .matchedTransitionSource(id: "welcome.hero.card", in: heroNamespace)
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .scaleEffect(hasAnimatedIn ? 1 : 0.94)
                    .offset(y: hasAnimatedIn ? 0 : 18)

                featureStrip
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 24)
                    .animation(.smooth(duration: 0.8).delay(0.1), value: hasAnimatedIn)

                journeyHighlight
                    .opacity(hasAnimatedIn ? 1 : 0)
                    .offset(y: hasAnimatedIn ? 0 : 30)
                    .animation(.smooth(duration: 0.8).delay(0.18), value: hasAnimatedIn)
            }
            .padding(.vertical, 12)
        }
    }

    private func heroCard(content: WelcomeContent) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 84, height: 84)

                    Image(systemName: "figure.hiking")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .scaleEffect(hasAnimatedIn ? 1 : 0.84)
                        .rotationEffect(.degrees(hasAnimatedIn ? 0 : -10))
                }

                Spacer()

                Text("2026")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.84))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.14), in: Capsule())
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(content.title)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(content.message)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.84))
            }

            HStack(spacing: 10) {
                pillLabel("Rutas oficiales")
                pillLabel("Check-ins manuales")
                pillLabel("Grupos")
            }

            Button(action: viewModel.primaryActionTapped) {
                HStack {
                    Text(content.primaryActionTitle)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title3)
                }
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.14, green: 0.20, blue: 0.25))
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.18), radius: 22, y: 16)
    }

    private var featureStrip: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What makes it special")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    featureCard(
                        title: "Official routes",
                        subtitle: "Understand the Camino with trusted route data.",
                        systemImage: "map.fill",
                        color: Color(red: 0.09, green: 0.31, blue: 0.53)
                    )

                    featureCard(
                        title: "Pilgrim moments",
                        subtitle: "Share your latest stop without live tracking pressure.",
                        systemImage: "location.circle.fill",
                        color: Color(red: 0.84, green: 0.34, blue: 0.31)
                    )

                    featureCard(
                        title: "Journey groups",
                        subtitle: "Find people walking the same route and rhythm.",
                        systemImage: "person.3.fill",
                        color: Color(red: 0.10, green: 0.54, blue: 0.43)
                    )
                }
            }
        }
    }

    private var journeyHighlight: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Designed for the road")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("A colorful foundation with motion, layered surfaces and transitions ready for richer route, group and profile experiences.")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.84))
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.black.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    private func pillLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.16), in: Capsule())
    }

    private func featureCard(
        title: String,
        subtitle: String,
        systemImage: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(color, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.14, green: 0.20, blue: 0.25))

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(width: 220, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 14, y: 10)
    }
}
