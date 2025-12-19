import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// User profile header for ARCMenu
///
/// Displays user information at the top of the menu, following Apple's
/// design patterns for user profile sections (similar to App Store, Music, etc.)
///
/// Features:
/// - Large avatar with subtle shadow
/// - Name with emphasis (semibold)
/// - Optional email or subtitle
/// - Tap gesture for profile navigation
/// - Smooth hover/press animations
struct ARCMenuUserHeader: View {
    // MARK: - Properties

    let user: ARCMenuUser
    let configuration: ARCMenuConfiguration
    let onTap: (() -> Void)?

    @State private var isPressed = false

    // MARK: - Initialization

    init(
        user: ARCMenuUser,
        configuration: ARCMenuConfiguration,
        onTap: (() -> Void)? = nil
    ) {
        self.user = user
        self.configuration = configuration
        self.onTap = onTap
    }

    // MARK: - Body

    var body: some View {
        Button {
            onTap?()
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
        } label: {
            HStack(spacing: .arcSpacingLarge) {
                // Avatar
                avatarView
                    .shadow(
                        color: .arcShadowLight,
                        radius: .arcSpacingSmall,
                        x: 0,
                        y: .arcSpacingXSmall
                    )

                // User info
                VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                    Text(user.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if let email = user.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else if let subtitle = user.subtitle {
                        HStack(spacing: .arcSpacingXSmall) {
                            Text(subtitle)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(configuration.accentColor)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(configuration.accentColor.opacity(0.6))
                        }
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.arcPaddingCard)
            .background {
                // Subtle background for the header section
                RoundedRectangle(cornerRadius: .arcCornerRadiusLarge, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: .arcCornerRadiusLarge, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    }
            }
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .disabled(onTap == nil)
    }

    // MARK: - Avatar View

    @ViewBuilder private var avatarView: some View {
        user.avatarImage.avatarView(size: 60)
            .overlay {
                // Subtle ring around avatar
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
    }
}

// MARK: - Preview Provider

#Preview("User Header - Full Info") {
    ZStack {
        Color.black.ignoresSafeArea()

        ARCMenuUserHeader(
            user: ARCMenuUser(
                name: "Carlos Ramirez",
                email: "carlos@arclabs.studio",
                avatarImage: .initials("CR")
            ),
            configuration: .default,
            onTap: {
                print("Profile tapped")
            }
        )
        .padding()
    }
}

#Preview("User Header - With Subtitle") {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        ARCMenuUserHeader(
            user: ARCMenuUser(
                name: "Jane Cooper",
                subtitle: "Premium Member",
                avatarImage: .initials("JC")
            ),
            configuration: .premium,
            onTap: {
                print("Profile tapped")
            }
        )
        .padding()
    }
}

#Preview("User Header - SF Symbol") {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ARCMenuUserHeader(
            user: ARCMenuUser(
                name: "Guest User",
                email: "guest@example.com",
                avatarImage: .systemImage("person.circle.fill")
            ),
            configuration: .default
        )
        .padding()
    }
}
