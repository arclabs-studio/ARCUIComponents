//
//  ARCActionButton.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - ARCActionButton

/// A standardized action button with consistent styling, loading states, and haptic feedback
///
/// `ARCActionButton` is the primary interactive button used throughout apps for CTAs,
/// form submissions, and important actions following Apple's Human Interface Guidelines.
///
/// ## Overview
///
/// Per Apple HIG: "A button initiates an instantaneous action. Versatile and highly
/// customizable, buttons give people simple, familiar ways to do tasks in your app."
///
/// ARCActionButton provides:
/// - Multiple visual styles (filled, outlined, ghost, glass)
/// - Three size variants (small, medium, large)
/// - Built-in loading state with spinner
/// - Haptic feedback on tap
/// - Full accessibility support
///
/// ## Topics
///
/// ### Content Types
///
/// - ``Content``
/// - ``IconPosition``
///
/// ### Creating Buttons
///
/// - ``init(_:isLoading:configuration:action:)``
/// - ``init(_:icon:iconPosition:isLoading:configuration:action:)``
/// - ``init(icon:isLoading:configuration:action:)``
///
/// ## Usage
///
/// ```swift
/// // Primary CTA
/// ARCActionButton("Get Started") {
///     startOnboarding()
/// }
///
/// // With loading state
/// ARCActionButton("Save", isLoading: $isSaving) {
///     await saveChanges()
/// }
///
/// // With icon
/// ARCActionButton("Add to Favorites", icon: "heart.fill") {
///     addToFavorites()
/// }
///
/// // Destructive action
/// ARCActionButton("Delete", icon: "trash", configuration: .destructive) {
///     deleteItem()
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCActionButton: View {
    // MARK: - Content

    /// Content types for action buttons
    public enum Content: Equatable, Sendable {
        /// Text label only
        case text(String)

        /// SF Symbol icon only
        case icon(String)

        /// Text with icon
        case textAndIcon(String, String, IconPosition)
    }

    // MARK: - IconPosition

    /// Position of icon relative to text
    public enum IconPosition: Sendable {
        /// Icon before text
        case leading

        /// Icon after text
        case trailing
    }

    // MARK: - Properties

    private let content: Content
    private let action: () -> Void
    private let configuration: ARCActionButtonConfiguration

    @Binding private var isLoading: Bool

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates an action button with text content
    ///
    /// - Parameters:
    ///   - title: The button label text
    ///   - isLoading: Binding to loading state
    ///   - configuration: Button configuration
    ///   - action: Action to perform on tap
    public init(
        _ title: String,
        isLoading: Binding<Bool> = .constant(false),
        configuration: ARCActionButtonConfiguration = .primary,
        action: @escaping () -> Void
    ) {
        content = .text(title)
        _isLoading = isLoading
        self.configuration = configuration
        self.action = action
    }

    /// Creates an action button with text and icon
    ///
    /// - Parameters:
    ///   - title: The button label text
    ///   - icon: SF Symbol name
    ///   - iconPosition: Position of icon (default: .leading)
    ///   - isLoading: Binding to loading state
    ///   - configuration: Button configuration
    ///   - action: Action to perform on tap
    public init(
        _ title: String,
        icon: String,
        iconPosition: IconPosition = .leading,
        isLoading: Binding<Bool> = .constant(false),
        configuration: ARCActionButtonConfiguration = .primary,
        action: @escaping () -> Void
    ) {
        content = .textAndIcon(title, icon, iconPosition)
        _isLoading = isLoading
        self.configuration = configuration
        self.action = action
    }

    /// Creates an icon-only action button
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name
    ///   - isLoading: Binding to loading state
    ///   - configuration: Button configuration
    ///   - action: Action to perform on tap
    public init(
        icon: String,
        isLoading: Binding<Bool> = .constant(false),
        configuration: ARCActionButtonConfiguration = .iconOnly,
        action: @escaping () -> Void
    ) {
        content = .icon(icon)
        _isLoading = isLoading
        self.configuration = configuration
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button {
            triggerHaptic()
            action()
        } label: {
            buttonContent
        }
        .buttonStyle(ARCActionButtonStyle(buttonConfiguration: configuration, isLoading: isLoading))
        .disabled(configuration.isDisabled || isLoading)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(isLoading ? "Loading" : "")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Button Content

    @ViewBuilder private var buttonContent: some View {
        HStack(spacing: 8) {
            if isLoading {
                loadingIndicator
            } else {
                contentView
            }
        }
        .font(configuration.size.font)
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, horizontalPadding)
        .frame(height: configuration.size.height)
        .frame(maxWidth: configuration.isFullWidth ? .infinity : nil)
        .frame(minWidth: isIconOnly ? configuration.size.height : nil)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay {
            if configuration.style == .outlined {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .strokeBorder(configuration.color, lineWidth: 1.5)
            }
        }
        .shadow(
            color: shouldShowShadow ? configuration.shadow.color : .clear,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
        .opacity(configuration.isDisabled ? 0.4 : 1.0)
    }

    @ViewBuilder private var contentView: some View {
        switch content {
        case let .text(title):
            Text(title)

        case let .icon(iconName):
            Image(systemName: iconName)
                .font(.system(size: configuration.size.iconSize, weight: .semibold))

        case let .textAndIcon(title, iconName, position):
            if position == .leading {
                Image(systemName: iconName)
                    .font(.system(size: configuration.size.iconSize, weight: .semibold))
                Text(title)
            } else {
                Text(title)
                Image(systemName: iconName)
                    .font(.system(size: configuration.size.iconSize, weight: .semibold))
            }
        }
    }

    @ViewBuilder private var loadingIndicator: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(configuration.resolvedLoadingColor)
            .scaleEffect(loadingScale)
    }

    @ViewBuilder private var backgroundView: some View {
        switch configuration.style {
        case .filled:
            configuration.color

        case .outlined, .ghost:
            Color.clear

        case .glass:
            glassBackground
        }
    }

    @ViewBuilder private var glassBackground: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.5
                    )
            }
    }

    // MARK: - Computed Properties

    private var foregroundColor: Color {
        configuration.isDisabled ? .secondary : configuration.resolvedTextColor
    }

    private var horizontalPadding: CGFloat {
        isIconOnly ? 0 : configuration.size.horizontalPadding
    }

    private var isIconOnly: Bool {
        if case .icon = content {
            return true
        }
        return false
    }

    private var shouldShowShadow: Bool {
        configuration.style == .filled || configuration.style == .glass
    }

    private var loadingScale: CGFloat {
        switch configuration.size {
        case .small: 0.7
        case .medium: 0.85
        case .large: 1.0
        }
    }

    private var accessibilityLabel: String {
        switch content {
        case let .text(title):
            title
        case let .icon(iconName):
            iconName.replacingOccurrences(of: ".", with: " ")
        case let .textAndIcon(title, _, _):
            title
        }
    }

    // MARK: - Haptic Feedback

    private func triggerHaptic() {
        guard configuration.hapticFeedback, !reduceMotion else { return }

        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Button Styles") {
    VStack(spacing: 16) {
        ARCActionButton("Primary") {}
        ARCActionButton("Secondary", configuration: .secondary) {}
        ARCActionButton("Destructive", configuration: .destructive) {}
        ARCActionButton("Ghost", configuration: .ghost) {}
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Button Sizes") {
    VStack(spacing: 16) {
        ARCActionButton("Small", configuration: .small) {}
        ARCActionButton("Medium") {}
        ARCActionButton("Large", configuration: .large) {}
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Icons") {
    VStack(spacing: 16) {
        ARCActionButton("Add to Cart", icon: "cart.fill") {}
        ARCActionButton("Share", icon: "square.and.arrow.up", iconPosition: .trailing) {}
        ARCActionButton(icon: "plus") {}
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("States") {
    VStack(spacing: 16) {
        ARCActionButton("Normal") {}
        ARCActionButton("Loading", isLoading: .constant(true)) {}
        ARCActionButton(
            "Disabled",
            configuration: ARCActionButtonConfiguration(isDisabled: true)
        ) {}
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Full Width") {
    VStack(spacing: 16) {
        ARCActionButton(
            "Continue",
            configuration: ARCActionButtonConfiguration(isFullWidth: true)
        ) {}

        ARCActionButton(
            "Get Started",
            icon: "arrow.right",
            iconPosition: .trailing,
            configuration: ARCActionButtonConfiguration(
                size: .large,
                isFullWidth: true
            )
        ) {}
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Glass Style") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 16) {
            ARCActionButton("Glass Button", configuration: .glass) {}
            ARCActionButton("Apply Filter", icon: "slider.horizontal.3", configuration: .glass) {}
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 16) {
        ARCActionButton("Primary") {}
        ARCActionButton("Secondary", configuration: .secondary) {}
        ARCActionButton("Ghost", configuration: .ghost) {}
    }
    .padding()
    .preferredColorScheme(.dark)
}
