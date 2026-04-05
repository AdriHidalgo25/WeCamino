import SwiftUI

struct WelcomeView: View {
    @Bindable var viewModel: WelcomeViewModel

    var body: some View {
        Group {
            if let content = viewModel.content {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 54, weight: .semibold))
                            .foregroundStyle(.tint)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(content.title)
                                .font(.largeTitle.bold())

                            Text(content.message)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }

                        Button(action: viewModel.primaryActionTapped) {
                            Text(content.primaryActionTitle)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                }
                .navigationTitle("Bienvenida")
                .navigationBarTitleDisplayMode(.inline)
            } else if viewModel.isLoading {
                ProgressView("Cargando")
                    .navigationTitle("Bienvenida")
            } else {
                ContentUnavailableView(
                    "No pudimos cargar la bienvenida",
                    systemImage: "exclamationmark.triangle"
                )
            }
        }
    }
}
