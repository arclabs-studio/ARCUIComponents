//
//  ARCMenuShowcase+Models.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import SwiftUI

// MARK: - ShowcaseStyle

@available(iOS 17.0, macOS 14.0, *)
enum ShowcaseStyle: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case green = "Green"
    case orange = "Orange"
    case purple = "Purple"
    case trailingPanel = "Trailing Panel"

    var id: String { rawValue }

    var name: String { rawValue }

    var configName: String {
        switch self {
        case .default: "default"
        case .green: "ARCMenuConfiguration(accentColor: .green)"
        case .orange: "ARCMenuConfiguration(accentColor: .orange)"
        case .purple: "ARCMenuConfiguration(accentColor: .purple)"
        case .trailingPanel: "trailingPanel"
        }
    }

    var accentColor: Color {
        switch self {
        case .default: .arcBrandGold
        case .green: .green
        case .orange: .orange
        case .purple: .purple
        case .trailingPanel: .arcBrandGold
        }
    }

    var configuration: ARCMenuConfiguration {
        switch self {
        case .default: .default
        case .green: ARCMenuConfiguration(accentColor: .green)
        case .orange: ARCMenuConfiguration(accentColor: .orange)
        case .purple: ARCMenuConfiguration(accentColor: .purple)
        case .trailingPanel: .trailingPanel
        }
    }

    var description: String {
        switch self {
        case .default: "ARC Brand Gold accent"
        case .green: "Health & Fitness apps"
        case .orange: "Subscription services"
        case .purple: "Dark theme apps"
        case .trailingPanel: "Drawer style (iPad/Mac)"
        }
    }

    var icon: String {
        switch self {
        case .default: "menucard"
        case .green: "figure.run"
        case .orange: "crown.fill"
        case .purple: "moon.stars.fill"
        case .trailingPanel: "sidebar.trailing"
        }
    }

    // swiftlint:disable:next large_tuple
    var sampleUser: (name: String, email: String?, initials: String) {
        switch self {
        case .default: ("ARC User", "user@arclabs.studio", "AU")
        case .green: ("Athlete Pro", "athlete@fit.app", "AP")
        case .orange: ("Gold Member", "gold@premium.app", "GM")
        case .purple: ("Night User", "night@dark.app", "NU")
        case .trailingPanel: ("Panel User", "user@app.com", "PU")
        }
    }
}

// MARK: - ShowcaseVariant

@available(iOS 17.0, macOS 14.0, *)
enum ShowcaseVariant: String, CaseIterable, Identifiable {
    case full = "Full"
    case compact = "Compact"
    case minimal = "Minimal"
    case custom = "Custom"

    var id: String { rawValue }

    var name: String { rawValue }

    var description: String {
        switch self {
        case .full: "All menu items"
        case .compact: "Essential items only"
        case .minimal: "Just logout"
        case .custom: "Custom actions"
        }
    }

    var icon: String {
        switch self {
        case .full: "list.bullet"
        case .compact: "list.dash"
        case .minimal: "minus.circle"
        case .custom: "slider.horizontal.3"
        }
    }
}
