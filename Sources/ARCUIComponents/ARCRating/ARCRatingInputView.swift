//
//  ARCRatingInputView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/2/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCRatingInputStyle

/// Interaction styles for ARCRatingInputView
///
/// Each style provides a different way for users to select a rating.
@available(iOS 17.0, macOS 14.0, *)
public enum ARCRatingInputStyle: String, CaseIterable, Sendable {
    /// Slider below the circular gauge
    ///
    /// Best for: Forms, settings, precise selection
    case slider

    /// Interactive circular gauge with drag gesture
    ///
    /// Best for: Compact spaces, visual feedback, gamified experiences
    case circularDrag
}

// MARK: - ARCRatingInputView

/// An interactive view for selecting a rating from 1 to 10 with 0.5 increments
///
/// `ARCRatingInputView` provides two interaction styles for rating selection:
/// - **Slider**: A horizontal slider below the circular gauge
/// - **Circular Drag**: Direct interaction with the gauge via drag gesture
///
/// ## Overview
///
/// The component always displays ratings on a 1-10 scale with 0.5 step increments,
/// providing 19 possible values (1, 1.5, 2, 2.5, ... 9.5, 10).
///
/// ## Usage
///
/// ```swift
/// // Slider style (default)
/// @State private var rating: Double = 5.0
/// ARCRatingInputView(rating: $rating)
///
/// // Circular drag style
/// ARCRatingInputView(rating: $rating, style: .circularDrag)
///
/// // Using configuration
/// ARCRatingInputView(rating: $rating, configuration: .circularDrag)
/// ```
///
/// ## Accessibility
///
/// The component provides full VoiceOver support with:
/// - Adjustable trait for increment/decrement
/// - Clear value announcements
/// - Semantic labels
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingInputView: View {
    // MARK: - Properties

    /// Binding to the rating value
    @Binding private var rating: Double

    /// Configuration for appearance and behavior
    private let configuration: ARCRatingInputConfiguration

    // MARK: - State

    @State private var isDragging = false
    @GestureState private var dragLocation: CGPoint?

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var gaugeSize: CGFloat = 80

    @ScaledMetric(relativeTo: .caption)
    private var sliderWidth: CGFloat = 200

    // MARK: - Constants

    private let minRating: Double = 1.0
    private let maxRating: Double = 10.0
    private let step: Double = 0.5

    // MARK: - Initialization

    /// Creates a rating input view with a configuration
    ///
    /// - Parameters:
    ///   - rating: Binding to the rating value (1.0-10.0)
    ///   - configuration: Visual and interaction configuration (default: `.slider`)
    public init(
        rating: Binding<Double>,
        configuration: ARCRatingInputConfiguration = .slider
    ) {
        _rating = rating
        self.configuration = configuration
    }

    /// Creates a rating input view with individual parameters
    ///
    /// - Parameters:
    ///   - rating: Binding to the rating value (1.0-10.0)
    ///   - style: Interaction style (default: `.slider`)
    ///   - showLabel: Whether to show the numeric label (default: `true`)
    ///   - animated: Whether to animate value changes (default: `true`)
    public init(
        rating: Binding<Double>,
        style: ARCRatingInputStyle = .slider,
        showLabel: Bool = true,
        animated: Bool = true
    ) {
        _rating = rating
        configuration = ARCRatingInputConfiguration(
            style: style,
            showLabel: showLabel,
            animated: animated
        )
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: .arcSpacingMedium) {
            switch configuration.style {
            case .slider:
                sliderStyleView
            case .circularDrag:
                circularDragStyleView
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating selector")
        .accessibilityValue("\(formattedRating) out of 10")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                adjustRating(by: step)
            case .decrement:
                adjustRating(by: -step)
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Slider Style

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingInputView {
    @ViewBuilder private var sliderStyleView: some View {
        VStack(spacing: .arcSpacingMedium) {
            // Circular gauge display
            circularGaugeDisplay

            // Slider control
            VStack(spacing: .arcSpacingXSmall) {
                Slider(value: $rating, in: minRating ... maxRating, step: step)
                    .tint(ratingColor)
                    .frame(maxWidth: sliderWidth)

                // Min/Max labels
                HStack {
                    Text("1")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("10")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: sliderWidth)
            }
        }
    }
}

// MARK: - Circular Drag Style

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingInputView {
    @ViewBuilder private var circularDragStyleView: some View {
        VStack(spacing: .arcSpacingSmall) {
            circularGaugeDisplay
                .contentShape(Circle())
                .gesture(circularDragGesture)
                .sensoryFeedback(.selection, trigger: rating)

            if configuration.showLabel {
                Text("Drag to adjust")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private var circularDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragLocation) { value, state, _ in
                state = value.location
            }
            .onChanged { value in
                isDragging = true
                updateRatingFromDrag(at: value.location)
            }
            .onEnded { _ in
                isDragging = false
            }
    }

    private func updateRatingFromDrag(at location: CGPoint) {
        let center = CGPoint(x: gaugeSize / 2, y: gaugeSize / 2)
        let vector = CGPoint(x: location.x - center.x, y: location.y - center.y)

        // Calculate angle from top (12 o'clock position)
        var angle = atan2(vector.x, -vector.y)
        if angle < 0 {
            angle += 2 * .pi
        }

        // Convert angle to rating (0 to 2π maps to 1-10)
        let normalizedAngle = angle / (2 * .pi)
        let rawRating = minRating + normalizedAngle * (maxRating - minRating)

        // Snap to nearest step
        let snappedRating = (rawRating / step).rounded() * step
        let clampedRating = min(max(snappedRating, minRating), maxRating)

        if configuration.animated {
            arcWithAnimation(.arcSnappy) {
                rating = clampedRating
            }
        } else {
            rating = clampedRating
        }
    }
}

// MARK: - Circular Gauge Display

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingInputView {
    @ViewBuilder private var circularGaugeDisplay: some View {
        ZStack {
            // Background fill with gradient
            Circle()
                .fill(ratingGradient.opacity(0.15))

            // Background track
            Circle()
                .stroke(
                    Color.primary.opacity(0.1),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .padding(4)

            // Filled arc
            Circle()
                .trim(from: 0, to: ratingProgress)
                .stroke(
                    ratingGradient,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(4)

            // Drag indicator for circular drag style
            if configuration.style == .circularDrag {
                dragIndicator
            }

            // Center content
            if configuration.showLabel {
                Text(formattedRating)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(ratingColor)
            }
        }
        .frame(width: gaugeSize, height: gaugeSize)
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .animation(.arcBouncy, value: isDragging)
    }

    @ViewBuilder private var dragIndicator: some View {
        Circle()
            .fill(ratingColor)
            .frame(width: 12, height: 12)
            .shadow(color: ratingColor.opacity(0.5), radius: 4)
            .offset(y: -(gaugeSize / 2 - 4))
            .rotationEffect(.degrees(ratingProgress * 360))
    }
}

// MARK: - Computed Properties

@available(iOS 17.0, macOS 14.0, *)
extension ARCRatingInputView {
    private var clampedRating: Double {
        min(max(rating, minRating), maxRating)
    }

    private var ratingProgress: Double {
        (clampedRating - minRating) / (maxRating - minRating)
    }

    private var formattedRating: String {
        if clampedRating.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", clampedRating)
        }
        return String(format: "%.1f", clampedRating)
    }

    /// Returns semantic color based on rating
    private var ratingColor: Color {
        let normalized = clampedRating / maxRating

        switch normalized {
        case 0 ..< 0.3:
            return .red
        case 0.3 ..< 0.5:
            return .orange
        case 0.5 ..< 0.65:
            return .yellow
        case 0.65 ..< 0.75:
            return Color(red: 0.6, green: 0.75, blue: 0.2)
        case 0.75 ..< 0.85:
            return Color(red: 0.3, green: 0.75, blue: 0.3)
        default:
            return Color(red: 0.1, green: 0.65, blue: 0.2)
        }
    }

    /// Returns gradient based on rating
    private var ratingGradient: LinearGradient {
        let normalized = clampedRating / maxRating

        let colors: [Color] = switch normalized {
        case 0 ..< 0.3:
            [.red, .orange]
        case 0.3 ..< 0.5:
            [.orange, .yellow]
        case 0.5 ..< 0.65:
            [.yellow, Color(red: 0.7, green: 0.8, blue: 0.2)]
        case 0.65 ..< 0.75:
            [Color(red: 0.6, green: 0.8, blue: 0.2), Color(red: 0.4, green: 0.75, blue: 0.25)]
        case 0.75 ..< 0.85:
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

    private func adjustRating(by amount: Double) {
        let newRating = clampedRating + amount
        rating = min(max(newRating, minRating), maxRating)
    }
}

// MARK: - Preview

#Preview("Slider Style") {
    struct PreviewWrapper: View {
        @State private var rating: Double = 5.0

        var body: some View {
            VStack(spacing: 32) {
                ARCRatingInputView(rating: $rating, style: .slider)

                Text("Selected: \(String(format: "%.1f", rating))")
                    .font(.headline)
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Circular Drag Style") {
    struct PreviewWrapper: View {
        @State private var rating: Double = 7.5

        var body: some View {
            VStack(spacing: 32) {
                ARCRatingInputView(rating: $rating, style: .circularDrag)

                Text("Selected: \(String(format: "%.1f", rating))")
                    .font(.headline)
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Both Styles") {
    struct PreviewWrapper: View {
        @State private var sliderRating: Double = 3.0
        @State private var circularRating: Double = 8.5

        var body: some View {
            VStack(spacing: 48) {
                VStack(spacing: 8) {
                    Text("Slider Style")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCRatingInputView(rating: $sliderRating, style: .slider)
                }

                VStack(spacing: 8) {
                    Text("Circular Drag Style")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCRatingInputView(rating: $circularRating, style: .circularDrag)
                }
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("All Ratings - Slider") {
    struct PreviewWrapper: View {
        @State private var ratings: [Double] = [1.0, 3.5, 5.0, 7.0, 9.5]

        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(ratings.indices, id: \.self) { index in
                        ARCRatingInputView(rating: $ratings[index], style: .slider)
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State private var rating1: Double = 4.0
        @State private var rating2: Double = 8.0

        var body: some View {
            VStack(spacing: 48) {
                ARCRatingInputView(rating: $rating1, style: .slider)
                ARCRatingInputView(rating: $rating2, style: .circularDrag)
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
    return PreviewWrapper()
}
