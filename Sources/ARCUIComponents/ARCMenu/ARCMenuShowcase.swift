//
//  ARCMenuShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

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
@available(iOS 17.0, macOS 14.0, *) public struct ARCMenuShowcase: View {
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
            #if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
            #else
            .background(Color(nsColor: .controlBackgroundColor))
            #endif
            .navigationTitle("ARCMenu Showcase")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "menucard.fill")
                .font(.system(size: 70))
                .foregroundStyle(LinearGradient(colors: [selectedStyle.accentColor,
                                                         selectedStyle.accentColor.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing))
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
            ShowcaseLivePreviewMiniature(style: selectedStyle,
                                         variant: selectedVariant,
                                         showBadge: showBadge,
                                         badgeCount: badgeCount,
                                         showUserHeader: showUserHeader)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
            #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
            #else
                .fill(Color(nsColor: .underPageBackgroundColor))
            #endif
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
                        ShowcaseStyleCard(style: style,
                                          isSelected: selectedStyle == style) {
                            arcWithAnimation(.arcSpring) {
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
                        ShowcaseVariantCard(variant: variant,
                                            isSelected: selectedVariant == variant) {
                            arcWithAnimation(.arcSpring) {
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
                ShowcaseOptionToggle(title: "Show Badge",
                                     icon: "circle.badge.fill",
                                     isOn: $showBadge,
                                     accentColor: selectedStyle.accentColor)

                if showBadge {
                    ShowcaseOptionStepper(title: "Badge Count",
                                          icon: "number.circle.fill",
                                          value: $badgeCount,
                                          range: 0 ... 99,
                                          accentColor: selectedStyle.accentColor)
                }

                ShowcaseOptionToggle(title: "Show User Header",
                                     icon: "person.crop.circle.fill",
                                     isOn: $showUserHeader,
                                     accentColor: selectedStyle.accentColor)
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
                    #if os(iOS)
                    UIPasteboard.general.string = code
                    #else
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(code, forType: .string)
                    #endif
                } label: {
                    Label("Copy", systemImage: "doc.on.doc.fill")
                        .font(.subheadline)
                        .foregroundStyle(selectedStyle.accentColor)
                }
            }
            .padding(.horizontal, 20)

            ShowcaseCodeBlock(code: generateCodeExample(),
                              accentColor: selectedStyle.accentColor)
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
                    ShowcaseGalleryCard(style: style)
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

        let badgeCode = showBadge
            ? """
                showsBadge: true,
                        badgeCount: \(badgeCount)
            """
            : ""

        return """
        @State private var showMenu = false
        @State private var menuViewModel = ARCMenuViewModel(
            \(userCode)
            menuItems: [
                .Common.settings { coordinator.showSettings() },
                .Common.profile { coordinator.showProfile() },
                .Common.logout { coordinator.logout() }
            ],
            configuration: .\(selectedStyle.configName)
        )

        var body: some View {
            NavigationStack {
                ContentView()
                    .arcMenuToolbarButton(
                        isPresented: $showMenu,
                        viewModel: menuViewModel\(badgeCode.isEmpty ? "" : ",\n                \(badgeCode)")
                    )
            }
            .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
        }
        """
    }

    // MARK: - Initialization

    public init() {}
}

// MARK: - Integration Guide

/*
 # ARCMenu Integration Guide (v1.9.1+)

 ## Basic Setup

 1. Import the package:
 ```swift
 import ARCUIComponents
 ```

 2. Create state for presentation and view model:
 ```swift
 @State private var showMenu = false
 @State private var menuViewModel = ARCMenuViewModel(
     user: ARCMenuUser(
         name: "Your Name",
         email: "you@email.com",
         avatarImage: .initials("YN")
     ),
     menuItems: [
         .Common.settings { print("Settings") },
         .Common.profile { print("Profile") },
         .Common.logout { print("Logout") }
     ]
 )
 ```

 3. Add menu to your view:
 ```swift
 var body: some View {
     NavigationStack {
         YourContentView()
             .arcMenuToolbarButton(
                 isPresented: $showMenu,
                 viewModel: menuViewModel
             )
     }
     .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
 }
 ```

 ## Architecture Agnostic

 ARCMenu works with any architecture. The only requirement is a `Binding<Bool>`:

 - Plain SwiftUI: `@State private var showMenu`
 - With Coordinator: Pass actions to menu items
 - With TCA: `$store.isMenuPresented`
 - With Environment: `@EnvironmentObject` for services

 ## Custom Menu Items
 ```swift
 let customItem = ARCMenuItem(
     title: "Custom Action",
     subtitle: "Tap to do something",
     icon: .system("star.fill", renderingMode: .multicolor),
     badge: "New",
     showsDisclosure: true,
     action: { /* your action */ }
 )
 ```

 ## Custom Configuration
 ```swift
 let config = ARCMenuConfiguration(
     accentColor: .purple,
     cornerRadius: 30,
     menuWidth: 320,
     hapticFeedback: .medium,
     sheetTitle: "Account"
 )

 let viewModel = ARCMenuViewModel(
     user: yourUser,
     menuItems: yourItems,
     configuration: config
 )
 ```

 ## User Avatar Options
 ```swift
 // SF Symbol
 .avatarImage(.systemImage("person.circle.fill"))

 // Image from assets
 .avatarImage(.imageName("avatar"))

 // Remote URL (use guard/if-let in production)
 .avatarImage(.url(URL(string: "https://example.com/avatar.jpg")))

 // Initials with gradient
 .avatarImage(.initials("AB"))
 ```

 ## Best Practices

 1. **External Binding**: Always use `@State var showMenu` for reliable
    sheet presentation (this is SwiftUI's standard pattern)

 2. **Haptic Feedback**: Keep haptic feedback enabled for better UX

 3. **Badge Count**: Use badges sparingly for important notifications only

 4. **Destructive Actions**: Place logout/delete at the bottom

 ## Tips

 - Uses native SwiftUI `.sheet()` presentation
 - Drag-to-dismiss is enabled by default
 - All animations follow Apple's spring animation curves
 - Supports both light and dark mode automatically
 - iOS 26+ will use Liquid Glass effect when available
 */

// MARK: - Preview Provider

#Preview("Showcase - Light") {
    ARCMenuShowcase()
        .preferredColorScheme(.light)
}

#Preview("Showcase - Dark Mode") {
    ARCMenuShowcase()
        .preferredColorScheme(.dark)
}
