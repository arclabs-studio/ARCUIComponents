//
//  ARCMenu.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// ARCMenu - Premium menu component following Apple's design language
///
/// A sophisticated, reusable menu component that implements Apple's modern
/// design patterns including:
/// - Liquid Glass effect (glassmorphism)
/// - Smooth spring animations
/// - Drag-to-dismiss gestures
/// - Haptic feedback
/// - Full customization support
///
/// Usage:
/// ```swift
/// struct ContentView: View {
///     @State private var viewModel = ARCMenuViewModel.standard(
///         user: ARCMenuUser(
///             name: "Carlos Ramirez",
///             email: "carlos@arclabs.studio",
///             avatarImage: .initials("CR")
///         ),
///         onSettings: { print("Settings") },
///         onProfile: { print("Profile") },
///         onLogout: { print("Logout") }
///     )
///
///     var body: some View {
///         YourContentView()
///             .arcMenu(viewModel: viewModel)
///     }
/// }
/// ```
public struct ARCMenu: View {
    // MARK: - Properties

    @Bindable private var viewModel: ARCMenuViewModel

    // MARK: - Initialization

    /// Creates a new ARCMenu
    /// - Parameter viewModel: View model containing menu state and configuration
    public init(viewModel: ARCMenuViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: viewModel.configuration.presentationStyle.contentAlignment) {
                // Backdrop
                if viewModel.isPresented {
                    Color.black
                        .opacity(viewModel.backdropOpacity * 0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if viewModel.configuration.dismissOnOutsideTap {
                                viewModel.dismiss()
                            }
                        }
                        .transition(.opacity)
                }

                // Menu content
                if viewModel.isPresented {
                    menuContent(geometry: geometry)
                        .transition(menuTransition)
                }
            }
            .animation(
                viewModel.isPresented
                    ? viewModel.configuration.presentationAnimation
                    : viewModel.configuration.dismissalAnimation,
                value: viewModel.isPresented
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.dragOffset)
        }
    }

    // MARK: - Transition

    private var menuTransition: AnyTransition {
        let edge = viewModel.configuration.presentationStyle.enteringEdge
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        )
    }

    // MARK: - Menu Content

    @ViewBuilder
    private func menuContent(geometry: GeometryProxy) -> some View {
        switch viewModel.configuration.presentationStyle {
        case .bottomSheet:
            bottomSheetContent(geometry: geometry)
        case .trailingPanel:
            trailingPanelContent(geometry: geometry)
        }
    }

    @ViewBuilder
    private func bottomSheetContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Grabber
            if viewModel.configuration.showsGrabber {
                grabberView
            }

            // Header with title and close button
            if viewModel.configuration.showsCloseButton || viewModel.configuration.sheetTitle != nil {
                sheetHeaderView
            }

            // Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: viewModel.configuration.sectionSpacing) {
                    userHeaderSection
                    menuItemsSection
                    versionSection
                }
                .padding(viewModel.configuration.contentInsets)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: geometry.size.height * 0.85)
        .liquidGlass(configuration: viewModel.configuration, isInteractive: false)
        .offset(y: max(0, viewModel.dragOffset))
        .gesture(viewModel.configuration.allowsDragToDismiss ? bottomSheetDragGesture : nil)
    }

    @ViewBuilder
    private func trailingPanelContent(geometry: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: viewModel.configuration.sectionSpacing) {
                userHeaderSection
                menuItemsSection
                versionSection
            }
            .padding(viewModel.configuration.contentInsets)
        }
        .frame(width: viewModel.configuration.menuWidth)
        .frame(maxHeight: geometry.size.height)
        .liquidGlass(configuration: viewModel.configuration, isInteractive: false)
        .offset(x: max(0, viewModel.dragOffset), y: viewModel.configuration.topPadding)
        .gesture(viewModel.configuration.allowsDragToDismiss ? trailingPanelDragGesture : nil)
    }

    // MARK: - Sheet Header Components

    @ViewBuilder
    private var grabberView: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.secondary.opacity(0.4))
            .frame(width: 36, height: 5)
            .padding(.top, .arcSpacingSmall)
            .padding(.bottom, .arcSpacingXSmall)
    }

    @ViewBuilder
    private var sheetHeaderView: some View {
        HStack {
            // Close button (leading position like Apple Music)
            if viewModel.configuration.showsCloseButton {
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial, in: Circle())
                }
            } else {
                Spacer().frame(width: 30)
            }

            Spacer()

            // Title
            if let title = viewModel.configuration.sheetTitle {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Spacer()

            // Placeholder for symmetry
            Spacer().frame(width: 30)
        }
        .padding(.horizontal, .arcSpacingMedium)
        .padding(.vertical, .arcSpacingSmall)
    }

    @ViewBuilder
    private var userHeaderSection: some View {
        if let user = viewModel.user {
            ARCMenuUserHeader(user: user, configuration: viewModel.configuration, onTap: nil)
        }
    }

    @ViewBuilder
    private var menuItemsSection: some View {
        VStack(spacing: .arcSpacingXSmall) {
            ForEach(viewModel.menuItems) { item in
                ARCMenuItemRow(
                    item: item,
                    configuration: viewModel.configuration,
                    action: { viewModel.executeAction(for: item) }
                )
                if item.id != viewModel.menuItems.last?.id {
                    Divider().padding(.leading, 64)
                }
            }
        }
        .background { menuItemsBackground }
    }

    @ViewBuilder
    private var menuItemsBackground: some View {
        RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
            }
    }

    @ViewBuilder
    private var versionSection: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Text("Version \(version)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .padding(.top, .arcSpacingSmall)
        }
    }

    // MARK: - Gestures

    private var bottomSheetDragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                viewModel.updateDragOffset(value.translation.height, isVertical: true)
            }
            .onEnded { value in
                viewModel.endDrag(at: value.translation.height, isVertical: true)
            }
    }

    private var trailingPanelDragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                viewModel.updateDragOffset(value.translation.width, isVertical: false)
            }
            .onEnded { value in
                viewModel.endDrag(at: value.translation.width, isVertical: false)
            }
    }
}

// MARK: - View Extension

extension View {
    /// Adds an ARCMenu to a view
    /// - Parameter viewModel: View model containing menu state and configuration
    /// - Returns: View with menu overlay
    public func arcMenu(viewModel: ARCMenuViewModel) -> some View {
        overlay {
            ARCMenu(viewModel: viewModel)
        }
    }
}

// MARK: - Preview Provider

#Preview("ARCMenu - Bottom Sheet (Default)") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            subtitle: "Premium Member",
            avatarImage: .initials("CR")
        ),
        configuration: ARCMenuConfiguration(
            sheetTitle: "Cuenta"
        ),
        onSettings: { print("Settings tapped") },
        onProfile: { print("Profile tapped") },
        onPlan: { print("Plan tapped") },
        onContact: { print("Contact tapped") },
        onAbout: { print("About tapped") },
        onLogout: { print("Logout tapped") }
    )

    ZStack {
        // Sample app content
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            Text("ARCMenu Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Bottom Sheet Style (Apple Standard)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            Button("Toggle Menu") {
                viewModel.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    .arcMenu(viewModel: viewModel)
    .onAppear {
        viewModel.present()
    }
}

#Preview("ARCMenu - Trailing Panel") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Jane Cooper",
            email: "jane@example.app",
            avatarImage: .initials("JC")
        ),
        configuration: .trailingPanel,
        onSettings: { print("Settings") },
        onProfile: { print("Profile") },
        onLogout: { print("Logout") }
    )

    ZStack {
        LinearGradient(
            colors: [.indigo, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            Text("Trailing Panel Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Drawer Style Presentation")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            Button("Toggle Menu") {
                viewModel.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    .arcMenu(viewModel: viewModel)
    .onAppear {
        viewModel.present()
    }
}

#Preview("ARCMenu - Fitness Style") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Jane Cooper",
            email: "jane@fitness.app",
            avatarImage: .initials("JC")
        ),
        configuration: .fitness,
        onSettings: { print("Settings") },
        onProfile: { print("Profile") },
        onLogout: { print("Logout") }
    )

    ZStack {
        Color.green.opacity(0.2).ignoresSafeArea()

        Text("Fitness App")
            .font(.largeTitle)
            .fontWeight(.black)
    }
    .arcMenu(viewModel: viewModel)
    .onAppear {
        viewModel.present()
    }
}

#Preview("ARCMenu - Premium Style") {
    @Previewable @State var viewModel = ARCMenuViewModel(
        user: ARCMenuUser(
            name: "Alex Morgan",
            subtitle: "Gold Member",
            avatarImage: .systemImage("crown.fill")
        ),
        menuItems: [
            .Common.profile(action: {}),
            .Common.plan(badge: "Pro", action: {}),
            .Common.notifications(badge: "5", action: {}),
            .Common.settings(action: {}),
            .Common.help(action: {}),
            .Common.logout(action: {})
        ],
        configuration: .premium
    )

    ZStack {
        LinearGradient(
            colors: [.orange, .red],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Text("Premium App")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
    }
    .arcMenu(viewModel: viewModel)
    .onAppear {
        viewModel.present()
    }
}

#Preview("ARCMenu - Dark Style") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Dark Mode User",
            email: "user@dark.app",
            avatarImage: .initials("DM")
        ),
        configuration: .dark,
        onSettings: {},
        onProfile: {},
        onLogout: {}
    )

    ZStack {
        Color.black.ignoresSafeArea()

        VStack {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 100))
                .foregroundStyle(.purple)

            Text("Dark Theme")
                .font(.title)
                .foregroundStyle(.white)
        }
    }
    .arcMenu(viewModel: viewModel)
    .preferredColorScheme(.dark)
    .onAppear {
        viewModel.present()
    }
}
