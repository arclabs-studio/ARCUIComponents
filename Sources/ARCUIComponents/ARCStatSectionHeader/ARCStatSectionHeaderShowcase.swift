//
//  ARCStatSectionHeaderShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCStatSectionHeader
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatSectionHeaderShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXLarge) {
                ARCStatSectionHeader(title: "Ratings", icon: "star.fill")
                ARCStatSectionHeader(title: "Cuisines", icon: "fork.knife")
                ARCStatSectionHeader(title: "Timeline", icon: "calendar")
                ARCStatSectionHeader(title: "Spending", icon: "creditcard.fill")
                ARCStatSectionHeader(title: "Geography", icon: "map.fill")
                ARCStatSectionHeader(title: "Genres", icon: "books.vertical.fill")
                ARCStatSectionHeader(title: "Authors", icon: "person.2.fill")
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCStatSectionHeader")
    }
}

// MARK: - Preview

#Preview("ARCStatSectionHeader") {
    NavigationStack {
        ARCStatSectionHeaderShowcase()
    }
}
