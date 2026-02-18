//
//  ARCStatSectionHeader.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// A section header for statistics dashboards
///
/// Displays a bold title with an SF Symbol icon, left-aligned with standard padding.
///
/// ## Usage
///
/// ```swift
/// ARCStatSectionHeader(title: "Ratings", icon: "star.fill")
/// ARCStatSectionHeader(title: "Timeline", icon: "calendar")
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatSectionHeader: View {
    // MARK: - Properties

    private let title: String
    private let icon: String

    // MARK: - Initialization

    /// Creates a section header
    ///
    /// - Parameters:
    ///   - title: The section title
    ///   - icon: SF Symbol name for the icon
    public init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        Label(title, systemImage: icon)
            .font(.title3.bold())
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, .arcSpacingLarge)
    }
}

// MARK: - Preview

#Preview("ARCStatSectionHeader") {
    VStack(spacing: 20) {
        ARCStatSectionHeader(title: "Ratings", icon: "star.fill")
        ARCStatSectionHeader(title: "Timeline", icon: "calendar")
        ARCStatSectionHeader(title: "Geography", icon: "map.fill")
    }
}
