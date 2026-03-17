//
//  ARCStatGrid.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// A grid layout for arranging stat cards and metrics
///
/// Wraps content in a LazyVGrid with configurable columns and spacing.
/// Typically used to arrange `ARCStatCard` instances in a 2-column layout.
///
/// ## Usage
///
/// ```swift
/// ARCStatGrid {
///     ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
///     ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites")
///     ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
///     ARCStatCard(rating: 7.8, label: "Average rating")
/// }
///
/// // 3-column grid
/// ARCStatGrid(columns: 3) {
///     // ...
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatGrid<Content: View>: View {
    // MARK: - Properties

    private let columns: Int
    private let spacing: CGFloat
    private let content: Content

    // MARK: - Initialization

    /// Creates a stat grid
    ///
    /// - Parameters:
    ///   - columns: Number of columns (default: 2)
    ///   - spacing: Spacing between items (default: arcSpacingMedium)
    ///   - content: Grid content (typically ARCStatCard instances)
    public init(columns: Int = 2,
                spacing: CGFloat = .arcSpacingMedium,
                @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns),
                  spacing: spacing) {
            content
        }
        .padding(.horizontal, .arcSpacingLarge)
    }
}

// MARK: - Preview

#Preview("ARCStatGrid") {
    ARCStatGrid {
        ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
        ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
        ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
        ARCStatCard(rating: 7.8, label: "Avg rating")
    }
    .padding()
}
