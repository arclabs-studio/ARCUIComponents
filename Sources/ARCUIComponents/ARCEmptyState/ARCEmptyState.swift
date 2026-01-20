//
//  ARCEmptyState.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Empty state component with ARC Labs customizations over native SwiftUI.
///
/// ## Why ARCEmptyState exists (vs ContentUnavailableView)
///
/// SwiftUI's `ContentUnavailableView` (iOS 17+) provides basic empty states,
/// but ARCEmptyState adds capabilities needed for ARC Labs apps:
///
/// | Feature | ContentUnavailableView | ARCEmptyState |
/// |---------|----------------------|---------------|
/// | Icon color customization | ❌ System only | ✅ Any color |
/// | Liquid Glass background | ❌ | ✅ |
/// | Custom button styles | ❌ Default buttons | ✅ Capsule gradient |
/// | Adaptive icon sizing | ❌ Fixed | ✅ Dynamic Type aware |
/// | Brand presets | ❌ Only `.search` | ✅ Multiple |
///
/// ## Automatic Native Fallback
///
/// When using default styling (no glass, secondary icon color, no action),
/// ARCEmptyState internally uses `ContentUnavailableView` for system consistency.
///
/// ## Usage
///
/// ```swift
/// // Simple - uses ContentUnavailableView internally
/// ARCEmptyState(configuration: .noResults)
///
/// // With action button - uses ARC custom styling
/// ARCEmptyState(configuration: .noFavorites) {
///     navigateToExplore()
/// }
///
/// // Premium glass effect
/// ARCEmptyState(configuration: .premium) {
///     presentUpgrade()
/// }
/// ```
@available(iOS 17.0, *)
public struct ARCEmptyState: View {
    // MARK: - Properties

    private let configuration: ARCEmptyStateConfiguration
    private let action: (() -> Void)?

    // MARK: - Environment

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Initialization

    /// Creates an empty state with configuration and optional action.
    ///
    /// - Parameters:
    ///   - configuration: Visual and content configuration
    ///   - action: Action when the button is tapped (requires `showsAction: true`)
    public init(
        configuration: ARCEmptyStateConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.action = action
    }

    /// Creates an empty state with individual parameters.
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name
    ///   - iconColor: Icon tint color (default: `.secondary`)
    ///   - title: Primary title text
    ///   - message: Supporting description
    ///   - actionTitle: Button title (default: "Get Started")
    ///   - showsAction: Show action button (default: `false`)
    ///   - accentColor: Button accent color (default: `.blue`)
    ///   - action: Action when the button is tapped
    public init(
        icon: String,
        iconColor: Color = .secondary,
        title: String,
        message: String,
        actionTitle: String = "Get Started",
        showsAction: Bool = false,
        accentColor: Color = .blue,
        action: (() -> Void)? = nil
    ) {
        configuration = ARCEmptyStateConfiguration(
            icon: icon,
            iconColor: iconColor,
            title: title,
            message: message,
            actionTitle: actionTitle,
            showsAction: showsAction,
            accentColor: accentColor
        )
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if shouldUseNativeView {
                nativeContentUnavailableView
            } else {
                customARCView
            }
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Native ContentUnavailableView

    /// Uses native SwiftUI when no ARC-specific customizations are needed.
    @ViewBuilder private var nativeContentUnavailableView: some View {
        ContentUnavailableView {
            Label(configuration.title, systemImage: configuration.icon)
        } description: {
            Text(configuration.message)
        }
    }

    /// Determines if we can use native ContentUnavailableView.
    ///
    /// Returns `true` when:
    /// - No liquid glass background
    /// - Default icon color (secondary)
    /// - No action button
    private var shouldUseNativeView: Bool {
        guard case .translucent = configuration.backgroundStyle else { return false }
        guard configuration.iconColor == .secondary else { return false }
        guard !configuration.showsAction else { return false }
        return true
    }

    // MARK: - Custom ARC View

    @ViewBuilder private var customARCView: some View {
        VStack(spacing: configuration.spacing) {
            iconView
            textContent
            actionButton
        }
        .frame(maxWidth: maxWidth)
        .modifier(GlassBackgroundModifier(configuration: configuration))
    }

    @ViewBuilder private var iconView: some View {
        Image(systemName: configuration.icon)
            .font(.system(size: iconSize))
            .foregroundStyle(configuration.iconColor.gradient)
            .symbolRenderingMode(.hierarchical)
            .accessibilityHidden(true)
    }

    @ViewBuilder private var textContent: some View {
        VStack(spacing: .arcSpacingSmall) {
            Text(configuration.title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text(configuration.message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal)
    }

    @ViewBuilder private var actionButton: some View {
        if configuration.showsAction, let action {
            Button(action: action) {
                Text(configuration.actionTitle)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, .arcSpacingXLarge)
                    .padding(.vertical, .arcSpacingMedium)
                    .background(
                        Capsule()
                            .fill(configuration.accentColor.gradient)
                    )
            }
            .buttonStyle(.plain)
            .padding(.top, .arcSpacingSmall)
            .accessibilityLabel(configuration.actionTitle)
            .accessibilityHint("Tap to \(configuration.actionTitle.lowercased())")
        }
    }

    // MARK: - Adaptive Sizing

    private var iconSize: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium:
            64
        case .large, .xLarge, .xxLarge:
            72
        case .xxxLarge:
            80
        default:
            88
        }
    }

    private var maxWidth: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium, .large:
            320
        case .xLarge, .xxLarge, .xxxLarge:
            360
        default:
            400
        }
    }
}

// MARK: - Glass Background Modifier

@available(iOS 17.0, macOS 14.0, *)
private struct GlassBackgroundModifier: ViewModifier {
    let configuration: ARCEmptyStateConfiguration

    func body(content: Content) -> some View {
        if case .liquidGlass = configuration.backgroundStyle {
            content
                .padding(.arcPaddingSection)
                .liquidGlass(configuration: configuration, isInteractive: false)
        } else {
            content
        }
    }
}

// MARK: - Preview

#Preview("No Favorites") {
    ARCEmptyState(configuration: .noFavorites) {
        print("Navigate to browse")
    }
}

#Preview("No Results") {
    ARCEmptyState(configuration: .noResults)
}

#Preview("Error State") {
    ARCEmptyState(configuration: .error) {
        print("Retry action")
    }
}

#Preview("Dark Mode") {
    ARCEmptyState(configuration: .offline) {
        print("Open settings")
    }
    .preferredColorScheme(.dark)
}

#Preview("Accessibility - Extra Large") {
    ARCEmptyState(configuration: .noData)
        .environment(\.dynamicTypeSize, .accessibility3)
}
