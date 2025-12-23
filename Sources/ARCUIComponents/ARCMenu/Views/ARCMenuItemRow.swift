import ARCDesignSystem
import SwiftUI

/// Menu item row for ARCMenu
///
/// Displays individual menu items following Apple's Human Interface Guidelines.
/// Includes support for:
/// - Icons (SF Symbols with various rendering modes)
/// - Titles and subtitles
/// - Badges (for notifications, counts, "New" labels)
/// - Disclosure indicators (chevrons)
/// - Destructive actions (red tint)
/// - Press animations with haptic feedback
struct ARCMenuItemRow: View {
    // MARK: - Properties

    let item: ARCMenuItem
    let configuration: ARCMenuConfiguration
    let action: () -> Void

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: .arcSpacingLarge) {
                // Icon
                iconView
                    .frame(width: 32, height: 32)
                    .background {
                        if !item.isDestructive {
                            RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous)
                                .fill(configuration.accentColor.opacity(0.15))
                        }
                    }

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: .arcSpacingSmall) {
                        Text(item.title)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(item.isDestructive ? .red : .primary)

                        if let badge = item.badge {
                            badgeView(text: badge)
                        }
                    }

                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)

                // Disclosure indicator
                if item.showsDisclosure {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, .arcSpacingMedium)
            .padding(.horizontal, .arcSpacingLarge)
            .background {
                if isPressed {
                    RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous)
                        .fill(Color.primary.opacity(0.05))
                }
            }
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
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
    }

    // MARK: - Icon View

    @ViewBuilder private var iconView: some View {
        item.icon.iconView(isDestructive: item.isDestructive)
            .frame(width: 22, height: 22)
    }

    // MARK: - Badge View

    @ViewBuilder
    private func badgeView(text: String) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, .arcSpacingSmall)
            .padding(.vertical, 3) // Intentionally small for badge
            .background {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                configuration.accentColor,
                                configuration.accentColor.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .shadow(color: configuration.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview Provider

#Preview("Menu Item - Standard") {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 0) {
            ARCMenuItemRow(
                item: .Common.settings(action: {}),
                configuration: .default,
                action: {
                    print("Settings tapped")
                }
            )

            Divider()
                .padding(.leading, 64)

            ARCMenuItemRow(
                item: .Common.profile(action: {}),
                configuration: .default,
                action: {
                    print("Profile tapped")
                }
            )
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .padding()
    }
}

#Preview("Menu Item - With Badge") {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 8) {
            ARCMenuItemRow(
                item: .Common.plan(badge: "Pro", action: {}),
                configuration: .premium,
                action: {
                    print("Plan tapped")
                }
            )

            ARCMenuItemRow(
                item: .Common.notifications(badge: "3", action: {}),
                configuration: .premium,
                action: {
                    print("Notifications tapped")
                }
            )
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .padding()
    }
}

#Preview("Menu Item - Destructive") {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        VStack(spacing: 0) {
            ARCMenuItemRow(
                item: .Common.about(action: {}),
                configuration: .default,
                action: {}
            )

            Divider()
                .padding(.leading, 64)

            ARCMenuItemRow(
                item: .Common.logout(action: {}),
                configuration: .default,
                action: {
                    print("Logout tapped")
                }
            )
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
        }
        .padding()
    }
}

#Preview("Menu Item - All Variants") {
    ScrollView {
        VStack(spacing: 12) {
            Group {
                ARCMenuItemRow(
                    item: .Common.profile(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.settings(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.plan(badge: "Premium", action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.notifications(badge: "12", action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.privacy(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.help(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.contact(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.about(action: {}),
                    configuration: .fitness,
                    action: {}
                )

                ARCMenuItemRow(
                    item: .Common.logout(action: {}),
                    configuration: .fitness,
                    action: {}
                )
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .padding()
    }
    .background(Color.green.opacity(0.2))
}
