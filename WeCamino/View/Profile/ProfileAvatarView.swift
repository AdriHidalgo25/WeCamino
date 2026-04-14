import SwiftUI
import UIKit

/// Shared avatar renderer for the pilgrim profile.
struct ProfileAvatarView: View {
    let initials: String
    let imageData: Data?
    let size: CGFloat
    let accentColor: Color
    let backgroundColor: Color

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
