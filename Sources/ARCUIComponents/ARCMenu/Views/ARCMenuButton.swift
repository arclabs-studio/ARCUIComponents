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
///
/// ## Usage with External Binding (Recommended)
///
/// ```swift
/// struct ContentView: View {
///     @State private var showMenu = false
///     @State private var menuViewModel = ARCMenuViewModel(...)
///
///     var body: some View {
///         NavigationStack {
///             ContentView()
///                 .toolbar {
///                     ToolbarItem(placement: .topBarTrailing) {
///                         ARCMenuButton(
///                             isPresented: $showMenu,
///                             viewModel: menuViewModel
///                         )
///                     }
///                 }
///         }
///         .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
///     }
/// }
/// ```
public struct ARCMenuButton: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    @Bindable private var viewModel: ARCMenuViewModel
    private let showsBadge: Bool
    private let badgeCount: Int

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a menu trigger button with external presentation binding
    ///
    /// This is the recommended initializer that follows SwiftUI's declarative
    /// pattern for sheet presentation. The `isPresented` binding should be
    /// the same one passed to `.arcMenu(isPresented:viewModel:)`.
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control menu presentation
    ///   - viewModel: Menu view model containing user and configuration
    ///   - showsBadge: Whether to show a notification badge
    ///   - badgeCount: Number to display in badge (0 hides badge)
    public init(
        isPresented: Binding<Bool>,
        viewModel: ARCMenuViewModel,
        showsBadge: Bool = false,
        badgeCount: Int = 0
    ) {
        _isPresented = isPresented
        self.viewModel = viewModel
        self.showsBadge = showsBadge
        self.badgeCount = badgeCount
    }

    /// Creates a menu trigger button using ViewModel's internal state
    ///
    /// - Note: Deprecated. Use `init(isPresented:viewModel:showsBadge:badgeCount:)` instead.
    @available(*, deprecated, message: "Use init(isPresented:viewModel:) with external @State binding")
    public init(
        viewModel: ARCMenuViewModel,
        showsBadge: Bool = false,
        badgeCount: Int = 0
    ) {
        // Create a binding that reads/writes to the ViewModel's deprecated isPresented
        _isPresented = Binding(
            get: { viewModel.isPresented },
            set: { newValue in
                if newValue {
                    viewModel.present()
                } else {
                    viewModel.dismiss()
                }
            }
        )
        self.viewModel = viewModel
        self.showsBadge = showsBadge
        self.badgeCount = badgeCount
    }

    // MARK: - Body

    public var body: some View {
        Button {
            viewModel.configuration.hapticFeedback.perform()
            isPresented = true
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
                    .rotationEffect(.degrees(isPresented ? 90 : 0))
                    .arcAnimation(.arcBouncy, value: isPresented)
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
    /// Adds an ARCMenu button to the toolbar with external presentation binding
    ///
    /// Use this modifier together with `.arcMenu(isPresented:viewModel:)` for
    /// a complete menu integration.
    ///
    /// ```swift
    /// NavigationStack {
    ///     ContentView()
    ///         .arcMenuToolbarButton(
    ///             isPresented: $showMenu,
    ///             viewModel: menuViewModel
    ///         )
    /// }
    /// .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control menu presentation
    ///   - viewModel: Menu view model
    ///   - showsBadge: Whether to show badge
    ///   - badgeCount: Badge count
    /// - Returns: View with menu button in toolbar
    public func arcMenuToolbarButton(
        isPresented: Binding<Bool>,
        viewModel: ARCMenuViewModel,
        showsBadge: Bool = false,
        badgeCount: Int = 0
    ) -> some View {
        toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                ARCMenuButton(
                    isPresented: isPresented,
                    viewModel: viewModel,
                    showsBadge: showsBadge,
                    badgeCount: badgeCount
                )
            }
            #else
            ToolbarItem(placement: .automatic) {
                ARCMenuButton(
                    isPresented: isPresented,
                    viewModel: viewModel,
                    showsBadge: showsBadge,
                    badgeCount: badgeCount
                )
            }
            #endif
        }
    }

    /// Adds an ARCMenu button to the toolbar using ViewModel's internal state
    ///
    /// - Note: Deprecated. Use `arcMenuToolbarButton(isPresented:viewModel:)` instead.
    @available(*, deprecated, message: "Use arcMenuToolbarButton(isPresented:viewModel:) with external @State binding")
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

#Preview("Menu Button - With Binding") {
    @Previewable @State var showMenu = false
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@example.com",
            avatarImage: .initials("CR")
        ),
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

                Text("Menu is \(showMenu ? "open" : "closed")")
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .navigationTitle("ARCMenu Demo")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .arcMenuToolbarButton(
                isPresented: $showMenu,
                viewModel: viewModel
            )
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}

#Preview("Menu Button - With Avatar") {
    @Previewable @State var showMenu = false
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
        .arcMenuToolbarButton(
            isPresented: $showMenu,
            viewModel: viewModel
        )
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}

#Preview("Menu Button - With Badge") {
    @Previewable @State var showMenu = false
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
        .arcMenuToolbarButton(
            isPresented: $showMenu,
            viewModel: viewModel,
            showsBadge: true,
            badgeCount: 5
        )
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}

#Preview("Menu Button - Interactive") {
    @Previewable @State var showMenu = false
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Interactive Demo",
            email: "demo@arclabs.studio",
            avatarImage: .initials("ID")
        ),
        menuItems: [
            .Common.profile { print("Profile") },
            .Common.settings { print("Settings") },
            .Common.feedback { print("Feedback") },
            .Common.logout { print("Logout") }
        ],
        configuration: .default
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
                    .symbolEffect(.bounce, value: showMenu)
            }
        }
        .navigationTitle("Interactive Demo")
        .arcMenuToolbarButton(
            isPresented: $showMenu,
            viewModel: viewModel,
            showsBadge: true,
            badgeCount: 3
        )
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
    .preferredColorScheme(.dark)
}
