//
//  ARCStatDashboardConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCStatDashboard layout
///
/// ## Presets
///
/// - ``default``
/// - ``compact``
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatDashboardConfiguration: Sendable {
    /// Vertical spacing between sections
    public let sectionSpacing: CGFloat

    /// Top padding for the content
    public let topPadding: CGFloat

    /// Whether to show dividers between sections
    public let showDividers: Bool

    /// Horizontal padding for dividers
    public let dividerPadding: CGFloat

    /// Creates a dashboard configuration
    public init(sectionSpacing: CGFloat = .arcSpacingLarge,
                topPadding: CGFloat = .arcSpacingMedium,
                showDividers: Bool = true,
                dividerPadding: CGFloat = .arcSpacingLarge)
    {
        self.sectionSpacing = sectionSpacing
        self.topPadding = topPadding
        self.showDividers = showDividers
        self.dividerPadding = dividerPadding
    }

    // MARK: - Presets

    /// Default dashboard configuration with dividers
    public static let `default` = ARCStatDashboardConfiguration()

    /// Compact configuration without dividers
    public static let compact = ARCStatDashboardConfiguration(sectionSpacing: .arcSpacingMedium,
                                                              topPadding: .arcSpacingSmall,
                                                              showDividers: false)
}
