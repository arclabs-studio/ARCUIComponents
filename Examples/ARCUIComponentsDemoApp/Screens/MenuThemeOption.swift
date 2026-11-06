//
//  MenuThemeOption.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

// MARK: - Menu Theme Option

enum MenuThemeOption: String, CaseIterable, Identifiable {
    case arcBrand
    case fitness
    case premium
    case dark

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .arcBrand: "ARC"
        case .fitness: "Fitness"
        case .premium: "Premium"
        case .dark: "Dark"
        }
    }

    var accentColor: Color {
        switch self {
        case .arcBrand: .arcBrandGold
        case .fitness: .green
        case .premium: .orange
        case .dark: .purple
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .arcBrand: [.arcBrandBurgundy, .arcBrandBurgundy.opacity(0.7)]
        case .fitness: [.green, .mint]
        case .premium: [Color.arcBrandGold, Color.arcBrandBurgundy]
        case .dark: [.gray, Color.arcBrandBlack]
        }
    }
}
