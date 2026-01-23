//
//  ARCSegment.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCSegment

/// A segment item for use in ARCSegmentedControl
///
/// `ARCSegment` represents an individual option within a segmented control,
/// supporting text, icons, or both.
///
/// ## Overview
///
/// Use `ARCSegment` to define the options available in an `ARCSegmentedControl`.
/// Each segment has a value that will be bound to the control's selection,
/// along with display content (text, icon, or both).
///
/// ## Topics
///
/// ### Creating Segments
///
/// - ``init(value:label:icon:accessibilityLabel:)``
/// - ``text(_:value:)``
/// - ``icon(_:value:accessibilityLabel:)``
/// - ``textAndIcon(_:icon:value:)``
///
/// ## Usage
///
/// ```swift
/// // Text-only segments
/// let segments = [
///     ARCSegment.text("All", value: Filter.all),
///     ARCSegment.text("Favorites", value: Filter.favorites),
///     ARCSegment.text("Recent", value: Filter.recent)
/// ]
///
/// // Icon-only segments
/// let viewModes = [
///     ARCSegment.icon("list.bullet", value: ViewMode.list, accessibilityLabel: "List view"),
///     ARCSegment.icon("square.grid.2x2", value: ViewMode.grid, accessibilityLabel: "Grid view")
/// ]
///
/// // Text with icon
/// let tabs = [
///     ARCSegment.textAndIcon("Home", icon: "house.fill", value: Tab.home),
///     ARCSegment.textAndIcon("Search", icon: "magnifyingglass", value: Tab.search)
/// ]
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSegment<Value: Hashable>: Identifiable, Sendable where Value: Sendable {
    // MARK: - Properties

    /// Unique identifier for the segment
    public let id: UUID

    /// The value associated with this segment
    public let value: Value

    /// The text label for the segment (nil for icon-only)
    public let label: String?

    /// SF Symbol name for the segment icon (nil for text-only)
    public let icon: String?

    /// Custom accessibility label (defaults to label or icon name)
    public let accessibilityLabel: String?

    // MARK: - Initialization

    /// Creates a segment with the specified content
    ///
    /// - Parameters:
    ///   - value: The value to bind when this segment is selected
    ///   - label: Optional text label
    ///   - icon: Optional SF Symbol name
    ///   - accessibilityLabel: Custom accessibility label
    public init(
        value: Value,
        label: String? = nil,
        icon: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        id = UUID()
        self.value = value
        self.label = label
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
    }

    // MARK: - Factory Methods

    /// Creates a text-only segment
    ///
    /// - Parameters:
    ///   - label: The text label to display
    ///   - value: The value to bind when selected
    /// - Returns: A configured segment
    public static func text(_ label: String, value: Value) -> Self {
        ARCSegment(value: value, label: label)
    }

    /// Creates an icon-only segment
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - value: The value to bind when selected
    ///   - accessibilityLabel: Accessibility label (required for icon-only)
    /// - Returns: A configured segment
    public static func icon(_ icon: String, value: Value, accessibilityLabel: String) -> Self {
        ARCSegment(value: value, icon: icon, accessibilityLabel: accessibilityLabel)
    }

    /// Creates a segment with both text and icon
    ///
    /// - Parameters:
    ///   - label: The text label to display
    ///   - icon: SF Symbol name for the icon
    ///   - value: The value to bind when selected
    /// - Returns: A configured segment
    public static func textAndIcon(_ label: String, icon: String, value: Value) -> Self {
        ARCSegment(value: value, label: label, icon: icon)
    }

    // MARK: - Computed Properties

    /// Returns the best accessibility label for this segment
    var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label ?? icon?.replacingOccurrences(of: ".", with: " ") ?? ""
    }

    /// Whether this segment has only an icon (no text)
    var isIconOnly: Bool {
        icon != nil && label == nil
    }

    /// Whether this segment has only text (no icon)
    var isTextOnly: Bool {
        label != nil && icon == nil
    }

    /// Whether this segment has both text and icon
    var hasTextAndIcon: Bool {
        label != nil && icon != nil
    }
}
