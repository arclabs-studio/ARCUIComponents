//
//  ARCFavoriteButton.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Animated toggle button for marking content as favorite/liked/bookmarked.
///
/// ## Why ARCFavoriteButton exists (vs native Toggle)
///
/// SwiftUI's `Toggle` can be styled but doesn't provide:
/// - Symbol effect animations (bounce on toggle)
/// - Built-in haptic feedback
/// - Gradient color support
/// - Preset icon pairs (heart, star, bookmark)
///
/// ## Usage
///
/// ```swift
/// // Default heart icon
/// ARCFavoriteButton(isFavorite: $isFavorite)
///
/// // Star rating style
/// ARCFavoriteButton(isFavorite: $isStarred, icon: .star, color: .yellow)
///
/// // Bookmark style
/// ARCFavoriteButton(isFavorite: $isBookmarked, icon: .bookmark, color: .blue)
///
/// // Custom icons
/// ARCFavoriteButton(
///     isFavorite: $isLiked,
///     icon: .custom(filled: "hand.thumbsup.fill", empty: "hand.thumbsup")
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCFavoriteButton: View {
    // MARK: - Icon Preset

    /// Preset icon pairs for common use cases.
    public enum Icon: Sendable, Equatable {
        /// Heart icon (default) - Music, Photos style
        case heart
        /// Star icon - Ratings, highlights
        case star
        /// Bookmark icon - Reading lists, saved items
        case bookmark
        /// Flag icon - Important items
        case flag
        /// Custom SF Symbol pair
        case custom(filled: String, empty: String)

        var filledName: String {
            switch self {
            case .heart: "heart.fill"
            case .star: "star.fill"
            case .bookmark: "bookmark.fill"
            case .flag: "flag.fill"
            case let .custom(filled, _): filled
            }
        }

        var emptyName: String {
            switch self {
            case .heart: "heart"
            case .star: "star"
            case .bookmark: "bookmark"
            case .flag: "flag"
            case let .custom(_, empty): empty
            }
        }
    }

    // MARK: - Size

    /// Button size options.
    public enum Size: Sendable {
        case small, medium, large
        case custom(CGFloat)

        var iconSize: CGFloat {
            switch self {
            case .small: 20
            case .medium: 24
            case .large: 28
            case let .custom(size): size
            }
        }

        var touchTarget: CGFloat { max(44, iconSize + 20) }
    }

    // MARK: - Properties

    @Binding private var isFavorite: Bool
    private let icon: Icon
    private let color: Color
    private let size: Size
    private let haptics: Bool
    private let onToggle: ((Bool) -> Void)?

    // MARK: - Initialization

    /// Creates a favorite button.
    ///
    /// - Parameters:
    ///   - isFavorite: Binding to the favorite state
    ///   - icon: Icon preset (default: `.heart`)
    ///   - color: Active color (default: `.pink`)
    ///   - size: Button size (default: `.medium`)
    ///   - haptics: Enable haptic feedback (default: `true`)
    ///   - onToggle: Optional callback when state changes
    public init(
        isFavorite: Binding<Bool>,
        icon: Icon = .heart,
        color: Color = .pink,
        size: Size = .medium,
        haptics: Bool = true,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        _isFavorite = isFavorite
        self.icon = icon
        self.color = color
        self.size = size
        self.haptics = haptics
        self.onToggle = onToggle
    }

    // MARK: - Body

    public var body: some View {
        Button(action: toggle) {
            Image(systemName: isFavorite ? icon.filledName : icon.emptyName)
                .font(.system(size: size.iconSize))
                .foregroundStyle(isFavorite ? color.gradient : Color.secondary.gradient)
                .symbolEffect(.bounce, value: isFavorite)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(ScaleButtonStyle(touchTarget: size.touchTarget))
        .accessibilityLabel(isFavorite ? "Favorited" : "Not favorited")
        .accessibilityHint("Tap to \(isFavorite ? "remove from" : "add to") favorites")
    }

    // MARK: - Actions

    private func toggle() {
        #if os(iOS)
        if haptics {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        #endif

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isFavorite.toggle()
        }

        onToggle?(isFavorite)
    }
}

// MARK: - Button Style

@available(iOS 17.0, *)
private struct ScaleButtonStyle: ButtonStyle {
    let touchTarget: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: touchTarget, height: touchTarget)
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Icons") {
    @Previewable @State var heart = false
    @Previewable @State var star = false
    @Previewable @State var bookmark = false
    @Previewable @State var flag = false

    HStack(spacing: 32) {
        ARCFavoriteButton(isFavorite: $heart, icon: .heart, color: .pink)
        ARCFavoriteButton(isFavorite: $star, icon: .star, color: .yellow)
        ARCFavoriteButton(isFavorite: $bookmark, icon: .bookmark, color: .blue)
        ARCFavoriteButton(isFavorite: $flag, icon: .flag, color: .orange)
    }
    .padding()
}

@available(iOS 17.0, *)
#Preview("Sizes") {
    @Previewable @State var small = true
    @Previewable @State var medium = true
    @Previewable @State var large = true

    HStack(spacing: 32) {
        ARCFavoriteButton(isFavorite: $small, size: .small)
        ARCFavoriteButton(isFavorite: $medium, size: .medium)
        ARCFavoriteButton(isFavorite: $large, size: .large)
    }
    .padding()
}

@available(iOS 17.0, *)
#Preview("Custom Icon") {
    @Previewable @State var liked = false

    ARCFavoriteButton(
        isFavorite: $liked,
        icon: .custom(filled: "hand.thumbsup.fill", empty: "hand.thumbsup"),
        color: .blue
    )
    .padding()
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    @Previewable @State var fav = true

    ARCFavoriteButton(isFavorite: $fav)
        .padding()
        .preferredColorScheme(.dark)
}
