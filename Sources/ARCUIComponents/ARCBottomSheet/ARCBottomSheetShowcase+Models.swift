//
//  ARCBottomSheetShowcase+Models.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 23/1/26.
//

import SwiftUI

// MARK: - ShowcaseSection

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    enum ShowcaseSection: String, CaseIterable {
        case configurations, detents, interactive
    }
}

// MARK: - ConfigOption

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    enum ConfigOption: String, CaseIterable, Identifiable {
        case `default`
        case modal
        case persistent
        case drawer
        case glass
        case compact

        var id: String { rawValue }

        var title: String {
            switch self {
            case .default: "Default"
            case .modal: "Modal"
            case .persistent: "Persistent"
            case .drawer: "Drawer"
            case .glass: "Glass"
            case .compact: "Compact"
            }
        }

        var description: String {
            switch self {
            case .default:
                "Balanced settings with handle, dismissable, background dimming"
            case .modal:
                "Strong dimming, tap background to dismiss, focused presentation"
            case .persistent:
                "Non-dismissable, no background dimming, always visible"
            case .drawer:
                "Maps-style drawer, non-dismissable, semi-transparent"
            case .glass:
                "Premium liquid glass effect with larger corner radius"
            case .compact:
                "Smaller handle, lighter styling for small content"
            }
        }

        var icon: String {
            switch self {
            case .default: "slider.horizontal.3"
            case .modal: "rectangle.portrait.on.rectangle.portrait"
            case .persistent: "pin.fill"
            case .drawer: "map"
            case .glass: "sparkles"
            case .compact: "rectangle.compress.vertical"
            }
        }

        var color: Color {
            switch self {
            case .default: .blue
            case .modal: .purple
            case .persistent: .green
            case .drawer: .orange
            case .glass: .pink
            case .compact: .gray
            }
        }

        var configuration: ARCBottomSheetConfiguration {
            switch self {
            case .default: .default
            case .modal: .modal
            case .persistent: .persistent
            case .drawer: .drawer
            case .glass: .glass
            case .compact: .compact
            }
        }
    }
}
