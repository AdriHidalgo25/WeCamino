import SwiftUI

struct SettingsScene: View {
    private enum Layout {
        static let contentSpacing: CGFloat = 22
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 24
        static let embeddedTopPadding: CGFloat = 18
        static let bottomPadding: CGFloat = 120
        static let appearanceOptionHeight: CGFloat = 92
        static let appearanceIconSize: CGFloat = 34
        static let appearanceIconCornerRadius: CGFloat = 12
    }

    @Environment(AppPreferencesStore.self) private var preferences
    @Environment(\.appStrings) private var strings
    @Environment(\.colorScheme) private var colorScheme

    private let isEmbeddedInNavigation: Bool

    init(isEmbeddedInNavigation: Bool = false) {
        self.isEmbeddedInNavigation = isEmbeddedInNavigation
    }

    private var palette: AppPalette {
        AppPalette.make(for: colorScheme)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.contentSpacing) {
                settingsHeader
                languageSection
                appearanceSection
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .safeAreaPadding(.top, isEmbeddedInNavigation ? Layout.embeddedTopPadding : Layout.topPadding)
            .safeAreaPadding(.bottom, Layout.bottomPadding)
        }
        .navigationTitle(isEmbeddedInNavigation ? strings.settingsTitle : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(isEmbeddedInNavigation ? .visible : .hidden, for: .navigationBar)
    }

    private var settingsHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(strings.settingsTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(palette.textPrimary)

            Text(strings.settingsSubtitle)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(palette.textSecondary)
        }
    }

    private var languageSection: some View {
        settingsCard(
            title: strings.languageSectionTitle,
            subtitle: strings.languageSectionSubtitle
        ) {
            VStack(spacing: 12) {
                ForEach(AppLanguage.allCases, id: \.self) { option in
                    selectionRow(
                        title: strings.languageLabel(for: option),
                        subtitle: languageDetail(for: option),
                        isSelected: preferences.language == option,
                        leadingContent: {
                            languageBadge(for: option, isSelected: preferences.language == option)
                        }
                    ) {
                        withAnimation(.snappy(duration: 0.28, extraBounce: 0.02)) {
                            preferences.language = option
                        }
                    }
                }
            }
        }
    }

    private var appearanceSection: some View {
        settingsCard(
            title: strings.appearanceSectionTitle,
            subtitle: strings.appearanceSectionSubtitle
        ) {
            HStack(spacing: 12) {
                ForEach(AppAppearance.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.snappy(duration: 0.28, extraBounce: 0.02)) {
                            preferences.appearance = option
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: iconName(for: option))
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(preferences.appearance == option ? palette.textPrimary : palette.textSecondary)
                                .frame(width: Layout.appearanceIconSize, height: Layout.appearanceIconSize)
                                .background(
                                    RoundedRectangle(cornerRadius: Layout.appearanceIconCornerRadius, style: .continuous)
                                        .fill(preferences.appearance == option ? palette.accentSoft : palette.surfaceMuted)
                                )

                            Text(strings.appearanceLabel(for: option))
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(palette.textPrimary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                        }
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, minHeight: Layout.appearanceOptionHeight, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(preferences.appearance == option ? palette.surfaceMuted : palette.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(preferences.appearance == option ? palette.accent.opacity(0.38) : palette.border, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func settingsCard<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 18) {
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
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(palette.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(palette.border, lineWidth: 1)
                )
        )
    }

    private func selectionRow(
        title: String,
        subtitle: String,
        isSelected: Bool,
        @ViewBuilder leadingContent: () -> some View,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                leadingContent()

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.textSecondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected ? palette.accent : palette.textSecondary.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? palette.surfaceMuted : palette.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(isSelected ? palette.accent.opacity(0.38) : palette.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func languageDetail(for option: AppLanguage) -> String {
        switch option {
        case .system:
            switch strings.language {
            case .spanish:
                "Sigue el idioma del dispositivo."
            case .french:
                "Suit la langue de l'appareil."
            case .english, .system:
                "Follow the device language."
            }
        case .english:
            switch strings.language {
            case .spanish:
                "Usa la interfaz en inglés."
            case .french:
                "Utilise l'interface en anglais."
            case .english, .system:
                "Use the app interface in English."
            }
        case .spanish:
            switch strings.language {
            case .spanish:
                "Usa la interfaz en español."
            case .french:
                "Utilise l'interface en espagnol."
            case .english, .system:
                "Use the app interface in Spanish."
            }
        case .french:
            switch strings.language {
            case .spanish:
                "Usa la interfaz en francés."
            case .french:
                "Utilise l'interface en français."
            case .english, .system:
                "Use the app interface in French."
            }
        }
    }

    private func iconName(for option: AppAppearance) -> String {
        switch option {
        case .system:
            "circle.lefthalf.filled"
        case .light:
            "sun.max.fill"
        case .dark:
            "moon.fill"
        }
    }

    private func languageBadge(for option: AppLanguage, isSelected: Bool) -> some View {
        Text(flag(for: option))
            .font(.system(size: 22))
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? palette.accentSoft : palette.surfaceMuted)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? palette.accent.opacity(0.18) : palette.border, lineWidth: 1)
            )
    }

    private func flag(for option: AppLanguage) -> String {
        switch option {
        case .system:
            "🌐"
        case .english:
            "🇬🇧"
        case .spanish:
            "🇪🇸"
        case .french:
            "🇫🇷"
        }
    }
}
