//
//  PresentationStyleOption.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

// MARK: - Presentation Style Option

enum PresentationStyleOption: String, CaseIterable, Identifiable {
    case bottomSheet
    case trailingPanel

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .bottomSheet: "Bottom Sheet"
        case .trailingPanel: "Trailing Panel"
        }
    }

    var style: ARCMenuPresentationStyle {
        switch self {
        case .bottomSheet: .bottomSheet
        case .trailingPanel: .trailingPanel
        }
    }
}
