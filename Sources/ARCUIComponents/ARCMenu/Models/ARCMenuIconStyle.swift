//
//  ARCMenuIconStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 01/27/26.
//

import SwiftUI

/// Style for menu item icons in ARCMenu
///
/// Determines how icons are rendered within menu item rows.
/// Use `.subtle` for a minimal appearance or `.prominent` for
/// a more visible, category-style icon presentation.
public enum ARCMenuIconStyle: Sendable {
    /// Subtle background with primary-colored icon
    ///
    /// The icon uses a low-opacity accent color background (15%)
    /// with the icon itself in primary color. This is the default
    /// style that blends well with most menu designs.
    case subtle

    /// Prominent background with dark icon on accent color
    ///
    /// The icon uses a high-opacity accent color background (90%)
    /// with a dark icon for strong contrast. This style is ideal
    /// for category-style menus where icons should stand out,
    /// similar to cuisine category lists.
    case prominent
}
