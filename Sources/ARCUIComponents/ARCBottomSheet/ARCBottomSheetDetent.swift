//
//  ARCBottomSheetDetent.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCBottomSheetDetent

/// Defines the resting heights for a bottom sheet
///
/// `ARCBottomSheetDetent` specifies particular heights at which the sheet naturally rests.
/// This follows Apple's design pattern from iOS 15+ sheet presentation.
///
/// ## Overview
///
/// Detents define the snap points for the bottom sheet. Users can drag the sheet
/// between detents, and it will snap to the nearest one when released.
///
/// ## Topics
///
/// ### Predefined Detents
///
/// - ``small``
/// - ``medium``
/// - ``large``
///
/// ### Custom Detents
///
/// - ``fraction(_:)``
/// - ``height(_:)``
///
/// ## Usage
///
/// ```swift
/// // Use predefined detents
/// ARCBottomSheet(
///     selectedDetent: $detent,
///     detents: [.small, .medium, .large]
/// ) {
///     SheetContent()
/// }
///
/// // Mix predefined and custom detents
/// ARCBottomSheet(
///     selectedDetent: $detent,
///     detents: [.height(200), .fraction(0.6), .large]
/// ) {
///     SheetContent()
/// }
/// ```
///
/// - Note: The sheet will automatically sort detents by height when determining
///   which one to snap to.
@available(iOS 17.0, macOS 14.0, *)
public enum ARCBottomSheetDetent: Hashable, Sendable {
    /// Small detent (~15% of screen or 120pt minimum)
    ///
    /// Typically used for a collapsed state showing minimal content,
    /// like a search bar or peek preview.
    case small

    /// Medium detent (~50% of screen)
    ///
    /// The standard half-height state, commonly used as the default
    /// presentation height. Allows users to see both sheet content
    /// and the parent view.
    case medium

    /// Large detent (~90% of screen)
    ///
    /// Nearly full-height state, leaving a small amount of the parent
    /// view visible for context. Respects the top safe area.
    case large

    /// Custom fraction of the container height
    ///
    /// Specify a value between 0.0 and 1.0 to create a custom detent
    /// at that percentage of the available height.
    ///
    /// - Parameter fraction: A value from 0.0 to 1.0 representing
    ///   the percentage of container height.
    case fraction(CGFloat)

    /// Fixed height in points
    ///
    /// Creates a detent at an absolute height. The sheet will not
    /// exceed 95% of the container height, even if a larger value
    /// is specified.
    ///
    /// - Parameter height: The desired height in points.
    case height(CGFloat)

    // MARK: - Height Calculation

    /// Calculates the actual height for this detent within the given container
    ///
    /// - Parameter containerHeight: The total available height for the sheet
    /// - Returns: The calculated height in points
    public func height(in containerHeight: CGFloat) -> CGFloat {
        switch self {
        case .small:
            return max(120, containerHeight * 0.15)
        case .medium:
            return containerHeight * 0.5
        case .large:
            return containerHeight * 0.9
        case .fraction(let fraction):
            let clampedFraction = max(0.1, min(1.0, fraction))
            return containerHeight * clampedFraction
        case .height(let height):
            return min(height, containerHeight * 0.95)
        }
    }

    // MARK: - Accessibility

    /// Human-readable description for VoiceOver
    public var accessibilityDescription: String {
        switch self {
        case .small:
            return "collapsed"
        case .medium:
            return "half height"
        case .large:
            return "expanded"
        case .fraction(let fraction):
            return "\(Int(fraction * 100)) percent"
        case .height(let height):
            return "\(Int(height)) points"
        }
    }
}

// MARK: - Comparable

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetDetent: Comparable {
    /// Compares detents by their approximate height
    ///
    /// This comparison uses a reference height of 1000 points to establish
    /// relative ordering. Actual heights may vary based on container size.
    public static func < (lhs: ARCBottomSheetDetent, rhs: ARCBottomSheetDetent) -> Bool {
        let referenceHeight: CGFloat = 1000
        return lhs.height(in: referenceHeight) < rhs.height(in: referenceHeight)
    }
}

// MARK: - Identifiable

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetDetent: Identifiable {
    public var id: String {
        switch self {
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        case .fraction(let fraction):
            return "fraction-\(fraction)"
        case .height(let height):
            return "height-\(height)"
        }
    }
}
