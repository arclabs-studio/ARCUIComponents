//
//  AIRecommenderExpandToggleChip.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 10/23/26.
//

import ARCDesignSystem
import SwiftUI

/// Button that expands or collapses a collapsible question's option list.
///
/// A borderless text button with a chevron and the configured "Show all" / "Show less"
/// text, so it reads as an action rather than an option. Tinted with
/// `questionnaireToggleColor`, or the inherited tint when that is `nil`.
@available(iOS 17.0, macOS 14.0, *) struct AIRecommenderExpandToggleChip: View {
    let isExpanded: Bool
    let configuration: ARCAIRecommenderConfiguration
    let action: () -> Void

    private var title: String {
        isExpanded ? configuration.questionnaireShowLessText : configuration.questionnaireShowAllText
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.subheadline)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            // Same vertical padding as the option chips keeps it aligned with them in a row.
            .padding(.horizontal, .arcSpacingSmall)
            .padding(.vertical, .arcSpacingSmall)
            // Widens the hit area to 44pt without changing the layout.
            .contentShape(Rectangle().inset(by: -.arcSpacingXSmall))
        }
        .buttonStyle(.borderless)
        .tint(configuration.questionnaireToggleColor)
        .accessibilityLabel(title)
    }
}

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *)
#Preview("Expand Toggle Chip") {
    VStack(spacing: .arcSpacingMedium) {
        AIRecommenderExpandToggleChip(isExpanded: false, configuration: .default) {}
        AIRecommenderExpandToggleChip(isExpanded: true, configuration: .default) {}
    }
    .padding()
}
#endif
