//
//  LiquidGlassShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating the liquid glass effect with various configurations
///
/// This view provides a visual gallery of the liquid glass effect in action,
/// demonstrating different background styles, shadows, and configurations.
///
/// Use this showcase to:
/// - Preview the liquid glass effect in different contexts
/// - Test visual appearance in Light and Dark modes
/// - Compare different background styles side by side
/// - Verify accessibility and Dynamic Type support
@available(iOS 17.0, *)
public struct LiquidGlassShowcase: View {
    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                // Header
                VStack(spacing: .arcSpacingSmall) {
                    Text("Liquid Glass Effect")
                        .font(.largeTitle.bold())

                    Text("Apple's premium glassmorphism")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                // Examples
                VStack(spacing: 40) { // Intentionally larger than arcSpacingXXLarge for showcase
                    liquidGlassExample
                    translucentExample
                    solidExample
                    materialExample
                    colorVariationsExample
                    shadowVariationsExample
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3),
                    Color.pink.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    // MARK: - Examples

    private var liquidGlassExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Liquid Glass",
                subtitle: "Premium Apple-style effect"
            )

            ExampleCard(configuration: LiquidGlassConfiguration(
                accentColor: .blue,
                backgroundStyle: .liquidGlass,
                cornerRadius: .arcCornerRadiusLarge,
                shadow: .default
            ))
        }
    }

    private var translucentExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Translucent",
                subtitle: "Standard blur with minimal accent"
            )

            ExampleCard(configuration: LiquidGlassConfiguration(
                accentColor: .green,
                backgroundStyle: .translucent,
                cornerRadius: .arcCornerRadiusLarge,
                shadow: .subtle
            ))
        }
    }

    private var solidExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Solid",
                subtitle: "Custom color with opacity"
            )

            ExampleCard(configuration: LiquidGlassConfiguration(
                accentColor: .orange,
                backgroundStyle: .solid(.orange, opacity: 0.3),
                cornerRadius: .arcCornerRadiusLarge,
                shadow: .default
            ))
        }
    }

    private var materialExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Material",
                subtitle: "Custom SwiftUI material"
            )

            ExampleCard(configuration: LiquidGlassConfiguration(
                accentColor: .purple,
                backgroundStyle: .material(.thick),
                cornerRadius: .arcCornerRadiusLarge,
                shadow: .default
            ))
        }
    }

    private var colorVariationsExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Color Variations",
                subtitle: "Different accent colors"
            )

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: .arcSpacingLarge) {
                ForEach(ColorVariation.allCases, id: \.self) { variation in
                    SmallExampleCard(
                        configuration: LiquidGlassConfiguration(
                            accentColor: variation.color,
                            backgroundStyle: .liquidGlass,
                            cornerRadius: .arcCornerRadiusMedium,
                            shadow: .subtle
                        ),
                        title: variation.name
                    )
                }
            }
        }
    }

    private var shadowVariationsExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            SectionHeader(
                title: "Shadow Variations",
                subtitle: "Different shadow depths"
            )

            VStack(spacing: .arcSpacingLarge) {
                ForEach(ShadowVariation.allCases, id: \.self) { variation in
                    MediumExampleCard(
                        configuration: LiquidGlassConfiguration(
                            accentColor: .blue,
                            backgroundStyle: .liquidGlass,
                            cornerRadius: .arcCornerRadiusLarge,
                            shadow: variation.shadow
                        ),
                        title: variation.name,
                        subtitle: variation.description
                    )
                }
            }
        }
    }
}

// MARK: - Example Configuration

@available(iOS 17.0, *)
private struct LiquidGlassConfiguration: LiquidGlassConfigurable {
    let accentColor: Color
    let backgroundStyle: ARCBackgroundStyle
    let cornerRadius: CGFloat
    let shadow: ARCShadow
}

// MARK: - Example Card

@available(iOS 17.0, *)
private struct ExampleCard: View {
    let configuration: LiquidGlassConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.blue.gradient)

                Text("Example Component")
                    .font(.headline)

                Spacer()
            }

            Text("This demonstrates how the liquid glass effect appears with real content. The background adapts to the system appearance and provides excellent readability.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.arcSpacingXLarge)
        .liquidGlass(configuration: configuration)
        .accessibilityElement(children: .combine)
    }
}

@available(iOS 17.0, *)
private struct SmallExampleCard: View {
    let configuration: LiquidGlassConfiguration
    let title: String

    var body: some View {
        VStack(spacing: .arcSpacingSmall) {
            Image(systemName: "circle.fill")
                .font(.title)
                .foregroundStyle(configuration.accentColor.gradient)

            Text(title)
                .font(.caption.bold())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .arcSpacingXLarge)
        .liquidGlass(configuration: configuration)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) liquid glass example")
    }
}

@available(iOS 17.0, *)
private struct MediumExampleCard: View {
    let configuration: LiquidGlassConfiguration
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: .arcSpacingMedium) {
            Image(systemName: "shadow")
                .font(.title2)
                .foregroundStyle(.blue.gradient)

            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.arcPaddingCard)
        .liquidGlass(configuration: configuration)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(subtitle)")
    }
}

// MARK: - Section Header

@available(iOS 17.0, *)
private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Color Variations

@available(iOS 17.0, *)
private enum ColorVariation: CaseIterable {
    case blue, purple, green, orange, pink, indigo

    var name: String {
        switch self {
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .green: return "Green"
        case .orange: return "Orange"
        case .pink: return "Pink"
        case .indigo: return "Indigo"
        }
    }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .purple: return .purple
        case .green: return .green
        case .orange: return .orange
        case .pink: return .pink
        case .indigo: return .indigo
        }
    }
}

// MARK: - Shadow Variations

@available(iOS 17.0, *)
private enum ShadowVariation: CaseIterable {
    case none, subtle, `default`, prominent

    var name: String {
        switch self {
        case .none: return "None"
        case .subtle: return "Subtle"
        case .default: return "Default"
        case .prominent: return "Prominent"
        }
    }

    var description: String {
        switch self {
        case .none: return "No shadow"
        case .subtle: return "Light shadow, 5pt offset"
        case .default: return "Standard shadow, 10pt offset"
        case .prominent: return "Strong shadow, 15pt offset"
        }
    }

    var shadow: ARCShadow {
        switch self {
        case .none: return .none
        case .subtle: return .subtle
        case .default: return .default
        case .prominent: return .prominent
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    LiquidGlassShowcase()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    LiquidGlassShowcase()
        .preferredColorScheme(.dark)
}

#Preview("Accessibility - Extra Large") {
    LiquidGlassShowcase()
        .environment(\.dynamicTypeSize, .accessibility3)
}
