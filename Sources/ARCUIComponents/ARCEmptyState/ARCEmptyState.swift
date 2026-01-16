//
//  ARCEmptyState.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Empty state component following Apple's Human Interface Guidelines
///
/// Displays informative, encouraging content when there's nothing to show,
/// with optional action buttons to guide users toward their next step.
///
/// ## Overview
///
/// Empty states are crucial for user experience, transforming potentially
/// frustrating moments into opportunities for guidance and engagement.
///
/// ARCEmptyState follows Apple's design patterns as seen in Mail, Photos,
/// Notes, and other system apps, providing:
/// - Clear icon representing the empty state
/// - Concise, helpful title
/// - Supportive message explaining what happened
/// - Optional call-to-action button
///
/// ## Topics
///
/// ### Creating Empty States
///
/// - ``init(configuration:action:)``
///
/// ### Convenience Initializers
///
/// - ``init(icon:iconColor:title:message:actionTitle:showsAction:accentColor:action:)``
///
/// ## Usage
///
/// ```swift
/// // With preset configuration
/// ARCEmptyState(configuration: .noFavorites) {
///     navigateToExplore()
/// }
///
/// // With custom configuration
/// ARCEmptyState(
///     icon: "photo",
///     title: "No Photos",
///     message: "Add photos to get started",
///     actionTitle: "Add Photo",
///     showsAction: true
/// ) {
///     presentPhotoPicker()
/// }
/// ```
///
/// - Note: Empty states should be centered in the available space and
///   avoid overwhelming users with too much information.
@available(iOS 17.0, *)
public struct ARCEmptyState: View {
    // MARK: - Properties

    /// Configuration for appearance
    private let configuration: ARCEmptyStateConfiguration

    /// Optional action to perform when button is tapped
    private let action: (() -> Void)?

    // MARK: - State

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Initialization

    /// Creates an empty state with configuration and optional action
    ///
    /// - Parameters:
    ///   - configuration: Visual configuration
    ///   - action: Optional action when button is tapped
    public init(
        configuration: ARCEmptyStateConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.action = action
    }

    /// Creates an empty state with individual parameters
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name
    ///   - iconColor: Icon color
    ///   - title: Primary title
    ///   - message: Supporting message
    ///   - actionTitle: Action button title
    ///   - showsAction: Whether to show action button
    ///   - accentColor: Accent color for button
    ///   - action: Optional action when button is tapped
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
        contentView
            .modifier(GlassBackgroundModifier(configuration: configuration))
            .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: configuration.spacing) {
            // Icon
            Image(systemName: configuration.icon)
                .font(.system(size: iconSize))
                .foregroundStyle(configuration.iconColor.gradient)
                .symbolRenderingMode(.hierarchical)
                .accessibilityHidden(true)

            // Text content
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

            // Action button
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
        .frame(maxWidth: maxWidth)
    }

    // MARK: - Computed Properties

    /// Icon size based on Dynamic Type
    private var iconSize: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium:
            64
        case .large, .xLarge, .xxLarge:
            72
        case .xxxLarge:
            80
        default: // Accessibility sizes
            88
        }
    }

    /// Maximum width for content
    private var maxWidth: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small, .medium, .large:
            320
        case .xLarge, .xxLarge, .xxxLarge:
            360
        default: // Accessibility sizes
            400
        }
    }
}

// MARK: - Glass Background Modifier

/// Conditionally applies liquid glass based on background style
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
