//
//  ARCMenuPresentationStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 01/16/26.
//

import SwiftUI

/// Presentation style for ARCMenu
///
/// Defines how the menu appears and animates on screen.
/// Following Apple's Human Interface Guidelines, `bottomSheet` is the
/// recommended default for iOS apps, while `trailingPanel` provides
/// an alternative drawer-style presentation.
public enum ARCMenuPresentationStyle: Sendable, Equatable {
    /// Presents the menu from the bottom of the screen (Apple standard)
    ///
    /// This is the recommended style for iOS apps, matching the behavior
    /// of Apple Music, Apple TV, Slack and other first-party apps.
    /// Supports drag-to-dismiss by swiping down.
    case bottomSheet

    /// Presents the menu from the trailing edge (right side in LTR layouts)
    ///
    /// A drawer-style presentation useful for iPad apps or when a
    /// side panel layout is preferred. Supports drag-to-dismiss
    /// by swiping towards the trailing edge.
    case trailingPanel
}

// MARK: - Presentation Style Properties

extension ARCMenuPresentationStyle {
    /// The edge from which the menu enters the screen
    var enteringEdge: Edge {
        switch self {
        case .bottomSheet:
            return .bottom
        case .trailingPanel:
            return .trailing
        }
    }

    /// The alignment for positioning the menu content
    var contentAlignment: Alignment {
        switch self {
        case .bottomSheet:
            return .bottom
        case .trailingPanel:
            return .topTrailing
        }
    }

    /// Whether the drag gesture should track vertical movement
    var isVerticalDrag: Bool {
        switch self {
        case .bottomSheet:
            return true
        case .trailingPanel:
            return false
        }
    }
}
