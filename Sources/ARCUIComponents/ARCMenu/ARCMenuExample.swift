//
//  ARCMenuExample.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Example implementation of ARCMenu
///
/// This file demonstrates how to integrate ARCMenu into your app
/// with various configuration options and use cases.
///
/// Copy and adapt these examples to your needs.
@available(iOS 17.0, macOS 14.0, *)
struct ARCMenuExample: View {
    // MARK: - View Model

    @State private var viewModel: ARCMenuViewModel

    // MARK: - Initialization

    init() {
        // Create a view model with user and standard menu items
        _viewModel = State(initialValue: ARCMenuViewModel.standard(
            user: ARCMenuUser(
                name: "Carlos Ramirez",
                email: "carlos@arclabs.studio",
                subtitle: "Premium Member",
                avatarImage: .initials("CR")
            ),
            configuration: .default,
            onSettings: {
                print("🎛️ Opening Settings...")
            },
            onProfile: {
                print("👤 Opening Profile...")
            },
            onPlan: {
                print("👑 Opening Plan...")
            },
            onContact: {
                print("📧 Opening Contact...")
            },
            onAbout: {
                print("ℹ️ Opening About...")
            },
            onLogout: {
                print("🚪 Logging out...")
            }
        ))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Your app content goes here
                contentView

                // Add menu overlay
            }
            .navigationTitle("ARCMenu Demo")
            .navigationBarTitleDisplayMode(.inline)
            .arcMenuButton(
                viewModel: viewModel,
                showsBadge: true,
                badgeCount: 3
            )
            .arcMenu(viewModel: viewModel)
        }
    }

    // MARK: - Content View

    private var contentView: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                // Hero Section
                VStack(spacing: .arcSpacingLarge) {
                    Image(systemName: "menucard.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.arcHighlight, .arcHighlight.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("ARCMenu")
                        .font(.arcFontTitleLarge)

                    Text("Premium menu component following Apple's HIG")
                        .font(.arcFontBodyLarge)
                        .foregroundStyle(Color.arcTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, CGFloat.arcSpacingXXLarge + CGFloat.arcSpacingSmall)
                }
                .padding(.top, CGFloat.arcSpacingXXLarge + CGFloat.arcSpacingLarge)

                // Features
                VStack(spacing: .arcSpacingLarge) {
                    FeatureCard(
                        icon: "sparkles",
                        title: "Liquid Glass Effect",
                        description: "Beautiful glassmorphism like Apple Music"
                    )

                    FeatureCard(
                        icon: "hand.tap.fill",
                        title: "Smooth Interactions",
                        description: "Spring animations and haptic feedback"
                    )

                    FeatureCard(
                        icon: "paintbrush.fill",
                        title: "Fully Customizable",
                        description: "Adapt colors and behavior to your app"
                    )

                    FeatureCard(
                        icon: "swift",
                        title: "Swift 6 Ready",
                        description: "Modern, safe, and performant code"
                    )
                }
                .padding(.horizontal, .arcSpacingXLarge)

                // Call to Action
                VStack(spacing: .arcSpacingMedium) {
                    Text("Try it out!")
                        .font(.arcFontTitleSmall)

                    Text("Tap the button in the top-right corner")
                        .font(.arcFontBodyMedium)
                        .foregroundStyle(Color.arcTextSecondary)
                }
                .padding(.top, .arcSpacingLarge)
            }
            .padding(.bottom, .arcSpacingXXLarge)
        }
        .background(Color.arcBackgroundPrimary)
    }
}

// MARK: - Feature Card

private struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: .arcSpacingLarge) {
            Image(systemName: icon)
                .font(.arcFontTitleSmall)
                .foregroundStyle(.arcHighlight)
                .frame(width: 44, height: 44)
                .background {
                    RoundedRectangle(cornerRadius: .arcCornerRadiusSmall, style: .continuous)
                        .fill(Color.arcHighlight.opacity(0.1))
                }

            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text(title)
                    .font(.arcFontBodyLarge)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.arcFontBodyMedium)
                    .foregroundStyle(Color.arcTextSecondary)
            }

            Spacer()
        }
        .padding(.arcSpacingLarge)
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                .fill(Color.arcBackgroundSecondary.opacity(0.9))
        }
    }
}

// MARK: - Custom Configuration Examples

extension ARCMenuExample {
    /// Example: Music app style
    static func musicAppStyle() -> ARCMenuViewModel {
        ARCMenuViewModel.standard(
            user: ARCMenuUser(
                name: "Music Lover",
                subtitle: "Apple Music",
                avatarImage: .systemImage("music.note")
            ),
            configuration: .default,
            onSettings: {},
            onProfile: {},
            onLogout: {}
        )
    }

    /// Example: Fitness app style
    static func fitnessAppStyle() -> ARCMenuViewModel {
        ARCMenuViewModel(
            user: ARCMenuUser(
                name: "Athlete",
                subtitle: "Pro Plan",
                avatarImage: .systemImage("figure.run")
            ),
            menuItems: [
                .Common.profile(action: {}),
                .Common.plan(badge: "Pro", action: {}),
                .Common.settings(action: {}),
                ARCMenuItem(
                    title: "Workouts",
                    icon: .system("dumbbell.fill", renderingMode: .hierarchical),
                    showsDisclosure: true,
                    action: {}
                ),
                ARCMenuItem(
                    title: "Achievements",
                    icon: .system("trophy.fill", renderingMode: .multicolor),
                    showsDisclosure: true,
                    action: {}
                ),
                .Common.logout(action: {})
            ],
            configuration: .fitness
        )
    }

    /// Example: Subscription app style
    static func subscriptionAppStyle() -> ARCMenuViewModel {
        ARCMenuViewModel(
            user: ARCMenuUser(
                name: "Premium User",
                subtitle: "Gold Member",
                avatarImage: .systemImage("crown.fill")
            ),
            menuItems: [
                .Common.profile(action: {}),
                .Common.plan(badge: "Gold", action: {}),
                ARCMenuItem(
                    title: "Billing",
                    subtitle: "Manage payments",
                    icon: .system("creditcard.fill", renderingMode: .hierarchical),
                    showsDisclosure: true,
                    action: {}
                ),
                .Common.settings(action: {}),
                .Common.help(action: {}),
                .Common.logout(action: {})
            ],
            configuration: .premium
        )
    }

    /// Example: Custom configuration
    static func customStyle() -> ARCMenuViewModel {
        let customConfig = ARCMenuConfiguration(
            accentColor: .indigo,
            backgroundStyle: .liquidGlass,
            cornerRadius: 28,
            shadow: .prominent,
            menuWidth: 340,
            sectionSpacing: 20,
            presentationAnimation: .spring(response: 0.6, dampingFraction: 0.75),
            dismissalAnimation: .spring(response: 0.4, dampingFraction: 0.85),
            hapticFeedback: .soft,
            allowsDragToDismiss: true,
            dismissOnOutsideTap: true
        )

        return ARCMenuViewModel.standard(
            user: ARCMenuUser(
                name: "Custom User",
                email: "user@custom.app",
                avatarImage: .initials("CU")
            ),
            configuration: customConfig,
            onSettings: {},
            onProfile: {},
            onLogout: {}
        )
    }
}

// MARK: - Integration Guide

/*
 # ARCMenu Integration Guide

 ## Basic Setup

 1. Import the package:
 ```swift
 import ARCUIComponents
 ```

 2. Create a view model (usually as a @State property):
 ```swift
 @State private var menuViewModel = ARCMenuViewModel.standard(
     user: ARCMenuUser(
         name: "Your Name",
         email: "you@email.com",
         avatarImage: .initials("YN")
     ),
     onSettings: { /* handle settings */ },
     onProfile: { /* handle profile */ },
     onLogout: { /* handle logout */ }
 )
 ```

 3. Add menu to your view:
 ```swift
 var body: some View {
     NavigationStack {
         YourContentView()
             .arcMenuButton(viewModel: menuViewModel)
             .arcMenu(viewModel: menuViewModel)
     }
 }
 ```

 ## Advanced Customization

 ### Custom Menu Items
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

 ### Custom Configuration
 ```swift
 let config = ARCMenuConfiguration(
     accentColor: .purple,
     backgroundStyle: .liquidGlass,
     cornerRadius: 30,
     shadow: .prominent,
     menuWidth: 320,
     hapticFeedback: .medium
 )

 let viewModel = ARCMenuViewModel(
     user: yourUser,
     menuItems: yourItems,
     configuration: config
 )
 ```

 ### User Avatar Options
 ```swift
 // SF Symbol
 .avatarImage(.systemImage("person.circle.fill"))

 // Image from assets
 .avatarImage(.imageName("avatar"))

 // Remote URL
 .avatarImage(.url(URL(string: "https://...")!))

 // Initials with gradient
 .avatarImage(.initials("AB"))
 ```

 ## Best Practices

 1. **Configuration Presets**: Use built-in presets (.default, .fitness, .premium, .dark)
    for consistent Apple-like styling

 2. **Haptic Feedback**: Keep haptic feedback enabled for better UX
    (can be customized via configuration)

 3. **Badge Count**: Use badges sparingly for important notifications only

 4. **Menu Width**: Default 320pt works well for most cases,
    adjust for iPad if needed

 5. **Destructive Actions**: Place logout/delete actions at the bottom
    and mark as destructive

 ## Tips

 - The menu automatically handles safe areas and notches
 - Drag-to-dismiss is enabled by default (can be disabled)
 - The backdrop automatically adjusts opacity during drag
 - All animations follow Apple's spring animation curves
 - The menu supports both light and dark mode automatically
 */

// MARK: - Preview Provider

#Preview("ARCMenu Example") {
    ARCMenuExample()
}

#Preview("Music App Style") {
    @Previewable @State var vm = ARCMenuExample.musicAppStyle()

    NavigationStack {
        Color.red.opacity(0.1)
            .ignoresSafeArea()
            .navigationTitle("Music")
            .arcMenuButton(viewModel: vm)
            .arcMenu(viewModel: vm)
    }
}

#Preview("Fitness App Style") {
    @Previewable @State var vm = ARCMenuExample.fitnessAppStyle()

    NavigationStack {
        Color.green.opacity(0.1)
            .ignoresSafeArea()
            .navigationTitle("Fitness")
            .arcMenuButton(viewModel: vm)
            .arcMenu(viewModel: vm)
    }
}

#Preview("Subscription App Style") {
    @Previewable @State var vm = ARCMenuExample.subscriptionAppStyle()

    NavigationStack {
        Color.orange.opacity(0.1)
            .ignoresSafeArea()
            .navigationTitle("Premium")
            .arcMenuButton(viewModel: vm)
            .arcMenu(viewModel: vm)
    }
}
