import SwiftUI

struct HomePlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Arquitectura lista",
            systemImage: "checkmark.circle",
            description: Text("La navegación ya está conectada y esta pantalla puede evolucionar a tu siguiente flujo.")
        )
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
