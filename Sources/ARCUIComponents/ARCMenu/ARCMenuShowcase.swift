// swiftlint:disable file_length

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
                .padding(.bottom, 40)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("ARCMenu Showcase")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 16) {
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
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("Explore all menu configurations and styles")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
    }

    // MARK: - Live Preview Card

    private var livePreviewCard: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Preview")
                        .font(.headline)

                    Text(selectedStyle.name)
                        .font(.subheadline)
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
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Style Selector Section

    private var styleSelectorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Presets")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ShowcaseStyle.allCases) { style in
                        StyleCard(
                            style: style,
                            isSelected: selectedStyle == style
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedStyle = style
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Variant Selector Section

    private var variantSelectorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Menu Variants")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ShowcaseVariant.allCases) { variant in
                        VariantCard(
                            variant: variant,
                            isSelected: selectedVariant == variant
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedVariant = variant
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customization Options")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
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
                        range: 0 ... 99,
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
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Code Example Section

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Code Example")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    // Copy to clipboard
                    let code = generateCodeExample()
                    UIPasteboard.general.string = code
                } label: {
                    Label("Copy", systemImage: "doc.on.doc.fill")
                        .font(.subheadline)
                        .foregroundStyle(selectedStyle.accentColor)
                }
            }
            .padding(.horizontal, 20)

            CodeBlock(
                code: generateCodeExample(),
                accentColor: selectedStyle.accentColor
            )
            .padding(.horizontal, 20)
        }
    }

    // MARK: - All Styles Gallery

    private var allStylesGallery: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Complete Gallery")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 20)

            VStack(spacing: 20) {
                ForEach(ShowcaseStyle.allCases) { style in
                    GalleryCard(style: style)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Helper Methods

    private func generateCodeExample() -> String {
        let userCode = showUserHeader
            ? """
            user: ARCMenuUser(
                name: "\(selectedStyle.sampleUser.name)",
                email: "\(selectedStyle.sampleUser.email ?? "")",
                avatarImage: .initials("\(selectedStyle.sampleUser.initials)")
            ),
            """
            : "user: nil,"

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
        case .default: "default"
        case .fitness: "fitness"
        case .premium: "premium"
        case .dark: "dark"
        case .minimal: "minimal"
        }
    }

    var accentColor: Color {
        switch self {
        case .default: .blue
        case .fitness: .green
        case .premium: .orange
        case .dark: .purple
        case .minimal: .gray
        }
    }

    var configuration: ARCMenuConfiguration {
        switch self {
        case .default: .default
        case .fitness: .fitness
        case .premium: .premium
        case .dark: .dark
        case .minimal: .minimal
        }
    }

    var description: String {
        switch self {
        case .default: "Apple Music style"
        case .fitness: "Health & Fitness apps"
        case .premium: "Subscription services"
        case .dark: "Dark theme apps"
        case .minimal: "Subtle & clean"
        }
    }

    var icon: String {
        switch self {
        case .default: "music.note"
        case .fitness: "figure.run"
        case .premium: "crown.fill"
        case .dark: "moon.stars.fill"
        case .minimal: "circle"
        }
    }

    // swiftlint:disable:next large_tuple
    var sampleUser: (name: String, email: String?, initials: String) {
        switch self {
        case .default: ("Music Lover", "user@music.app", "ML")
        case .fitness: ("Athlete Pro", "athlete@fit.app", "AP")
        case .premium: ("Gold Member", "gold@premium.app", "GM")
        case .dark: ("Night User", "night@dark.app", "NU")
        case .minimal: ("Clean User", "user@minimal.app", "CU")
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
        case .full: "All menu items"
        case .compact: "Essential items only"
        case .minimal: "Just logout"
        case .custom: "Custom actions"
        }
    }

    var icon: String {
        switch self {
        case .full: "list.bullet"
        case .compact: "list.dash"
        case .minimal: "minus.circle"
        case .custom: "slider.horizontal.3"
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
            VStack(spacing: 12) {
                Image(systemName: style.icon)
                    .font(.title)
                    .foregroundStyle(
                        isSelected ? style.accentColor : Color.secondary
                    )
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(style.accentColor.opacity(isSelected ? 0.2 : 0.05))
                    }

                VStack(spacing: 4) {
                    Text(style.name)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(style.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
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
            HStack(spacing: 12) {
                Image(systemName: variant.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.blue : Color.secondary)
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(variant.name)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(variant.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.blue, lineWidth: 2)
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
        HStack {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.body)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(accentColor)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
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
        HStack {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.body)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    if value > range.lowerBound {
                        value -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(accentColor)
                }

                Text("\(value)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(minWidth: 30)

                Button {
                    if value < range.upperBound {
                        value += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(accentColor)
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
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
                .padding(16)
        }
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
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
            user: showUserHeader
                ? ARCMenuUser(
                    name: style.sampleUser.name,
                    email: style.sampleUser.email,
                    avatarImage: .initials(style.sampleUser.initials)
                )
                : nil,
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
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // Menu button mock
            VStack {
                HStack {
                    Spacer()

                    ARCMenuButton(
                        viewModel: viewModel,
                        showsBadge: showBadge,
                        badgeCount: badgeCount
                    )
                    .padding(16)
                }

                Spacer()

                Text("Tap button to preview →")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundStyle(style.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text(style.name)
                        .font(.headline)

                    Text(style.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    viewModel.present()
                } label: {
                    Text("Preview")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
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
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text("Style: \(style.name)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
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
