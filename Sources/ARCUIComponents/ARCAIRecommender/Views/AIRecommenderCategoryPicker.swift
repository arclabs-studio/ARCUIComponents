//
//  AIRecommenderCategoryPicker.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Horizontal scrolling category picker with capsule buttons
///
/// Displays categories as selectable pills that highlight when selected.
/// Supports both predefined and custom categories.
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderCategoryPicker: View {
    // MARK: - Properties

    let categories: [AIRecommenderCategory]
    @Binding var selectedCategory: AIRecommenderCategory
    let configuration: ARCAIRecommenderConfiguration
    let onCategorySelected: ((AIRecommenderCategory) -> Void)?

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .arcSpacingSmall) {
                ForEach(categories) { category in
                    CategoryCapsule(
                        category: category,
                        isSelected: selectedCategory == category,
                        configuration: configuration
                    ) {
                        arcWithAnimation(configuration.categoryAnimation) {
                            selectedCategory = category
                        }
                        onCategorySelected?(category)
                    }
                }
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }
}

// MARK: - Category Capsule

/// Individual category pill button
@available(iOS 17.0, macOS 14.0, *)
private struct CategoryCapsule: View {
    // MARK: - Properties

    let category: AIRecommenderCategory
    let isSelected: Bool
    let configuration: ARCAIRecommenderConfiguration
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if configuration.showCategoryIcons {
                    Image(systemName: category.icon)
                        .font(.subheadline)
                }

                Text(category.shortLabel)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, .arcSpacingMedium)
            .padding(.vertical, .arcSpacingSmall)
            .background(
                Capsule()
                    .fill(
                        isSelected
                            ? configuration.accentColor
                            : Color.gray.opacity(0.15)
                    )
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(category.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Previews

#if os(iOS)
#Preview("Category Picker") {
    @Previewable @State var selected: AIRecommenderCategory = .favorites

    VStack(spacing: 20) {
        AIRecommenderCategoryPicker(
            categories: AIRecommenderCategory.defaultCategories,
            selectedCategory: $selected,
            configuration: .default,
            onCategorySelected: nil
        )

        Text("Selected: \(selected.label)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding(.vertical)
    .background(Color(.systemGroupedBackground))
}

#Preview("Category Picker - No Icons") {
    @Previewable @State var selected: AIRecommenderCategory = .trending

    AIRecommenderCategoryPicker(
        categories: AIRecommenderCategory.defaultCategories,
        selectedCategory: $selected,
        configuration: .compact,
        onCategorySelected: nil
    )
    .padding(.vertical)
    .background(Color(.systemGroupedBackground))
}

#Preview("Category Picker - Dark Mode") {
    @Previewable @State var selected: AIRecommenderCategory = .new

    AIRecommenderCategoryPicker(
        categories: AIRecommenderCategory.defaultCategories,
        selectedCategory: $selected,
        configuration: .default,
        onCategorySelected: nil
    )
    .padding(.vertical)
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
#endif
