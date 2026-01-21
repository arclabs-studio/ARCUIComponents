//
//  ARCCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// A generic card component with configurable image, content, and footer slots
///
/// `ARCCard` provides a versatile card layout for displaying items in grids,
/// matching patterns found in App Store, Photos, and other Apple apps.
///
/// ## Overview
///
/// ARCCard supports:
/// - Customizable image slot with any SwiftUI view
/// - Title with optional subtitles and SF Symbol icons
/// - Positionable badges overlay on the image
/// - Footer slot for custom content (ratings, stats, actions)
/// - Full Dynamic Type support with @ScaledMetric
/// - Comprehensive accessibility labels
///
/// ## Topics
///
/// ### Creating Cards
///
/// - ``init(title:subtitle:secondarySubtitle:subtitleIcon:secondarySubtitleIcon:badges:configuration:image:footer:)``
///
/// ### Badge Configuration
///
/// - ``Badge``
/// - ``BadgePosition``
/// - ``BadgeStyle``
///
/// ## Usage
///
/// ```swift
/// // Basic card with image and footer
/// ARCCard(
///     title: "Restaurant Name",
///     subtitle: "Italian Cuisine",
///     subtitleIcon: "fork.knife"
/// ) {
///     // Image slot
///     Image("restaurant-hero")
///         .resizable()
///         .aspectRatio(contentMode: .fill)
/// } footer: {
///     ARCRatingView(rating: 4.5)
/// }
///
/// // Card with badges
/// ARCCard(
///     title: "Book Title",
///     subtitle: "Author Name",
///     badges: [
///         .init(text: "$12.99", position: .topTrailing, style: .material)
///     ]
/// ) {
///     BookCoverImage()
/// }
/// ```
///
/// - Note: Use `ARCCardPressStyle` button style when making cards interactive.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCard<ImageContent: View, FooterContent: View>: View {

    // MARK: - Properties

    /// Card title
    private let title: String

    /// Optional subtitle text
    private let subtitle: String?

    /// Optional secondary subtitle text
    private let secondarySubtitle: String?

    /// SF Symbol name for subtitle icon
    private let subtitleIcon: String?

    /// SF Symbol name for secondary subtitle icon
    private let secondarySubtitleIcon: String?

    /// Badges to display over the image
    private let badges: [Badge]

    /// Configuration for appearance
    private let configuration: ARCCardConfiguration

    /// Image content builder
    private let imageContent: ImageContent

    /// Footer content builder
    private let footerContent: FooterContent

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var contentSpacing: CGFloat = .arcSpacingSmall

    @ScaledMetric(relativeTo: .body)
    private var contentPadding: CGFloat = .arcSpacingMedium

    @ScaledMetric(relativeTo: .caption)
    private var iconSpacing: CGFloat = .arcSpacingXSmall

    @ScaledMetric(relativeTo: .caption2)
    private var badgePadding: CGFloat = .arcSpacingSmall

    // MARK: - Initialization

    /// Creates a card with all customization options
    ///
    /// - Parameters:
    ///   - title: Card title (required)
    ///   - subtitle: Optional subtitle text
    ///   - secondarySubtitle: Optional secondary subtitle text
    ///   - subtitleIcon: SF Symbol name for subtitle icon
    ///   - secondarySubtitleIcon: SF Symbol name for secondary subtitle icon
    ///   - badges: Array of badges to display over the image
    ///   - configuration: Visual configuration
    ///   - image: View builder for image content
    ///   - footer: View builder for footer content
    public init(
        title: String,
        subtitle: String? = nil,
        secondarySubtitle: String? = nil,
        subtitleIcon: String? = nil,
        secondarySubtitleIcon: String? = nil,
        badges: [Badge] = [],
        configuration: ARCCardConfiguration = .default,
        @ViewBuilder image: () -> ImageContent,
        @ViewBuilder footer: () -> FooterContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.secondarySubtitle = secondarySubtitle
        self.subtitleIcon = subtitleIcon
        self.secondarySubtitleIcon = secondarySubtitleIcon
        self.badges = badges
        self.configuration = configuration
        imageContent = image()
        footerContent = footer()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section with badges
            if configuration.showImage {
                imageSection
            }

            // Content section
            contentSection
        }
        .liquidGlass(configuration: configuration)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Image Section

    @ViewBuilder
    private var imageSection: some View {
        ZStack(alignment: .center) {
            imageContent
                .frame(maxWidth: .infinity)
                .clipped()

            // Badges overlay
            ForEach(badges.indices, id: \.self) { index in
                badgeView(for: badges[index])
            }
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: configuration.cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: configuration.cornerRadius,
                style: .continuous
            )
        )
    }

    @ViewBuilder
    private func badgeView(for badge: Badge) -> some View {
        Text(badge.text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, badgePadding)
            .padding(.vertical, badgePadding * 0.6)
            .background(badgeBackground(for: badge.style))
            .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: badge.position.alignment)
            .padding(badgePadding)
    }

    @ViewBuilder
    private func badgeBackground(for style: BadgeStyle) -> some View {
        switch style {
        case .material:
            Color.clear.background(.ultraThinMaterial)
        case let .solid(color):
            color
        }
    }

    // MARK: - Content Section

    @ViewBuilder
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: contentSpacing) {
            // Title
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundStyle(.primary)

            // Subtitle with optional icon
            if let subtitle {
                subtitleRow(text: subtitle, icon: subtitleIcon)
            }

            // Secondary subtitle with optional icon
            if let secondarySubtitle {
                subtitleRow(text: secondarySubtitle, icon: secondarySubtitleIcon)
            }

            // Spacer before footer
            if hasFooterContent {
                Spacer(minLength: .arcSpacingXSmall)
            }

            // Footer
            footerContent
        }
        .padding(contentPadding)
    }

    @ViewBuilder
    private func subtitleRow(text: String, icon: String?) -> some View {
        HStack(spacing: iconSpacing) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption2)
            }
            Text(text)
                .font(.subheadline)
        }
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }

}

// MARK: - Computed Properties

@available(iOS 17.0, macOS 14.0, *)
extension ARCCard {

    private var hasFooterContent: Bool {
        !(FooterContent.self == EmptyView.self)
    }

    private var accessibilityLabel: String {
        var components = [title]
        if let subtitle {
            components.append(subtitle)
        }
        if let secondarySubtitle {
            components.append(secondarySubtitle)
        }
        for badge in badges {
            components.append(badge.text)
        }
        return components.joined(separator: ", ")
    }
}

// MARK: - EmptyView Footer Initializer

@available(iOS 17.0, macOS 14.0, *)
extension ARCCard where FooterContent == EmptyView {

    /// Creates a card without footer content
    ///
    /// - Parameters:
    ///   - title: Card title
    ///   - subtitle: Optional subtitle
    ///   - secondarySubtitle: Optional secondary subtitle
    ///   - subtitleIcon: SF Symbol for subtitle
    ///   - secondarySubtitleIcon: SF Symbol for secondary subtitle
    ///   - badges: Array of badges
    ///   - configuration: Visual configuration
    ///   - image: View builder for image content
    public init(
        title: String,
        subtitle: String? = nil,
        secondarySubtitle: String? = nil,
        subtitleIcon: String? = nil,
        secondarySubtitleIcon: String? = nil,
        badges: [Badge] = [],
        configuration: ARCCardConfiguration = .default,
        @ViewBuilder image: () -> ImageContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.secondarySubtitle = secondarySubtitle
        self.subtitleIcon = subtitleIcon
        self.secondarySubtitleIcon = secondarySubtitleIcon
        self.badges = badges
        self.configuration = configuration
        imageContent = image()
        footerContent = EmptyView()
    }
}

// MARK: - Badge

@available(iOS 17.0, macOS 14.0, *)
extension ARCCard {

    /// A badge to display over the card image
    public struct Badge: Sendable {

        /// Badge text
        public let text: String

        /// Position on the image
        public let position: BadgePosition

        /// Visual style
        public let style: BadgeStyle

        /// Creates a badge
        ///
        /// - Parameters:
        ///   - text: Badge text
        ///   - position: Position on the image
        ///   - style: Visual style
        public init(
            text: String,
            position: BadgePosition,
            style: BadgeStyle = .material
        ) {
            self.text = text
            self.position = position
            self.style = style
        }
    }

    /// Badge position options
    public enum BadgePosition: Sendable {
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing

        var alignment: Alignment {
            switch self {
            case .topLeading: .topLeading
            case .topTrailing: .topTrailing
            case .bottomLeading: .bottomLeading
            case .bottomTrailing: .bottomTrailing
            }
        }
    }

    /// Badge visual style options
    public enum BadgeStyle: Sendable {
        /// Material background (blur effect)
        case material

        /// Solid color background
        case solid(Color)
    }
}

// MARK: - Preview

#Preview("Basic Card") {
    ARCCard(
        title: "Restaurant Name",
        subtitle: "Italian Cuisine",
        secondarySubtitle: "Downtown Area",
        subtitleIcon: "fork.knife",
        secondarySubtitleIcon: "location.fill"
    ) {
        LinearGradient(
            colors: [.orange.opacity(0.3), .red.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(height: 140)
        .overlay {
            Image(systemName: "fork.knife")
                .font(.largeTitle)
                .foregroundStyle(.orange)
        }
    } footer: {
        HStack {
            Label("12", systemImage: "fork.knife")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            ARCRatingView(rating: 4.5)
        }
    }
    .frame(width: 200)
    .padding()
}

#Preview("With Badges") {
    ARCCard(
        title: "Book Title",
        subtitle: "Author Name",
        subtitleIcon: "person.fill",
        badges: [
            .init(text: "$12.99", position: .topTrailing, style: .material),
            .init(text: "NEW", position: .topLeading, style: .solid(.blue))
        ]
    ) {
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(height: 160)
        .overlay {
            Image(systemName: "book.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
        }
    } footer: {
        ARCRatingView(rating: 4.8, configuration: .heart)
    }
    .frame(width: 180)
    .padding()
}

#Preview("Grid Layout") {
    let items = [
        ("Pizza Place", "Italian", "star.fill", Color.orange),
        ("Sushi Bar", "Japanese", "fish.fill", Color.pink),
        ("Burger Joint", "American", "flame.fill", Color.red),
        ("Taco Shop", "Mexican", "leaf.fill", Color.green)
    ]

    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: .arcSpacingLarge) {
        ForEach(items, id: \.0) { item in
            ARCCard(
                title: item.0,
                subtitle: item.1,
                subtitleIcon: item.2
            ) {
                item.3.opacity(0.2)
                    .frame(height: 100)
                    .overlay {
                        Image(systemName: item.2)
                            .font(.title)
                            .foregroundStyle(item.3)
                    }
            } footer: {
                ARCRatingView(rating: Double.random(in: 3.5...5.0))
            }
        }
    }
    .padding()
}

#Preview("Interactive Card") {
    Button {
        print("Card tapped")
    } label: {
        ARCCard(
            title: "Tap Me",
            subtitle: "Interactive card with press effect"
        ) {
            Color.blue.opacity(0.2)
                .frame(height: 120)
                .overlay {
                    Image(systemName: "hand.tap.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                }
        }
    }
    .buttonStyle(ARCCardPressStyle())
    .frame(width: 200)
    .padding()
}

#Preview("Dark Mode") {
    ARCCard(
        title: "Dark Mode Card",
        subtitle: "Looks great in dark",
        subtitleIcon: "moon.fill",
        badges: [
            .init(text: "DARK", position: .topTrailing, style: .material)
        ]
    ) {
        Color.indigo.opacity(0.3)
            .frame(height: 120)
            .overlay {
                Image(systemName: "moon.stars.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.indigo)
            }
    } footer: {
        ARCRatingView(rating: 5.0)
    }
    .frame(width: 200)
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Configurations") {
    VStack(spacing: .arcSpacingXLarge) {
        Text("Default")
            .font(.caption)
            .foregroundStyle(.secondary)

        ARCCard(
            title: "Default Config",
            subtitle: "Standard spacing",
            configuration: .default
        ) {
            Color.green.opacity(0.2).frame(height: 80)
        }
        .frame(width: 180)

        Text("Compact")
            .font(.caption)
            .foregroundStyle(.secondary)

        ARCCard(
            title: "Compact Config",
            subtitle: "Smaller spacing",
            configuration: .compact
        ) {
            Color.blue.opacity(0.2).frame(height: 80)
        }
        .frame(width: 180)

        Text("Prominent")
            .font(.caption)
            .foregroundStyle(.secondary)

        ARCCard(
            title: "Prominent Config",
            subtitle: "Larger radius & shadow",
            configuration: .prominent
        ) {
            Color.purple.opacity(0.2).frame(height: 80)
        }
        .frame(width: 180)
    }
    .padding()
}
