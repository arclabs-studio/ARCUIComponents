//
//  ARCFavoriteButton.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Favorite button component following Apple's Human Interface Guidelines
///
/// An animated toggle button for marking content as favorite, matching the
/// interaction patterns found in Music, Podcasts, Books, and other Apple apps.
///
/// ## Overview
///
/// ARCFavoriteButton provides a delightful interaction for toggling favorite state,
/// complete with:
/// - Smooth spring animation when toggling
/// - Symbol effect animation (iOS 17+)
/// - Haptic feedback
/// - Accessibility support
/// - Minimum 44x44pt touch target per HIG
///
/// ## Topics
///
/// ### Creating Favorite Buttons
///
/// - ``init(isFavorite:configuration:onToggle:)``
///
/// ### Convenience Initializers
///
/// - ``init(isFavorite:favoriteColor:size:onToggle:)``
///
/// ## Usage
///
/// ```swift
/// @State private var isFavorite = false
///
/// var body: some View {
///     ARCFavoriteButton(
///         isFavorite: $isFavorite,
///         favoriteColor: .pink
///     ) { newValue in
///         // Handle favorite state change
///         saveFavoriteState(newValue)
///     }
/// }
/// ```
///
/// - Note: The button automatically handles animations, haptics, and accessibility.
///   You only need to provide the state binding and optional change handler.
@available(iOS 17.0, *)
public struct ARCFavoriteButton: View {
    // MARK: - Properties

    /// Current favorite state
    @Binding private var isFavorite: Bool

    /// Configuration for appearance
    private let configuration: ARCFavoriteButtonConfiguration

    /// Optional callback when state changes
    private let onToggle: ((Bool) -> Void)?

    // MARK: - Initialization

    /// Creates a favorite button with configuration
    ///
    /// - Parameters:
    ///   - isFavorite: Binding to favorite state
    ///   - configuration: Visual configuration
    ///   - onToggle: Optional callback when state changes
    public init(
        isFavorite: Binding<Bool>,
        configuration: ARCFavoriteButtonConfiguration = .default,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        _isFavorite = isFavorite
        self.configuration = configuration
        self.onToggle = onToggle
    }

    /// Creates a favorite button with common parameters
    ///
    /// - Parameters:
    ///   - isFavorite: Binding to favorite state
    ///   - favoriteColor: Color when favorited
    ///   - size: Button size
    ///   - onToggle: Optional callback when state changes
    public init(
        isFavorite: Binding<Bool>,
        favoriteColor: Color = .pink,
        size: ARCFavoriteButtonConfiguration.ButtonSize = .medium,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        _isFavorite = isFavorite
        configuration = ARCFavoriteButtonConfiguration(
            favoriteColor: favoriteColor,
            size: size
        )
        self.onToggle = onToggle
    }

    // MARK: - Body

    public var body: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? configuration.favoriteIcon : configuration.unfavoriteIcon)
                .font(.system(size: configuration.size.iconSize))
                .foregroundStyle(isFavorite
                    ? configuration.favoriteColor.gradient
                    : configuration.unfavoriteColor.gradient)
                    .symbolEffect(.bounce, value: isFavorite)
                    .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(FavoriteButtonStyle(configuration: configuration))
        .accessibilityLabel(isFavorite ? "Favorited" : "Not favorited")
        .accessibilityHint("Tap to \(isFavorite ? "remove from" : "add to") favorites")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Actions

    private func toggleFavorite() {
        // Provide haptic feedback
        if configuration.hapticFeedback {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        // Animate state change
        withAnimation(.spring(response: configuration.animationDuration, dampingFraction: 0.6)) {
            isFavorite.toggle()
        }

        // Notify callback
        onToggle?(isFavorite)
    }
}

// MARK: - Button Style

@available(iOS 17.0, *)
private struct FavoriteButtonStyle: ButtonStyle {
    let configuration: ARCFavoriteButtonConfiguration

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(
                width: self.configuration.size.touchTargetSize,
                height: self.configuration.size.touchTargetSize
            )
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("Not Favorited") {
    @Previewable @State var isFavorite = false

    VStack(spacing: 40) { // Intentionally larger for showcase
        ARCFavoriteButton(
            isFavorite: $isFavorite,
            size: .small
        )

        ARCFavoriteButton(
            isFavorite: $isFavorite,
            size: .medium
        )

        ARCFavoriteButton(
            isFavorite: $isFavorite,
            size: .large
        )
    }
    .padding()
}

#Preview("Favorited") {
    @Previewable @State var isFavorite = true

    ARCFavoriteButton(
        isFavorite: $isFavorite,
        favoriteColor: .pink
    )
    .padding()
}

#Preview("Custom Colors") {
    @Previewable @State var isPink = false
    @Previewable @State var isBlue = false
    @Previewable @State var isGreen = false

    VStack(spacing: 40) { // Intentionally larger for showcase
        ARCFavoriteButton(
            isFavorite: $isPink,
            favoriteColor: .pink
        )

        ARCFavoriteButton(
            isFavorite: $isBlue,
            favoriteColor: .blue
        )

        ARCFavoriteButton(
            isFavorite: $isGreen,
            favoriteColor: .green
        )
    }
    .padding()
}

#Preview("Dark Mode") {
    @Previewable @State var isFavorite = true

    ARCFavoriteButton(
        isFavorite: $isFavorite
    )
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Interactive Demo") {
    @Previewable @State var isFavorite = false
    @Previewable @State var toggleCount = 0

    VStack(spacing: .arcSpacingXXLarge) {
        ARCFavoriteButton(
            isFavorite: $isFavorite
        ) { _ in
            toggleCount += 1
        }

        VStack(spacing: .arcSpacingSmall) {
            Text("Status: \(isFavorite ? "❤️ Favorited" : "🤍 Not Favorited")")
                .font(.headline)

            Text("Toggled \(toggleCount) times")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
}
