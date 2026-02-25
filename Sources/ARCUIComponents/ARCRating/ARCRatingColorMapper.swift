//
//  ARCRatingColorMapper.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import SwiftUI

// MARK: - ARCRatingColorMapper

/// Maps numeric ratings to semantic colors, gradients, and formatted strings
///
/// Provides the shared color scale used across all rating components
/// (`ARCRatingView`, `ARCRatingInputView`, and their showcases).
///
/// ## Color Scale
///
/// Colors change based on the rating's percentage of the maximum:
/// - **0-30%**: Red/Orange — Poor
/// - **30-50%**: Orange/Yellow — Fair
/// - **50-65%**: Yellow/Lime — Good
/// - **65-75%**: Lime/Light Green — Great
/// - **75-85%**: Light/Medium Green — Very Good
/// - **85-100%**: Strong Green — Excellent
///
/// ## Usage
///
/// ```swift
/// let color = ARCRatingColorMapper.color(for: 8.5, maxRating: 10)
/// let gradient = ARCRatingColorMapper.gradient(for: 8.5, maxRating: 10)
/// let text = ARCRatingColorMapper.formatted(8.5) // "8.5"
/// let text2 = ARCRatingColorMapper.formatted(9.0) // "9"
/// ```
@available(iOS 17.0, macOS 14.0, *) public enum ARCRatingColorMapper {
    /// Returns a semantic color based on the rating's percentage of the maximum
    ///
    /// - Parameters:
    ///   - rating: The rating value
    ///   - maxRating: The maximum possible rating (default: `10.0`)
    /// - Returns: A color representing the rating quality
    public static func color(for rating: Double, maxRating: Double = 10.0) -> Color {
        let normalized = maxRating > 0 ? rating / maxRating : 0

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

    /// Returns a linear gradient based on the rating's percentage of the maximum
    ///
    /// - Parameters:
    ///   - rating: The rating value
    ///   - maxRating: The maximum possible rating (default: `10.0`)
    /// - Returns: A gradient representing the rating quality
    public static func gradient(for rating: Double, maxRating: Double = 10.0) -> LinearGradient {
        let normalized = maxRating > 0 ? rating / maxRating : 0

        // swiftlint:disable switch_case_alignment
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
        // swiftlint:enable switch_case_alignment

        return LinearGradient(colors: colors,
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }

    /// Formats a rating value, showing whole numbers without decimals
    ///
    /// - Parameter rating: The rating value to format
    /// - Returns: `"9"` for whole numbers, `"8.5"` for half-steps
    public static func formatted(_ rating: Double) -> String {
        if rating.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", rating)
        }
        return String(format: "%.1f", rating)
    }
}
