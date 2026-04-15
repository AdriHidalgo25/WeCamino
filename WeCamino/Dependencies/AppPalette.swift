import SwiftUI

/// Semantic palette for the app shell and feature surfaces.
///
/// Using semantic colors keeps the UI consistent when screens evolve and helps
/// avoid scattering ad-hoc color decisions through SwiftUI views.
struct AppPalette {
    let backgroundTop: Color
    let backgroundMiddle: Color
    let backgroundBottom: Color
    let glowPrimary: Color
    let glowSecondary: Color
    let surface: Color
    let surfaceMuted: Color
    let border: Color
    let textPrimary: Color
    let textSecondary: Color
    let shadow: Color
    let accent: Color
    let accentSoft: Color
    let selectedTabFill: Color
    let tabBarStroke: Color
}

extension AppPalette {
    // MARK: - Factory

    /// Returns the semantic palette for the active system color scheme.
    static func make(for colorScheme: ColorScheme) -> AppPalette {
        switch colorScheme {
        case .light:
            AppPalette(
                backgroundTop: Color(red: 0.97, green: 0.97, blue: 0.96),
                backgroundMiddle: Color(red: 0.96, green: 0.96, blue: 0.95),
                backgroundBottom: Color(red: 0.95, green: 0.95, blue: 0.94),
                glowPrimary: .clear,
                glowSecondary: .clear,
                surface: Color.white,
                surfaceMuted: Color(red: 0.95, green: 0.95, blue: 0.94),
                border: Color.black.opacity(0.06),
                textPrimary: Color(red: 0.08, green: 0.11, blue: 0.16),
                textSecondary: Color.black.opacity(0.58),
                shadow: Color.black.opacity(0.04),
                accent: Color(red: 0.22, green: 0.44, blue: 0.77),
                accentSoft: Color(red: 0.91, green: 0.94, blue: 0.99),
                selectedTabFill: Color(red: 0.95, green: 0.96, blue: 0.98),
                tabBarStroke: Color.black.opacity(0.05)
            )
        case .dark:
            AppPalette(
                backgroundTop: Color(red: 0.08, green: 0.09, blue: 0.11),
                backgroundMiddle: Color(red: 0.08, green: 0.09, blue: 0.11),
                backgroundBottom: Color(red: 0.09, green: 0.10, blue: 0.12),
                glowPrimary: .clear,
                glowSecondary: .clear,
                surface: Color(red: 0.12, green: 0.13, blue: 0.16),
                surfaceMuted: Color(red: 0.15, green: 0.16, blue: 0.19),
                border: Color.white.opacity(0.06),
                textPrimary: Color(red: 0.96, green: 0.97, blue: 0.99),
                textSecondary: Color.white.opacity(0.64),
                shadow: Color.black.opacity(0.16),
                accent: Color(red: 0.55, green: 0.72, blue: 0.98),
                accentSoft: Color(red: 0.20, green: 0.25, blue: 0.34),
                selectedTabFill: Color(red: 0.17, green: 0.19, blue: 0.23),
                tabBarStroke: Color.white.opacity(0.05)
            )
        @unknown default:
            make(for: .light)
        }
    }
}
