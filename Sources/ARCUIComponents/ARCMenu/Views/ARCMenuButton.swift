//
//  ARCMenuButton.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Button to trigger ARCMenu
///
/// A sophisticated menu trigger button designed to be placed in the
/// top-right corner of the navigation bar or screen. Features:
/// - Smooth rotation animation when menu opens/closes
/// - Badge support for notifications
/// - User avatar or icon
/// - Press animation with haptic feedback
/// - Fully customizable appearance
public struct ARCMenuButton: View {
    // MARK: - Properties

    @Bindable private var viewModel: ARCMenuViewModel
    private let showsBadge: Bool
    private let badgeCount: Int

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a menu trigger button
    /// - Parameters:
    ///   - viewModel: Menu view model to control
    ///   - showsBadge: Whether to show a notification badge
    ///   - badgeCount: Number to display in badge (0 hides badge)
    public init(
        viewModel: ARCMenuViewModel,
        showsBadge: Bool = false,
        badgeCount: Int = 0
    ) {
        self.viewModel = viewModel
        self.showsBadge = showsBadge
        self.badgeCount = badgeCount
    }

    // MARK: - Body

    public var body: some View {
        Button {
            viewModel.toggle()
        } label: {
            ZStack(alignment: .topTrailing) {
                // Button content
                buttonContent
                    .frame(width: 40, height: 40)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Circle()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                    }
                    .shadow(
                        color: .arcShadowLight,
                        radius: .arcSpacingSmall,
                        x: 0,
                        y: .arcSpacingXSmall
                    )
                    .scaleEffect(isPressed ? 0.92 : 1.0)
                    .rotationEffect(.degrees(viewModel.isPresented ? 90 : 0))
                    .arcAnimation(.arcBouncy, value: viewModel.isPresented)
                    .arcAnimation(.arcBouncy, value: isPressed)

                // Badge
                if showsBadge, badgeCount > 0 {
                    badgeView
                }
            }
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }

    // MARK: - Button Content

    @ViewBuilder private var buttonContent: some View {
        if let user = viewModel.user {
            // Show user avatar
            user.avatarImage.avatarView(size: 32)
                .clipShape(Circle())
        } else {
            // Show menu icon
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(viewModel.configuration.accentColor)
        }
    }

    // MARK: - Badge View

    @ViewBuilder private var badgeView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.red, .red.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 20, height: 20)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                }

            if badgeCount <= 99 {
                Text("\(badgeCount)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            } else {
                Text("99+")
                    .font(.system(size: 8))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .offset(x: 4, y: -4)
        .shadow(color: .red.opacity(0.5), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Toolbar Integration

extension View {
    /// Adds an ARCMenu button to the toolbar
    /// - Parameters:
    ///   - viewModel: Menu view model
    ///   - showsBadge: Whether to show badge
    ///   - badgeCount: Badge count
    /// - Returns: View with menu button in toolbar
    public func arcMenuButton(
        viewModel: ARCMenuViewModel,
        showsBadge: Bool = false,
        badgeCount: Int = 0
    ) -> some View {
        toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                ARCMenuButton(
                    viewModel: viewModel,
                    showsBadge: showsBadge,
                    badgeCount: badgeCount
                )
            }
            #else
            ToolbarItem(placement: .automatic) {
                ARCMenuButton(
                    viewModel: viewModel,
                    showsBadge: showsBadge,
                    badgeCount: badgeCount
                )
            }
            #endif
        }
    }
}

// MARK: - Preview Provider

#Preview("Menu Button - Default") {
    @Previewable @State var viewModel = ARCMenuViewModel(
        configuration: .default
    )

    NavigationStack {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Text("App Content")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Button("Toggle Menu State") {
                    viewModel.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("ARCMenu Demo")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .arcMenuButton(viewModel: viewModel)
    }
}

#Preview("Menu Button - With Avatar") {
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            avatarImage: .initials("CR")
        ),
        configuration: ARCMenuConfiguration(accentColor: .green)
    )

    NavigationStack {
        ZStack {
            Color.green.opacity(0.2).ignoresSafeArea()

            Text("Fitness App")
                .font(.largeTitle)
                .fontWeight(.black)
        }
        .navigationTitle("Fitness")
        .arcMenuButton(viewModel: viewModel)
    }
}

#Preview("Menu Button - With Badge") {
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Jane Cooper",
            avatarImage: .initials("JC")
        ),
        configuration: ARCMenuConfiguration(accentColor: .orange)
    )

    NavigationStack {
        ZStack {
            LinearGradient(
                colors: [.orange, .red],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Premium App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("You have 5 notifications")
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .navigationTitle("Premium")
        .arcMenuButton(
            viewModel: viewModel,
            showsBadge: true,
            badgeCount: 5
        )
    }
}

#Preview("Menu Button - High Badge Count") {
    @Previewable @State var viewModel = ARCMenuViewModel(
        configuration: .default
    )

    NavigationStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
            .navigationTitle("Messages")
            .arcMenuButton(
                viewModel: viewModel,
                showsBadge: true,
                badgeCount: 142
            )
    }
}

#Preview("Menu Button - Interactive") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Interactive Demo",
            email: "demo@arclabs.studio",
            avatarImage: .initials("ID")
        ),
        onSettings: { print("Settings") },
        onProfile: { print("Profile") },
        onLogout: { print("Logout") }
    )

    NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Tap the button")
                    .font(.title)
                    .foregroundStyle(.white)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, value: viewModel.isPresented)
            }
        }
        .navigationTitle("Interactive Demo")
        .arcMenuButton(
            viewModel: viewModel,
            showsBadge: true,
            badgeCount: 3
        )
        .arcMenu(viewModel: viewModel)
    }
    .preferredColorScheme(.dark)
}
