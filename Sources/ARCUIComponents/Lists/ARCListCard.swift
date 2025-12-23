//
//  ARCListCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// List card component following Apple's Human Interface Guidelines
///
/// A versatile card for displaying content in lists, matching patterns found in
/// Music, App Store, Books, and Podcasts with liquid glass effects and rich content.
///
/// ## Overview
///
/// ARCListCard provides a flexible container for list content with:
/// - Optional leading image or icon
/// - Title and subtitle text
/// - Optional trailing accessories (buttons, icons, etc.)
/// - Liquid glass background effects
/// - Tap gesture support
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating List Cards
///
/// - ``init(configuration:image:title:subtitle:accessories:action:)``
///
/// ### Card Image
///
/// - ``CardImage``
///
/// ## Usage
///
/// ```swift
/// // Simple card with title and subtitle
/// ARCListCard(
///     title: "Song Title",
///     subtitle: "Artist Name"
/// ) {
///     playSong()
/// }
///
/// // Card with image and accessories
/// ARCListCard(
///     image: .system("music.note", color: .pink),
///     title: "Album Name",
///     subtitle: "Artist • 2024",
///     accessories: {
///         ARCFavoriteButton(isFavorite: $isFavorite)
///     }
/// ) {
///     showAlbumDetails()
/// }
/// ```
///
/// - Note: Cards automatically handle press states, animations, and accessibility.
@available(iOS 17.0, *)
public struct ARCListCard<Accessories: View>: View {
    // MARK: - Properties

    /// Configuration for appearance
    private let configuration: ARCListCardConfiguration

    /// Optional leading image
    private let image: CardImage?

    /// Title text
    private let title: String

    /// Optional subtitle text
    private let subtitle: String?

    /// Optional trailing accessories
    private let accessories: Accessories?

    /// Optional action when tapped
    private let action: (() -> Void)?

    // MARK: - State

    @State private var isPressed = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Initialization

    /// Creates a list card with full configuration
    ///
    /// - Parameters:
    ///   - configuration: Visual configuration
    ///   - image: Optional leading image
    ///   - title: Title text
    ///   - subtitle: Optional subtitle text
    ///   - accessories: Optional trailing view
    ///   - action: Optional tap action
    public init(
        configuration: ARCListCardConfiguration = .default,
        image: CardImage? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder accessories: () -> Accessories,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.accessories = accessories()
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            HStack(spacing: configuration.spacing) {
                // Leading image
                if let image {
                    imageView(for: image)
                }

                // Text content
                VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Trailing accessories
                if let accessories {
                    accessories
                }
            }
            .padding()
            .liquidGlass(configuration: configuration)
        }
        .buttonStyle(CardPressStyle(isPressed: $isPressed))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(action != nil ? .isButton : [])
    }

    // MARK: - Image View

    @ViewBuilder
    private func imageView(for image: CardImage) -> some View {
        switch image {
        case let .url(url, size):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous))
                case .failure:
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .frame(width: size, height: size)
                    #if os(iOS)
                        .background(Color(.tertiarySystemFill))
                    #else
                        .background(Color(nsColor: .tertiaryLabelColor).opacity(0.1))
                    #endif
                        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous))
                @unknown default:
                    EmptyView()
                }
            }

        case let .system(name, color, size):
            Image(systemName: name)
                .font(.system(size: size * 0.5))
                .foregroundStyle(color.gradient)
                .frame(width: size, height: size)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous))

        case let .custom(image, size):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous))
        }
    }

    // MARK: - Actions

    private func handleTap() {
        guard let action else { return }

        // Provide haptic feedback
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif

        // Perform action
        action()
    }
}

// MARK: - No Accessories Initializer

@available(iOS 17.0, *)
extension ARCListCard where Accessories == EmptyView {
    /// Creates a list card without accessories
    ///
    /// - Parameters:
    ///   - configuration: Visual configuration
    ///   - image: Optional leading image
    ///   - title: Title text
    ///   - subtitle: Optional subtitle text
    ///   - action: Optional tap action
    public init(
        configuration: ARCListCardConfiguration = .default,
        image: CardImage? = nil,
        title: String,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.image = image
        self.title = title
        self.subtitle = subtitle
        accessories = nil
        self.action = action
    }
}

// MARK: - Card Image

@available(iOS 17.0, *)
extension ARCListCard {
    /// Image options for list cards
    public enum CardImage: Sendable {
        /// Remote image from URL
        case url(URL, size: CGFloat = 60)

        /// SF Symbol with color
        case system(String, color: Color, size: CGFloat = 60)

        /// Custom SwiftUI Image
        case custom(Image, size: CGFloat = 60)
    }
}

// MARK: - Card Press Style

@available(iOS 17.0, *)
private struct CardPressStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Preview

#Preview("Simple Cards") {
    ScrollView {
        VStack(spacing: .arcSpacingLarge) {
            ARCListCard(
                title: "Simple Card",
                subtitle: "Just title and subtitle"
            )

            ARCListCard(
                title: "Card with Action",
                subtitle: "Tap to trigger action"
            ) {
                print("Card tapped")
            }
        }
        .padding()
    }
    #if os(iOS)
    .background(Color(.systemGroupedBackground))
    #else
    .background(Color(nsColor: .controlBackgroundColor))
    #endif
}

#Preview("With Images") {
    ScrollView {
        VStack(spacing: .arcSpacingLarge) {
            ARCListCard(
                image: .system("music.note", color: .pink),
                title: "Music Track",
                subtitle: "Artist Name"
            )

            ARCListCard(
                image: .system("book.fill", color: .orange),
                title: "Book Title",
                subtitle: "Author Name"
            )

            ARCListCard(
                image: .system("mic.fill", color: .purple),
                title: "Podcast Episode",
                subtitle: "Show Name • 45 min"
            )
        }
        .padding()
    }
    #if os(iOS)
    .background(Color(.systemGroupedBackground))
    #else
    .background(Color(nsColor: .controlBackgroundColor))
    #endif
}

#Preview("With Accessories") {
    @Previewable @State var favorites: Set<String> = []

    ScrollView {
        VStack(spacing: .arcSpacingLarge) {
            ForEach(["Song 1", "Song 2", "Song 3"], id: \.self) { song in
                ARCListCard(
                    image: .system("music.note", color: .pink),
                    title: song,
                    subtitle: "Artist Name",
                    accessories: {
                        ARCFavoriteButton(
                            isFavorite: Binding(
                                get: { favorites.contains(song) },
                                set: { isFav in
                                    if isFav {
                                        favorites.insert(song)
                                    } else {
                                        favorites.remove(song)
                                    }
                                }
                            ),
                            size: .medium
                        )
                    },
                    action: {
                        print("Tapped \(song)")
                    }
                )
            }
        }
        .padding()
    }
    #if os(iOS)
    .background(Color(.systemGroupedBackground))
    #else
    .background(Color(nsColor: .controlBackgroundColor))
    #endif
}

#Preview("Configurations") {
    ScrollView {
        VStack(spacing: .arcSpacingXLarge) {
            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                Text("Default")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                ARCListCard(
                    configuration: .default,
                    image: .system("star.fill", color: .yellow),
                    title: "Default Style",
                    subtitle: "Translucent background"
                )
            }

            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                Text("Prominent")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                ARCListCard(
                    configuration: .prominent,
                    image: .system("sparkles", color: .blue),
                    title: "Prominent Style",
                    subtitle: "Liquid glass effect"
                )
            }

            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                Text("Glassmorphic")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                ARCListCard(
                    configuration: .glassmorphic,
                    image: .system("music.note", color: .pink),
                    title: "Glassmorphic Style",
                    subtitle: "Apple Music inspired"
                )
            }
        }
        .padding()
    }
    .background(
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

#Preview("Dark Mode") {
    ScrollView {
        VStack(spacing: .arcSpacingLarge) {
            ARCListCard(
                configuration: .prominent,
                image: .system("moon.stars.fill", color: .indigo),
                title: "Dark Mode Card",
                subtitle: "Looks great in dark mode"
            )
        }
        .padding()
    }
    #if os(iOS)
    .background(Color(.systemGroupedBackground))
    #else
    .background(Color(nsColor: .controlBackgroundColor))
    #endif
    .preferredColorScheme(.dark)
}
