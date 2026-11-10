//
//  ARCBottomSheetDemoScreen+ConfigPreset.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

// MARK: - ConfigPreset

@available(iOS 17.0, *) extension ARCBottomSheetDemoScreen {
    enum ConfigPreset {
        case `default`
        case modal
        case glass
        case compact

        var title: String {
            switch self {
            case .default: "Default"
            case .modal: "Modal"
            case .glass: "Glass"
            case .compact: "Compact"
            }
        }

        var configuration: ARCBottomSheetConfiguration {
            switch self {
            case .default: .default
            case .modal: .modal
            case .glass: .glass
            case .compact: .compact
            }
        }

        var detents: Set<ARCBottomSheetDetent> {
            [.small, .medium, .large]
        }
    }
}
