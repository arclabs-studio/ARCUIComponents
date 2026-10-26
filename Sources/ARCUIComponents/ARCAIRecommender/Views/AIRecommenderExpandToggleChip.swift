//
//  AIRecommenderExpandToggleChip.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 10/23/26.
//

import ARCDesignSystem
import SwiftUI

/// Chip that expands or collapses a collapsible question's option list.
///
/// Styled like an unselected option chip, with a chevron and the configured
/// "Show all" / "Show less" text.
@available(iOS 17.0, macOS 14.0, *) struct AIRecommenderExpandToggleChip: View {
    let isExpanded: Bool
    let configuration: ARCAIRecommenderConfiguration
    let action: () -> Void

    @ScaledMetric(relativeTo: .subheadline) private var minHeight: CGFloat = .arcTouchTargetMinimum

    private var title: String {
        isExpanded ? configuration.questionnaireShowLessText : configuration.questionnaireShowAllText
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.subheadline)
                    .foregroundStyle(configuration.accentColor)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, .arcSpacingMedium)
            .padding(.vertical, .arcSpacingSmall)
            .frame(minHeight: minHeight)
            .background(Capsule()
                .fill(Color.gray.opacity(0.15)))
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
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
