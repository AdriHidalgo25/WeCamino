import PhotosUI
import SwiftUI

/// Editing flow for the local pilgrim profile.
struct EditProfileScene: View {
    private struct PhotoFeedback: Identifiable {
        enum Kind {
            case cancelled
            case error
        }

        let kind: Kind

        var id: String {
            switch kind {
            case .cancelled:
                "cancelled"
            case .error:
                "error"
            }
        }
    }

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let contentSpacing: CGFloat = 20
        static let topPadding: CGFloat = 18
        static let cardSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 20
        static let fieldSpacing: CGFloat = 14
        static let avatarSectionSpacing: CGFloat = 12
        static let avatarSize: CGFloat = 104
        static let avatarActionSpacing: CGFloat = 10
        static let controlCornerRadius: CGFloat = 18
        static let cardCornerRadius: CGFloat = 28
        static let bottomPadding: CGFloat = 48
    }

    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(AppPreferencesStore.self) private var preferences

    @State private var viewModel: EditProfileViewModel
    @State private var isPhotoPickerPresented = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var didPickPhoto = false
    @State private var photoFeedback: PhotoFeedback?

    init(
        profileRepository: any UserProfileRepository,
        routeRepository: any OfficialRouteRepository
    ) {
        _viewModel = State(
            initialValue: EditProfileViewModel(
                profileRepository: profileRepository,
                routeRepository: routeRepository
            )
        )
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                identitySection(
                    name: $bindableViewModel.name,
                    phoneNumber: $bindableViewModel.phoneNumber,
                    city: $bindableViewModel.city,
                    avatarImageData: bindableViewModel.avatarImageData
                )
                journeySection
                bioSection(bio: $bindableViewModel.bio)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .safeAreaPadding(.top, Layout.topPadding)
            .safeAreaPadding(.bottom, Layout.bottomPadding)
        }
        .background(palette.backgroundMiddle.ignoresSafeArea())
        .navigationTitle(strings.editProfileTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(strings.saveLabel) {
                    Task {
                        await viewModel.save()
                        dismiss()
                    }
                }
                .disabled(!viewModel.canSave)
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .onChange(of: isPhotoPickerPresented) { oldValue, newValue in
            guard oldValue, !newValue else { return }

            if !didPickPhoto && selectedPhotoItem == nil {
                photoFeedback = PhotoFeedback(kind: .cancelled)
            }
        }
        .task(id: selectedPhotoItem) {
            guard let photoItem = selectedPhotoItem else { return }

            didPickPhoto = true

            if let data = try? await photoItem.loadTransferable(type: Data.self) {
                viewModel.updateAvatarImageData(data)

                if viewModel.avatarImageData == nil {
                    photoFeedback = PhotoFeedback(kind: .error)
                } else {
                    photoFeedback = nil
                }
            } else {
                photoFeedback = PhotoFeedback(kind: .error)
            }

            selectedPhotoItem = nil
        }
    }

    private func identitySection(
        name: Binding<String>,
        phoneNumber: Binding<String>,
        city: Binding<String>,
        avatarImageData: Data?
    ) -> some View {
        editorCard(
            title: strings.editIdentitySectionTitle,
            subtitle: strings.editProfileSubtitle
        ) {
            VStack(spacing: Layout.fieldSpacing) {
                avatarSection(avatarImageData: avatarImageData)

                textField(
                    title: strings.editNameLabel,
                    text: name,
                    keyboardType: .default
                )

                textField(
                    title: strings.editPhoneLabel,
                    text: phoneNumber,
                    keyboardType: .phonePad
                )

                textField(
                    title: strings.editCityLabel,
                    text: city,
                    keyboardType: .default
                )
            }
        }
    }

    private func avatarSection(avatarImageData: Data?) -> some View {
        VStack(alignment: .leading, spacing: Layout.avatarSectionSpacing) {
            Text(strings.editAvatarLabel)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            if let photoFeedback {
                photoFeedbackBanner(photoFeedback)
            }

            HStack(spacing: 14) {
                ProfileAvatarView(
                    initials: viewModel.avatarInitials,
                    imageData: avatarImageData,
                    size: Layout.avatarSize,
                    accentColor: palette.accent,
                    backgroundColor: palette.accentSoft
                )

                VStack(alignment: .leading, spacing: Layout.avatarActionSpacing) {
                    Button {
                        didPickPhoto = false
                        photoFeedback = nil
                        isPhotoPickerPresented = true
                    } label: {
                        labelChip(
                            title: strings.editAvatarActionTitle,
                            systemImage: "photo.on.rectangle"
                        )
                    }
                    .buttonStyle(.plain)

                    if avatarImageData != nil {
                        Button {
                            selectedPhotoItem = nil
                            viewModel.updateAvatarImageData(nil)
                        } label: {
                            labelChip(
                                title: strings.removePhotoLabel,
                                systemImage: "trash"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()
            }
        }
        .photosPicker(
            isPresented: $isPhotoPickerPresented,
            selection: $selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        )
    }

    private var journeySection: some View {
        editorCard(
            title: strings.editJourneySectionTitle,
            subtitle: strings.profileJourneySectionTitle
        ) {
            VStack(spacing: Layout.fieldSpacing) {
                menuField(
                    title: strings.editRouteLabel,
                    value: selectedRouteName
                ) {
                    ForEach(viewModel.routes, id: \.id) { route in
                        Button(route.localizedName(for: preferences.resolvedLanguage)) {
                            viewModel.updateRoute(to: route.id)
                        }
                    }
                }

                menuField(
                    title: strings.editStageLabel,
                    value: selectedStageTitle
                ) {
                    ForEach(viewModel.stageOptions, id: \.self) { stageNumber in
                        Button(stageTitle(for: stageNumber)) {
                            viewModel.updateStage(to: stageNumber)
                        }
                    }
                }
            }
        }
    }

    private func bioSection(bio: Binding<String>) -> some View {
        editorCard(
            title: strings.editBioSectionTitle,
            subtitle: strings.profileBioSectionTitle
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text(strings.editBioLabel)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.textSecondary)

                TextField(
                    strings.profileBioPlaceholder,
                    text: bio,
                    axis: .vertical
                )
                .lineLimit(4, reservesSpace: true)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textPrimary)
                .padding(14)
                .background(controlBackground)
            }
        }
    }

    private var selectedRouteName: String {
        viewModel.selectedRoute?.localizedName(for: preferences.resolvedLanguage) ?? strings.routeUnavailable
    }

    private var selectedStageTitle: String {
        stageTitle(for: viewModel.currentStageNumber)
    }

    private func stageTitle(for stageNumber: Int) -> String {
        let prefix = strings.stageValue(stageNumber)

        guard
            let route = viewModel.selectedRoute,
            route.stages.indices.contains(stageNumber - 1)
        else {
            return prefix
        }

        let stage = route.stages[stageNumber - 1]
        return "\(prefix) - \(stage.start.name) / \(stage.end.name)"
    }

    private func editorCard<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Layout.cardSpacing) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
            }

            content()
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
    }

    private func textField(
        title: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            TextField(title, text: text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textPrimary)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(
                    keyboardType == .phonePad ? .never : .words
                )
                .padding(14)
                .background(controlBackground)
        }
    }

    private func menuField<Content: View>(
        title: String,
        value: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(palette.textSecondary)

            Menu {
                content()
            } label: {
                HStack(spacing: 12) {
                    Text(value)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(palette.textSecondary)
                }
                .padding(14)
                .background(controlBackground)
            }
            .buttonStyle(.plain)
        }
    }

    private func labelChip(
        title: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .bold))

            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineLimit(1)
        }
        .foregroundStyle(palette.textPrimary)
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(controlBackground)
    }

    private func photoFeedbackBanner(_ feedback: PhotoFeedback) -> some View {
        let isError = feedback.kind == .error

        return HStack(spacing: 10) {
            Image(systemName: isError ? "exclamationmark.triangle.fill" : "info.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(isError ? Color.orange : palette.accent)

            Text(
                isError
                ? strings.photoPickerErrorMessage
                : strings.photoPickerCancelledMessage
            )
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundStyle(palette.textPrimary)
            .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(controlBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
            .fill(palette.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                    .stroke(palette.border, lineWidth: 1)
            )
    }

    private var controlBackground: some View {
        RoundedRectangle(cornerRadius: Layout.controlCornerRadius, style: .continuous)
            .fill(palette.surfaceMuted)
    }
}
