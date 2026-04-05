import SwiftUI

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
    static func make(for colorScheme: ColorScheme) -> AppPalette {
        switch colorScheme {
        case .light:
            AppPalette(
                backgroundTop: Color(red: 0.98, green: 0.98, blue: 0.97),
                backgroundMiddle: Color(red: 0.94, green: 0.97, blue: 1.00),
                backgroundBottom: Color(red: 0.98, green: 0.95, blue: 0.91),
                glowPrimary: Color.white.opacity(0.84),
                glowSecondary: Color(red: 0.80, green: 0.93, blue: 1.00).opacity(0.55),
                surface: Color.white.opacity(0.96),
                surfaceMuted: Color.white.opacity(0.92),
                border: Color.black.opacity(0.05),
                textPrimary: Color(red: 0.08, green: 0.11, blue: 0.16),
                textSecondary: Color.black.opacity(0.56),
                shadow: Color.black.opacity(0.08),
                accent: Color(red: 0.95, green: 0.48, blue: 0.15),
                accentSoft: Color(red: 1.00, green: 0.94, blue: 0.84),
                selectedTabFill: Color(red: 0.97, green: 0.99, blue: 1.00),
                tabBarStroke: Color.white.opacity(0.82)
            )
        case .dark:
            AppPalette(
                backgroundTop: Color(red: 0.07, green: 0.09, blue: 0.12),
                backgroundMiddle: Color(red: 0.09, green: 0.14, blue: 0.19),
                backgroundBottom: Color(red: 0.10, green: 0.11, blue: 0.14),
                glowPrimary: Color.white.opacity(0.08),
                glowSecondary: Color(red: 0.24, green: 0.42, blue: 0.58).opacity(0.26),
                surface: Color(red: 0.11, green: 0.13, blue: 0.17).opacity(0.96),
                surfaceMuted: Color(red: 0.14, green: 0.17, blue: 0.21).opacity(0.96),
                border: Color.white.opacity(0.07),
                textPrimary: Color(red: 0.96, green: 0.97, blue: 0.99),
                textSecondary: Color.white.opacity(0.62),
                shadow: Color.black.opacity(0.28),
                accent: Color(red: 1.00, green: 0.66, blue: 0.28),
                accentSoft: Color(red: 0.28, green: 0.22, blue: 0.15),
                selectedTabFill: Color(red: 0.18, green: 0.22, blue: 0.27),
                tabBarStroke: Color.white.opacity(0.09)
            )
        @unknown default:
            make(for: .light)
        }
    }
}
