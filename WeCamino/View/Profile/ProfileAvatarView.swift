import SwiftUI
import UIKit

/// Shared avatar renderer for the pilgrim profile.
struct ProfileAvatarView: View {
    // MARK: - Properties

    let initials: String
    let imageData: Data?
    let size: CGFloat
    let accentColor: Color
    let backgroundColor: Color

    // MARK: - Body

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            if let avatarImage {
                avatarImage
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initials)
                    .font(.system(size: size * 0.32, weight: .bold, design: .rounded))
                    .foregroundStyle(accentColor)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    // MARK: - Private Views

    private var avatarImage: Image? {
        guard
            let imageData,
            let uiImage = UIImage(data: imageData)
        else {
            return nil
        }

        return Image(uiImage: uiImage)
    }
}

#if DEBUG
// MARK: - Previews

#Preview("Profile Avatar") {
    HStack(spacing: 18) {
        ProfileAvatarView(
            initials: "AC",
            imageData: nil,
            size: 76,
            accentColor: .blue,
            backgroundColor: .blue.opacity(0.14)
        )

        ProfileAvatarView(
            initials: "WC",
            imageData: nil,
            size: 104,
            accentColor: .orange,
            backgroundColor: .orange.opacity(0.14)
        )
    }
    .padding()
    .weCaminoPreviewEnvironment()
}
#endif
