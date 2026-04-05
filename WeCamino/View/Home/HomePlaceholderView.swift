import SwiftUI

struct HomePlaceholderView: View {
    let heroNamespace: Namespace.ID

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.14, blue: 0.19),
                    Color(red: 0.09, green: 0.31, blue: 0.53),
                    Color(red: 0.10, green: 0.54, blue: 0.43)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Your Camino hub")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("The hero transition is already wired. This destination can evolve into routes, groups, profile or live journey modules.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.84))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )
                )
                .matchedTransitionSource(id: "welcome.hero.card", in: heroNamespace)
                .navigationTransition(.zoom(sourceID: "welcome.hero.card", in: heroNamespace))

                ContentUnavailableView(
                    "Ready for the next feature",
                    systemImage: "sparkles",
                    description: Text("Routes, manual check-ins and groups can now inherit this visual language.")
                )
                .foregroundStyle(.white)
            }
            .padding(20)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
