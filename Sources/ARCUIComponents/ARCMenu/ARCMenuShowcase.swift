//
//  ARCMenuShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// ARCMenu Showcase - Interactive Demo
///
/// A comprehensive showcase demonstrating all ARCMenu variants,
/// configurations, and customization options in an elegant,
/// navigable interface.
///
/// Perfect for:
/// - Visual testing and QA
/// - Client demonstrations
/// - Design reference
/// - Integration examples
/// - Feature exploration
@available(iOS 17.0, macOS 14.0, *)
public struct ARCMenuShowcase: View {
    // MARK: - State

    @State private var selectedStyle: ShowcaseStyle = .default
    @State private var selectedVariant: ShowcaseVariant = .full
    @State private var showBadge = true
    @State private var badgeCount = 3
    @State private var showUserHeader = true

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Hero Section
                    heroSection

                    // Live Preview Card
                    livePreviewCard

                    // Style Selector
                    styleSelectorSection

                    // Variant Selector
                    variantSelectorSection

                    // Options Section
                    optionsSection

                    // Code Example
                    codeExampleSection

                    // All Styles Gallery
                    allStylesGallery
                }
                .padding(.bottom, .arcSpacingXXLarge)
            }
            .background(Color.arcBackgroundPrimary)
            .navigationTitle("ARCMenu Showcase")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: .arcSpacingLarge) {
            Image(systemName: "menucard.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [selectedStyle.accentColor, selectedStyle.accentColor.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.bounce, value: selectedStyle)

            Text("ARCMenu Showcase")
                .font(.arcFontTitleLarge)
                .fontWeight(.bold)

            Text("Explore all menu configurations and styles")
                .font(.arcFontBodyMedium)
                .foregroundStyle(Color.arcTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, .arcSpacingXLarge)
        .padding(.horizontal, .arcSpacingXLarge)
    }

    // MARK: - Live Preview Card

    private var livePreviewCard: some View {
        VStack(spacing: .arcSpacingLarge) {
            HStack {
                VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                    Text("Live Preview")
                        .font(.arcFontTitleSmall)
                        .fontWeight(.semibold)

                    Text(selectedStyle.name)
                        .font(.arcFontBodyMedium)
                        .foregroundStyle(selectedStyle.accentColor)
                }

                Spacer()

                Image(systemName: "eye.fill")
                    .foregroundStyle(selectedStyle.accentColor)
            }

            // Mini preview
            LivePreviewMiniature(
                style: selectedStyle,
                variant: selectedVariant,
                showBadge: showBadge,
                badgeCount: badgeCount,
                showUserHeader: showUserHeader
            )
        }
        .padding(.arcSpacingXLarge)
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusLarge, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.95))
        }
        .padding(.horizontal, .arcSpacingXLarge)
    }

    // MARK: - Style Selector Section

    private var styleSelectorSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("Style Presets")
                .font(.arcFontTitleMedium)
                .fontWeight(.bold)
                .padding(.horizontal, .arcSpacingXLarge)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .arcSpacingMedium) {
                    ForEach(ShowcaseStyle.allCases) { style in
                        StyleCard(
                            style: style,
                            isSelected: selectedStyle == style
                        ) {
                            withAnimation(.arcAnimationSmooth) {
                                selectedStyle = style
                            }
                        }
                    }
                }
                .padding(.horizontal, .arcSpacingXLarge)
            }
        }
    }

    // MARK: - Variant Selector Section

    private var variantSelectorSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("Menu Variants")
                .font(.arcFontTitleMedium)
                .fontWeight(.bold)
                .padding(.horizontal, .arcSpacingXLarge)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .arcSpacingMedium) {
                    ForEach(ShowcaseVariant.allCases) { variant in
                        VariantCard(
                            variant: variant,
                            isSelected: selectedVariant == variant
                        ) {
                            withAnimation(.arcAnimationSmooth) {
                                selectedVariant = variant
                            }
                        }
                    }
                }
                .padding(.horizontal, .arcSpacingXLarge)
            }
        }
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("Customization Options")
                .font(.arcFontTitleMedium)
                .fontWeight(.bold)
                .padding(.horizontal, .arcSpacingXLarge)

            VStack(spacing: .arcSpacingMedium) {
                OptionToggle(
                    title: "Show Badge",
                    icon: "circle.badge.fill",
                    isOn: $showBadge,
                    accentColor: selectedStyle.accentColor
                )

                if showBadge {
                    OptionStepper(
                        title: "Badge Count",
                        icon: "number.circle.fill",
                        value: $badgeCount,
                        range: 0...99,
                        accentColor: selectedStyle.accentColor
                    )
                }

                OptionToggle(
                    title: "Show User Header",
                    icon: "person.crop.circle.fill",
                    isOn: $showUserHeader,
                    accentColor: selectedStyle.accentColor
                )
            }
            .padding(.horizontal, .arcSpacingXLarge)
        }
    }

    // MARK: - Code Example Section

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            HStack {
                Text("Code Example")
                    .font(.arcFontTitleMedium)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    // Copy to clipboard
                    let code = generateCodeExample()
                    UIPasteboard.general.string = code
                } label: {
                    Label("Copy", systemImage: "doc.on.doc.fill")
                        .font(.arcFontBodyMedium)
                        .foregroundStyle(selectedStyle.accentColor)
                }
            }
            .padding(.horizontal, .arcSpacingXLarge)

            CodeBlock(
                code: generateCodeExample(),
                accentColor: selectedStyle.accentColor
            )
            .padding(.horizontal, .arcSpacingXLarge)
        }
    }

    // MARK: - All Styles Gallery

    private var allStylesGallery: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("Complete Gallery")
                .font(.arcFontTitleMedium)
                .fontWeight(.bold)
                .padding(.horizontal, .arcSpacingXLarge)

            VStack(spacing: .arcSpacingLarge) {
                ForEach(ShowcaseStyle.allCases) { style in
                    GalleryCard(style: style)
                }
            }
            .padding(.horizontal, .arcSpacingXLarge)
        }
    }

    // MARK: - Helper Methods

    private func generateCodeExample() -> String {
        let userCode = showUserHeader ? """
        user: ARCMenuUser(
            name: "\(selectedStyle.sampleUser.name)",
            email: "\(selectedStyle.sampleUser.email ?? "")",
            avatarImage: .initials("\(selectedStyle.sampleUser.initials)")
        ),
        """ : "user: nil,"

        let badgeCode = showBadge ? """
        showsBadge: true,
        badgeCount: \(badgeCount)
        """ : ""

        return """
        let viewModel = ARCMenuViewModel.standard(
            \(userCode)
            configuration: .\(selectedStyle.configName),
            onSettings: { /* ... */ },
            onProfile: { /* ... */ },
            onPlan: { /* ... */ },
            onLogout: { /* ... */ }
        )

        NavigationStack {
            ContentView()
                .arcMenuButton(viewModel: viewModel\(badgeCode.isEmpty ? "" : ",\n        \(badgeCode)"))
                .arcMenu(viewModel: viewModel)
        }
        """
    }

    // MARK: - Initialization

    public init() {}
}

// MARK: - Showcase Style

enum ShowcaseStyle: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case fitness = "Fitness"
    case premium = "Premium"
    case dark = "Dark"
    case minimal = "Minimal"

    var id: String { rawValue }

    var name: String { rawValue }

    var configName: String {
        switch self {
        case .default: return "default"
        case .fitness: return "fitness"
        case .premium: return "premium"
        case .dark: return "dark"
        case .minimal: return "minimal"
        }
    }

    var accentColor: Color {
        switch self {
        case .default: return .blue
        case .fitness: return .green
        case .premium: return .orange
        case .dark: return .purple
        case .minimal: return .gray
        }
    }

    var configuration: ARCMenuConfiguration {
        switch self {
        case .default: return .default
        case .fitness: return .fitness
        case .premium: return .premium
        case .dark: return .dark
        case .minimal: return .minimal
        }
    }

    var description: String {
        switch self {
        case .default: return "Apple Music style"
        case .fitness: return "Health & Fitness apps"
        case .premium: return "Subscription services"
        case .dark: return "Dark theme apps"
        case .minimal: return "Subtle & clean"
        }
    }

    var icon: String {
        switch self {
        case .default: return "music.note"
        case .fitness: return "figure.run"
        case .premium: return "crown.fill"
        case .dark: return "moon.stars.fill"
        case .minimal: return "circle"
        }
    }

    var sampleUser: (name: String, email: String?, initials: String) {
        switch self {
        case .default: return ("Music Lover", "user@music.app", "ML")
        case .fitness: return ("Athlete Pro", "athlete@fit.app", "AP")
        case .premium: return ("Gold Member", "gold@premium.app", "GM")
        case .dark: return ("Night User", "night@dark.app", "NU")
        case .minimal: return ("Clean User", "user@minimal.app", "CU")
        }
    }
}

// MARK: - Showcase Variant

enum ShowcaseVariant: String, CaseIterable, Identifiable {
    case full = "Full"
    case compact = "Compact"
    case minimal = "Minimal"
    case custom = "Custom"

    var id: String { rawValue }

    var name: String { rawValue }

    var description: String {
        switch self {
        case .full: return "All menu items"
        case .compact: return "Essential items only"
        case .minimal: return "Just logout"
        case .custom: return "Custom actions"
        }
    }

    var icon: String {
        switch self {
        case .full: return "list.bullet"
        case .compact: return "list.dash"
        case .minimal: return "minus.circle"
        case .custom: return "slider.horizontal.3"
        }
    }
}

// MARK: - Style Card

private struct StyleCard: View {
    let style: ShowcaseStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: .arcSpacingMedium) {
                Image(systemName: style.icon)
                    .font(.arcFontTitleSmall)
                    .foregroundStyle(
                        isSelected ? style.accentColor : Color.secondary
                    )
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(style.accentColor.opacity(isSelected ? 0.2 : 0.05))
                    }

                VStack(spacing: .arcSpacingXSmall) {
                    Text(style.name)
                        .font(.arcFontBodyMedium)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(style.description)
                        .font(.arcFontLabelSmall)
                        .foregroundStyle(Color.arcTextSecondary)
                }
            }
            .frame(width: 120)
            .padding(.vertical, .arcSpacingLarge)
            .background {
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                    .fill(Color.arcBackgroundSecondary.opacity(0.95))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                                .strokeBorder(style.accentColor, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Variant Card

private struct VariantCard: View {
    let variant: ShowcaseVariant
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .arcSpacingMedium) {
                Image(systemName: variant.icon)
                    .font(.arcFontTitleSmall)
                    .foregroundStyle(isSelected ? Color.arcHighlight : Color.secondary)
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                    Text(variant.name)
                        .font(.arcFontBodyMedium)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(variant.description)
                        .font(.arcFontBodySmall)
                        .foregroundStyle(Color.arcTextSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.arcHighlight)
                }
            }
            .padding(.arcSpacingMedium)
            .background {
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                    .fill(Color.arcBackgroundSecondary.opacity(0.95))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                                .strokeBorder(Color.arcHighlight, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Option Toggle

private struct OptionToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let accentColor: Color

    var body: some View {
        HStack(spacing: .arcSpacingSmall) {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.arcFontBodyLarge)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(accentColor)
        }
        .padding(.arcSpacingLarge)
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.95))
        }
    }
}

// MARK: - Option Stepper

private struct OptionStepper: View {
    let title: String
    let icon: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let accentColor: Color

    var body: some View {
        HStack(spacing: .arcSpacingSmall) {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.arcFontBodyLarge)

            Spacer()

            HStack(spacing: .arcSpacingMedium) {
                Button {
                    if value > range.lowerBound {
                        value -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.arcFontTitleSmall)
                        .foregroundStyle(accentColor)
                }

                Text("\(value)")
                    .font(.arcFontBodyLarge)
                    .fontWeight(.semibold)
                    .frame(minWidth: 30)

                Button {
                    if value < range.upperBound {
                        value += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.arcFontTitleSmall)
                        .foregroundStyle(accentColor)
                }
            }
        }
        .padding(.arcSpacingLarge)
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.95))
        }
    }
}

// MARK: - Code Block

private struct CodeBlock: View {
    let code: String
    let accentColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(size: 13, design: .monospaced))
                .foregroundStyle(Color.arcTextPrimary)
                .padding(.arcSpacingLarge)
        }
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.95))
                .overlay {
                    RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                        .strokeBorder(accentColor.opacity(0.3), lineWidth: 1)
                }
        }
    }
}

// MARK: - Live Preview Miniature

private struct LivePreviewMiniature: View {
    let style: ShowcaseStyle
    let variant: ShowcaseVariant
    let showBadge: Bool
    let badgeCount: Int
    let showUserHeader: Bool

    @State private var viewModel: ARCMenuViewModel

    init(style: ShowcaseStyle, variant: ShowcaseVariant, showBadge: Bool, badgeCount: Int, showUserHeader: Bool) {
        self.style = style
        self.variant = variant
        self.showBadge = showBadge
        self.badgeCount = badgeCount
        self.showUserHeader = showUserHeader

        _viewModel = State(initialValue: ARCMenuViewModel.standard(
            user: showUserHeader ? ARCMenuUser(
                name: style.sampleUser.name,
                email: style.sampleUser.email,
                avatarImage: .initials(style.sampleUser.initials)
            ) : nil,
            configuration: style.configuration,
            onSettings: {},
            onProfile: {},
            onPlan: {},
            onContact: {},
            onAbout: {},
            onLogout: {}
        ))
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    style.accentColor.opacity(0.3),
                    style.accentColor.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusLarge, style: .continuous))

            // Menu button mock
            VStack {
                HStack {
                    Spacer()

                    ARCMenuButton(
                        viewModel: viewModel,
                        showsBadge: showBadge,
                        badgeCount: badgeCount
                    )
                    .padding(.arcSpacingLarge)
                }

                Spacer()

                Text("Tap button to preview →")
                    .font(.arcFontBodySmall)
                    .foregroundStyle(Color.arcTextSecondary)
                    .padding(.bottom, .arcSpacingXLarge)
            }
        }
        .arcMenu(viewModel: viewModel)
    }
}

// MARK: - Gallery Card

private struct GalleryCard: View {
    let style: ShowcaseStyle

    @State private var viewModel: ARCMenuViewModel

    init(style: ShowcaseStyle) {
        self.style = style

        _viewModel = State(initialValue: ARCMenuViewModel.standard(
            user: ARCMenuUser(
                name: style.sampleUser.name,
                email: style.sampleUser.email,
                avatarImage: .initials(style.sampleUser.initials)
            ),
            configuration: style.configuration,
            onSettings: {},
            onProfile: {},
            onLogout: {}
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundStyle(style.accentColor)

                VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                    Text(style.name)
                        .font(.arcFontTitleSmall)

                    Text(style.description)
                        .font(.arcFontBodySmall)
                        .foregroundStyle(Color.arcTextSecondary)
                }

                Spacer()

                Button {
                    viewModel.present()
                } label: {
                    Text("Preview")
                        .font(.arcFontBodyMedium)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, .arcSpacingLarge)
                        .padding(.vertical, .arcSpacingSmall)
                        .background {
                            Capsule()
                                .fill(style.accentColor)
                        }
                }
            }

            // Mini screenshot mockup
            ZStack {
                LinearGradient(
                    colors: [
                        style.accentColor.opacity(0.2),
                        style.accentColor.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous))

                Text("Style: \(style.name)")
                    .font(.arcFontBodySmall)
                    .foregroundStyle(Color.arcTextSecondary)
            }
        }
        .padding(.arcSpacingLarge)
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusLarge, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.95))
        }
        .arcMenu(viewModel: viewModel)
    }
}

// MARK: - Preview Provider

#Preview("ARCMenu Showcase") {
    ARCMenuShowcase()
}

#Preview("Showcase - Dark Mode") {
    ARCMenuShowcase()
        .preferredColorScheme(.dark)
}
