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
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderHeader: View {
    // MARK: - Properties

    let configuration: ARCAIRecommenderConfiguration

    // MARK: - Body

    var body: some View {
        VStack(spacing: .arcSpacingMedium) {
            // Animated icon in gradient circle
            iconView

            // Title and subtitle
            VStack(spacing: .arcSpacingXSmall) {
                Text(configuration.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(configuration.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, .arcSpacingLarge)
        .padding(.top, .arcSpacingMedium)
    }

    // MARK: - Private Views

    @ViewBuilder private var iconView: some View {
        ZStack {
            // Gradient circle background
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            configuration.accentColor.opacity(0.3),
                            configuration.accentColor.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)

            // Icon with optional pulse animation
            if configuration.animateHeaderIcon {
                Image(systemName: configuration.headerIcon)
                    .font(.largeTitle)
                    .foregroundStyle(configuration.accentColor)
                    .symbolEffect(.pulse, options: .repeating)
            } else {
                Image(systemName: configuration.headerIcon)
                    .font(.largeTitle)
                    .foregroundStyle(configuration.accentColor)
            }
        }
    }
}

// MARK: - Previews

#if os(iOS)
#Preview("Header - Default") {
    AIRecommenderHeader(configuration: .default)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Header - Restaurant") {
    AIRecommenderHeader(configuration: .restaurant)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Header - Books") {
    AIRecommenderHeader(configuration: .books)
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
