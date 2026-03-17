//
//  AIRecommenderHeader.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Hero header for the AI Recommender with animated sparkles icon
///
/// Displays a large circular gradient background with the configured icon,
/// title, and subtitle. Follows Apple Intelligence design patterns.
@available(iOS 17.0, macOS 14.0, *) struct AIRecommenderHeader: View {
    // MARK: - Properties

    let configuration: ARCAIRecommenderConfiguration

    // MARK: - Body

    var body: some View {
        VStack(spacing: .arcSpacingLarge) {
            // Animated icon in gradient circle
            iconView

            // Subtitle only (title belongs in navigation bar per HIG)
            Text(configuration.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, configuration.headerTopPadding)
        .padding(.horizontal, .arcSpacingLarge)
    }

    // MARK: - Private Views

    private var iconView: some View {
        ZStack {
            // Gradient circle background
            Circle()
                .fill(LinearGradient(colors: [configuration.accentColor.opacity(0.3),
                                              configuration.accentColor.opacity(0.1)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: configuration.headerIconCircleSize,
                       height: configuration.headerIconCircleSize)

            // Icon with optional pulse animation
            if configuration.animateHeaderIcon {
                imageView
                    .symbolEffect(.pulse, options: .repeating)
            } else {
                imageView
            }
        }
    }

    private var imageView: some View {
        Image(systemName: configuration.headerIcon)
            .font(configuration.headerIconFont)
            .foregroundStyle(configuration.accentColor)
    }
}

// MARK: - Previews

#if os(iOS)
#Preview("Header - Default") {
    AIRecommenderHeader(configuration: .default)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Header - Minimal") {
    AIRecommenderHeader(configuration: .minimal)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Header - Dark Mode") {
    AIRecommenderHeader(configuration: .default)
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
}
#endif
