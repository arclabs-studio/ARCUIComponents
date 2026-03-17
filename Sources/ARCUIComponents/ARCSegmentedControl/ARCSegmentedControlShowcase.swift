//
//  ARCSegmentedControlShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCSegmentedControlShowcase

/// Comprehensive showcase of ARCSegmentedControl configurations
///
/// Demonstrates all visual styles, sizes, and content types for the
/// segmented control component.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSegmentedControlShowcase: View {
    // MARK: - State

    @State private var filledSelection = 0
    @State private var outlinedSelection = 0
    @State private var glassSelection = 0
    @State private var underlinedSelection = 0
    @State private var pillSelection = 0
    @State private var iconSelection = 0
    @State private var mixedSelection = 0
    @State private var sizeSelection = 0

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                stylesSection
                sizesSection
                contentTypesSection
                customizationSection
            }
            .padding()
        }
        .navigationTitle("Segmented Control")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: - Initialization

    public init() {}
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCSegmentedControlShowcase {
    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Styles", subtitle: "Different visual appearances")

            VStack(spacing: 24) {
                styleRow("Filled (Default)", description: "iOS system style") {
                    ARCSegmentedControl(
                        selection: $filledSelection,
                        segments: [
                            .text("All", value: 0),
                            .text("Active", value: 1),
                            .text("Done", value: 2)
                        ]
                    )
                }

                styleRow("Outlined", description: "Border highlight") {
                    ARCSegmentedControl(
                        selection: $outlinedSelection,
                        segments: [
                            .text("Day", value: 0),
                            .text("Week", value: 1),
                            .text("Month", value: 2)
                        ],
                        configuration: .outlined
                    )
                }

                styleRow("Underlined", description: "Tab-style indicator") {
                    ARCSegmentedControl(
                        selection: $underlinedSelection,
                        segments: [
                            .text("Posts", value: 0),
                            .text("Replies", value: 1),
                            .text("Likes", value: 2)
                        ],
                        configuration: .underlined
                    )
                }

                styleRow("Pill", description: "Compact rounded style") {
                    ARCSegmentedControl(
                        selection: $pillSelection,
                        segments: [
                            .text("On", value: 0),
                            .text("Off", value: 1)
                        ],
                        configuration: .pill
                    )
                }

                glassStyleRow
            }
        }
    }

    private var glassStyleRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Glass")
                    .font(.body.weight(.medium))
                Text("Liquid glass blur effect")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ZStack {
                LinearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                ARCSegmentedControl(
                    selection: $glassSelection,
                    segments: [
                        .text("Photos", value: 0),
                        .text("Videos", value: 1),
                        .text("Albums", value: 2)
                    ],
                    configuration: .glass
                )
                .padding()
            }
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func styleRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Sizes Section

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Sizes", subtitle: "Small, medium, and large variants")

            VStack(spacing: 16) {
                sizeRow("Small", height: "28pt") {
                    ARCSegmentedControl(
                        selection: $sizeSelection,
                        segments: [
                            .text("A", value: 0),
                            .text("B", value: 1),
                            .text("C", value: 2)
                        ],
                        configuration: .small
                    )
                }

                sizeRow("Medium", height: "36pt") {
                    ARCSegmentedControl(
                        selection: $sizeSelection,
                        segments: [
                            .text("Option A", value: 0),
                            .text("Option B", value: 1),
                            .text("Option C", value: 2)
                        ]
                    )
                }

                sizeRow("Large", height: "44pt") {
                    ARCSegmentedControl(
                        selection: $sizeSelection,
                        segments: [
                            .text("First", value: 0),
                            .text("Second", value: 1),
                            .text("Third", value: 2)
                        ],
                        configuration: .large
                    )
                }
            }
        }
    }

    private func sizeRow(_ title: String, height: String, @ViewBuilder content: () -> some View) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.medium))
                Text(height)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .frame(width: 60, alignment: .leading)

            content()
        }
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Content Types Section

    private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Content Types", subtitle: "Text, icons, or both")

            VStack(spacing: 16) {
                contentRow("Text Only", description: "Simple text labels") {
                    ARCSegmentedControl(
                        selection: $filledSelection,
                        segments: [
                            .text("Today", value: 0),
                            .text("This Week", value: 1),
                            .text("This Month", value: 2)
                        ]
                    )
                }

                contentRow("Icons Only", description: "SF Symbols") {
                    ARCSegmentedControl(
                        selection: $iconSelection,
                        segments: [
                            .icon("list.bullet", value: 0, accessibilityLabel: "List view"),
                            .icon("square.grid.2x2", value: 1, accessibilityLabel: "Grid view"),
                            .icon("rectangle.grid.1x2", value: 2, accessibilityLabel: "Gallery view")
                        ],
                        configuration: .pill
                    )
                }

                contentRow("Text + Icon", description: "Combined content") {
                    ARCSegmentedControl(
                        selection: $mixedSelection,
                        segments: [
                            .textAndIcon("Home", icon: "house.fill", value: 0),
                            .textAndIcon("Search", icon: "magnifyingglass", value: 1),
                            .textAndIcon("Profile", icon: "person.fill", value: 2)
                        ]
                    )
                }
            }
        }
    }

    private func contentRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Customization Section

    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Customization", subtitle: "Custom colors and styles")

            VStack(spacing: 16) {
                customRow("Custom Colors") {
                    VStack(spacing: 12) {
                        ARCSegmentedControl(
                            selection: $filledSelection,
                            segments: [
                                .text("Red", value: 0),
                                .text("Blue", value: 1),
                                .text("Green", value: 2)
                            ],
                            configuration: ARCSegmentedControlConfiguration(
                                selectedColor: .red,
                                selectedTextColor: .white
                            )
                        )

                        ARCSegmentedControl(
                            selection: $outlinedSelection,
                            segments: [
                                .text("Purple", value: 0),
                                .text("Orange", value: 1)
                            ],
                            configuration: ARCSegmentedControlConfiguration(
                                style: .outlined,
                                selectedColor: .purple,
                                selectedTextColor: .purple
                            )
                        )
                    }
                }

                customRow("Wide Segments") {
                    ARCSegmentedControl(
                        selection: $filledSelection,
                        segments: [
                            .text("Yes", value: 0),
                            .text("No", value: 1)
                        ],
                        configuration: ARCSegmentedControlConfiguration(
                            size: .large,
                            cornerRadius: 22
                        )
                    )
                }

                customRow("No Animation") {
                    ARCSegmentedControl(
                        selection: $filledSelection,
                        segments: [
                            .text("Instant", value: 0),
                            .text("Switch", value: 1)
                        ],
                        configuration: ARCSegmentedControlConfiguration(
                            animated: false,
                            hapticFeedback: false
                        )
                    )
                }
            }
        }
    }

    private func customRow(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.body.weight(.medium))

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCSegmentedControlShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCSegmentedControlShowcase()
    }
    .preferredColorScheme(.dark)
}
