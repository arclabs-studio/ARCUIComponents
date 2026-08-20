//
//  ARCMenuSection.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/25/26.
//

import Foundation

// MARK: - ARCMenuLayoutStyle

/// Layout style for ARCMenu content
///
/// Controls how menu items are rendered:
/// - `.flat`: Existing VStack behavior with dividers (default)
/// - `.grouped`: Form with sections for grouped content
public enum ARCMenuLayoutStyle: Sendable {
    /// Flat VStack layout with dividers between items (default)
    case flat
    /// Grouped Form layout with sections
    case grouped
}

// MARK: - ARCMenuSection

/// A group of menu items displayed as a section
///
/// Use sections to organize menu items into logical groups when using
/// `.grouped` layout style.
///
/// ## Usage
///
/// ```swift
/// let section = ARCMenuSection(
///     title: "Settings",
///     footer: "Customize your experience",
///     items: [
///         ARCMenuItem(title: "Theme", icon: .system("paintbrush.fill"), action: {}),
///         ARCMenuItem(title: "Language", icon: .system("globe"), action: {})
///     ]
/// )
/// ```
public struct ARCMenuSection: Identifiable, Sendable {
    /// Unique identifier
    public let id: UUID

    /// Optional section header title
    public let title: String?

    /// Optional section footer text
    public let footer: String?

    /// Menu items in this section
    public let items: [ARCMenuItem]

    /// Creates a new menu section
    ///
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - title: Optional section header title
    ///   - footer: Optional section footer text
    ///   - items: Menu items to display in this section
    public init(id: UUID = UUID(),
                title: String? = nil,
                footer: String? = nil,
                items: [ARCMenuItem]) {
        self.id = id
        self.title = title
        self.footer = footer
        self.items = items
    }
}
