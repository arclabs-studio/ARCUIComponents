//
//  MenuLayoutOption.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

// MARK: - Menu Layout Option

enum MenuLayoutOption: String, CaseIterable, Identifiable {
    case flat = "Flat"
    case sectioned = "Sectioned"

    var id: String {
        rawValue
    }

    var name: String {
        rawValue
    }

    var icon: String {
        switch self {
        case .flat: "list.bullet"
        case .sectioned: "list.bullet.indent"
        }
    }

    var cardTitle: String {
        switch self {
        case .flat: "Flat Layout (Default)"
        case .sectioned: "Sectioned Layout (New)"
        }
    }

    var cardDescription: String {
        switch self {
        case .flat: "VStack with dividers — use ARCMenuViewModel(menuItems:)"
        case .sectioned: "Native Form with sections — use ARCMenuViewModel(sections:)"
        }
    }

    var codeSnippets: [(label: String, code: String)] {
        switch self {
        case .flat:
            [("Init", "ARCMenuViewModel(menuItems: [...])"),
             ("Config", ".default"),
             ("Layout", ".flat (VStack + dividers)")]
        case .sectioned:
            [("Init", "ARCMenuViewModel(sections: [...])"),
             ("Config", ".sectioned"),
             ("Layout", ".grouped (Form + sections)")]
        }
    }

    var featureIcon: String {
        switch self {
        case .flat: "rectangle.bottomhalf.inset.filled"
        case .sectioned: "list.bullet.rectangle"
        }
    }

    var featureTitle: String {
        switch self {
        case .flat: "Flat Menu"
        case .sectioned: "Sectioned Menu"
        }
    }

    var featureDescription: String {
        switch self {
        case .flat:
            "Simple list of items with dividers. Best for short, uniform menus."
        case .sectioned:
            "Items grouped into titled sections using native Form. Best for menus with distinct categories."
        }
    }

    var features: [(icon: String, text: String)] {
        switch self {
        case .flat:
            [("list.bullet", "VStack with dividers"),
             ("arrow.up.doc", "Native .sheet() presentation"),
             ("hand.draw", "Swipe down to dismiss"),
             ("person.circle", "User profile header"),
             ("sparkles", "iOS 26+ Liquid Glass ready")]
        case .sectioned:
            [("list.bullet.indent", "Sections with title & footer"),
             ("rectangle.on.rectangle", "Native Form + .grouped style"),
             ("scroll", "Scrollable within medium detent"),
             ("tag", "Badge and destructive support"),
             ("accessibility", "Full VoiceOver support")]
        }
    }
}
