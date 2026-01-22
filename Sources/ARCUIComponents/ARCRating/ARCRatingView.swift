//
//  ARCRatingView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCRatingStyle

/// Visual styles for ARCRatingView
///
/// Each style provides a different visual representation optimized for specific use cases.
@available(iOS 17.0, macOS 14.0, *)
public enum ARCRatingStyle: String, CaseIterable, Sendable {
    /// Circular gauge with fill indicator (default)
    ///
    /// Best for: Cards, featured content, standalone ratings
    case circularGauge

    /// Inline display with mini progress bar
    ///
    /// Best for: Lists, compact spaces, table rows
    case compactInline

    /// Colored number with border
    ///
    /// Best for: Minimal displays, inline text, badges
    case minimal
}

// MARK: - ARCRatingView

/// A view that displays a numeric rating with multiple visual styles
///
/// `ARCRatingView` provides versatile rating displays optimized for 1-10 scale,
/// with semantic color gradients and smooth SwiftUI animations.
///
/// ## Overview
///
/// ARCRatingView supports three visual styles:
/// - **Circular Gauge**: Progress ring with centered number (default)
/// - **Compact Inline**: Progress bar with number for lists
/// - **Minimal**: Bordered number badge for inline use
///
/// ## Usage
///
/// ```swift
/// // Default circular gauge (1-10 scale)
/// ARCRatingView(rating: 8.5)
///
/// // Compact inline for lists
/// ARCRatingView(rating: 7.2, style: .compactInline)
///
/// // Minimal badge for inline text
/// ARCRatingView(rating: 9.0, style: .minimal)
///
/// // Custom max rating (1-5 scale)
/// ARCRatingView(rating: 4.5, maxRating: 5.0)
///
/// // Using configuration presets
/// ARCRatingView(rating: 8.0, configuration: .compact)
/// ARCRatingView(rating: 4.2, configuration: .fiveStars)
/// ```
///
/// ## Color Scale
///
/// Colors are semantic and change based on the rating percentage:
/// - **1-3** (0-30%): Red/Orange - Poor
/// - **3-5** (30-50%): Orange/Yellow - Fair
/// - **5-6.5** (50-65%): Yellow/Lime - Good
/// - **6.5-7.5** (65-75%): Lime/Light Green - Great
/// - **7.5-8.5** (75-85%): Light/Medium Green - Very Good
/// - **8.5-10** (85-100%): Strong Green - Excellent
///
/// - Note: The view automatically animates between values and provides
///   meaningful accessibility labels for VoiceOver users.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingView: View {
    // MARK: - Properties

    /// The rating value to display
    private let rating: Double

    /// Configuration for appearance
    private let configuration: ARCRatingViewConfiguration

    // MARK: - State

    @State private var animatedRating: Double = 0

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var gaugeSize: CGFloat = 56

    @ScaledMetric(relativeTo: .subheadline)
    private var spacing: CGFloat = .arcSpacingXSmall

    @ScaledMetric(relativeTo: .caption)
    private var barWidth: CGFloat = 48

    // MARK: - Initialization

    /// Creates a rating view with a configuration
    ///
    /// - Parameters:
    ///   - rating: The rating value to display
    ///   - configuration: Visual configuration (default: `.default`)
    public init(
        rating: Double,
        configuration: ARCRatingViewConfiguration = .default
    ) {
        self.rating = rating
        self.configuration = configuration
    }

    /// Creates a rating view with individual parameters
    ///
    /// - Parameters:
    ///   - rating: The rating value to display
    ///   - style: Visual style (default: `.circularGauge`)
    ///   - maxRating: Maximum rating value (default: `10.0`)
    ///   - animated: Whether to animate value changes (default: `true`)
    public init(
        rating: Double,
        style: ARCRatingStyle = .circularGauge,
        maxRating: Double = 10.0,
        animated: Bool = true
    ) {
        self.rating = rating
        configuration = ARCRatingViewConfiguration(
            style: style,
            maxRating: maxRating,
            animated: animated
        )
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch configuration.style {
            case .circularGauge:
                circularGaugeView
            case .compactInline:
                compactInlineView
            case .minimal:
                minimalView
            }
        }
        .onAppear {
            if configuration.animated {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animatedRating = clampedRating
                }
            } else {
                animatedRating = clampedRating
            }
        }
        .onChange(of: rating) { _, newValue in
            let newClamped = min(max(newValue, 0), configuration.maxRating)
            if configuration.animated {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    animatedRating = newClamped
                }
            } else {
                animatedRating = newClamped
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(formattedRating)
    }
}

// MARK: - Circular Gauge Style

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingView {
    @ViewBuilder
    private var circularGaugeView: some View {
        ZStack {
            // Background fill with gradient
            Circle()
                .fill(ratingGradient.opacity(0.15))

            // Background track
            Circle()
                .stroke(
                    Color.primary.opacity(0.1),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .padding(3)

            // Filled arc
            Circle()
                .trim(from: 0, to: ratingProgress)
                .stroke(
                    ratingGradient,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(3)

            // Center content
            Text(formattedRating)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(ratingColor)
        }
        .frame(width: gaugeSize, height: gaugeSize)
    }
}

// MARK: - Compact Inline Style

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingView {
    @ViewBuilder
    private var compactInlineView: some View {
        HStack(spacing: spacing) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.1))

                    Capsule()
                        .fill(ratingGradient)
                        .frame(width: geometry.size.width * ratingProgress)
                }
            }
            .frame(width: barWidth, height: 4)

            // Score
            Text(formattedRating)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(ratingColor)
        }
    }
}

// MARK: - Minimal Style

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingView {
    @ViewBuilder
    private var minimalView: some View {
        Text(formattedRating)
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .foregroundStyle(ratingColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
                Capsule()
                    .strokeBorder(ratingColor, lineWidth: 1.5)
            }
    }
}

// MARK: - Computed Properties

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingView {
    private var clampedRating: Double {
        min(max(rating, 0), configuration.maxRating)
    }

    private var ratingProgress: Double {
        guard configuration.maxRating > 0 else { return 0 }
        return animatedRating / configuration.maxRating
    }

    private var formattedRating: String {
        if clampedRating.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", clampedRating)
        }
        return String(format: "%.1f", clampedRating)
    }

    private var accessibilityLabel: String {
        String(
            format: "Rating: %.1f out of %.0f",
            clampedRating,
            configuration.maxRating
        )
    }

    /// Returns semantic color based on rating percentage
    private var ratingColor: Color {
        let normalized = clampedRating / configuration.maxRating

        switch normalized {
        case 0..<0.3:
            return .red
        case 0.3..<0.5:
            return .orange
        case 0.5..<0.65:
            return .yellow
        case 0.65..<0.75:
            return Color(red: 0.6, green: 0.75, blue: 0.2)
        case 0.75..<0.85:
            return Color(red: 0.3, green: 0.75, blue: 0.3)
        default:
            return Color(red: 0.1, green: 0.65, blue: 0.2)
        }
    }

    /// Returns gradient based on rating percentage
    private var ratingGradient: LinearGradient {
        let normalized = clampedRating / configuration.maxRating

        let colors: [Color] = switch normalized {
        case 0..<0.3:
            [.red, .orange]
        case 0.3..<0.5:
            [.orange, .yellow]
        case 0.5..<0.65:
            [.yellow, Color(red: 0.7, green: 0.8, blue: 0.2)]
        case 0.65..<0.75:
            [Color(red: 0.6, green: 0.8, blue: 0.2), Color(red: 0.4, green: 0.75, blue: 0.25)]
        case 0.75..<0.85:
            [Color(red: 0.4, green: 0.75, blue: 0.25), Color(red: 0.2, green: 0.7, blue: 0.25)]
        default:
            [Color(red: 0.2, green: 0.7, blue: 0.25), Color(red: 0.1, green: 0.6, blue: 0.15)]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Configuration

/// Configuration for ARCRatingView appearance
///
/// Use presets for common configurations or create custom ones.
///
/// ## Presets
///
/// ```swift
/// // Default (1-10 scale, circular gauge)
/// ARCRatingView(rating: 8.5, configuration: .default)
///
/// // Compact inline for lists
/// ARCRatingView(rating: 7.0, configuration: .compact)
///
/// // Minimal badge
/// ARCRatingView(rating: 9.2, configuration: .minimal)
///
/// // 5-star scale
/// ARCRatingView(rating: 4.5, configuration: .fiveStars)
///
/// // Static (no animation)
/// ARCRatingView(rating: 8.0, configuration: .static)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingViewConfiguration: Sendable {
    // MARK: - Properties

    /// Visual style for the rating display
    public let style: ARCRatingStyle

    /// Maximum rating value (determines the scale)
    public let maxRating: Double

    /// Whether to animate value changes
    public let animated: Bool

    // MARK: - Initialization

    /// Creates a rating view configuration
    ///
    /// - Parameters:
    ///   - style: Visual style (default: `.circularGauge`)
    ///   - maxRating: Maximum rating value (default: `10.0`)
    ///   - animated: Whether to animate changes (default: `true`)
    public init(
        style: ARCRatingStyle = .circularGauge,
        maxRating: Double = 10.0,
        animated: Bool = true
    ) {
        self.style = style
        self.maxRating = maxRating
        self.animated = animated
    }

    // MARK: - Presets (1-10 Scale)

    /// Default: Circular gauge, 1-10 scale, animated
    public static let `default` = ARCRatingViewConfiguration()

    /// Compact inline style for lists, 1-10 scale
    public static let compact = ARCRatingViewConfiguration(style: .compactInline)

    /// Minimal badge style, 1-10 scale
    public static let minimal = ARCRatingViewConfiguration(style: .minimal)

    /// Static display without animation, 1-10 scale
    public static let `static` = ARCRatingViewConfiguration(animated: false)

    // MARK: - Presets (1-5 Scale)

    /// Circular gauge for 1-5 star scale
    public static let fiveStars = ARCRatingViewConfiguration(maxRating: 5.0)

    /// Compact inline for 1-5 star scale
    public static let fiveStarsCompact = ARCRatingViewConfiguration(
        style: .compactInline,
        maxRating: 5.0
    )

    /// Minimal badge for 1-5 star scale
    public static let fiveStarsMinimal = ARCRatingViewConfiguration(
        style: .minimal,
        maxRating: 5.0
    )
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
public extension View {
    /// Adds a rating overlay to the view
    ///
    /// - Parameters:
    ///   - rating: The rating value
    ///   - style: Visual style
    ///   - alignment: Position of the rating
    /// - Returns: View with rating overlay
    func ratingOverlay(
        _ rating: Double,
        style: ARCRatingStyle = .minimal,
        alignment: Alignment = .topTrailing
    ) -> some View {
        overlay(alignment: alignment) {
            ARCRatingView(rating: rating, style: style)
                .padding(8)
        }
    }
}

// MARK: - Preview

#Preview("All Styles") {
    VStack(spacing: .arcSpacingXLarge) {
        ForEach(ARCRatingStyle.allCases, id: \.self) { style in
            HStack {
                Text(style.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 100, alignment: .leading)

                Spacer()

                ARCRatingView(rating: 8.5, style: style)
            }
            .padding(.horizontal)
        }
    }
    .padding()
}

#Preview("Circular Gauge - All Ratings") {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: .arcSpacingLarge) {
        ForEach([2.0, 4.0, 5.5, 7.0, 8.5, 10.0], id: \.self) { rating in
            ARCRatingView(rating: rating)
        }
    }
    .padding()
}

#Preview("5-Star Scale") {
    VStack(spacing: .arcSpacingLarge) {
        Text("5-Star Scale")
            .font(.headline)

        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 2.0, configuration: .fiveStars)
            ARCRatingView(rating: 3.5, configuration: .fiveStars)
            ARCRatingView(rating: 5.0, configuration: .fiveStars)
        }

        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 2.5, configuration: .fiveStarsCompact)
            ARCRatingView(rating: 4.0, configuration: .fiveStarsCompact)
        }

        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 3.0, configuration: .fiveStarsMinimal)
            ARCRatingView(rating: 4.5, configuration: .fiveStarsMinimal)
        }
    }
    .padding()
}

#Preview("Compact Inline") {
    VStack(alignment: .leading, spacing: .arcSpacingMedium) {
        ForEach([3.5, 6.0, 8.5, 10.0], id: \.self) { rating in
            HStack {
                Text("Item")
                    .font(.subheadline)
                Spacer()
                ARCRatingView(rating: rating, style: .compactInline)
            }
        }
    }
    .padding()
}

#Preview("Minimal") {
    VStack(alignment: .leading, spacing: .arcSpacingMedium) {
        ForEach([2.0, 5.0, 7.5, 10.0], id: \.self) { rating in
            HStack {
                Text("Rating:")
                    .font(.subheadline)
                ARCRatingView(rating: rating, style: .minimal)
            }
        }
    }
    .padding()
}

#Preview("Rating Overlay") {
    RoundedRectangle(cornerRadius: 12)
        .fill(.blue.opacity(0.2))
        .frame(width: 150, height: 100)
        .ratingOverlay(8.7)
        .padding()
}

#Preview("In Card Context") {
    VStack(spacing: .arcSpacingLarge) {
        HStack(spacing: .arcSpacingMedium) {
            RoundedRectangle(cornerRadius: .arcCornerRadiusSmall)
                .fill(.blue.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text("Italian Restaurant")
                    .font(.headline)
                Text("Fine Dining • $$$$")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ARCRatingView(rating: 9.2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                .fill(.ultraThinMaterial)
        )

        VStack(spacing: 0) {
            ForEach(["Pasta Carbonara", "Margherita Pizza", "Tiramisu"], id: \.self) { item in
                HStack {
                    Text(item)
                        .font(.subheadline)
                    Spacer()
                    ARCRatingView(rating: Double.random(in: 7.0...10.0), style: .compactInline)
                }
                .padding(.vertical, .arcSpacingSmall)
                .padding(.horizontal, .arcSpacingMedium)

                if item != "Tiramisu" {
                    Divider()
                        .padding(.leading, .arcSpacingMedium)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                .fill(.ultraThinMaterial)
        )
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: .arcSpacingXLarge) {
        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 3.0)
            ARCRatingView(rating: 6.5)
            ARCRatingView(rating: 9.5)
        }

        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 4.0, style: .compactInline)
            ARCRatingView(rating: 8.0, style: .compactInline)
        }

        HStack(spacing: .arcSpacingLarge) {
            ARCRatingView(rating: 5.0, style: .minimal)
            ARCRatingView(rating: 9.0, style: .minimal)
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}
