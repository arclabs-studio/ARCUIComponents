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
            ZStack(alignment: .topTrailing) {
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
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing)
                                    .combined(with: .opacity),
                                removal: .move(edge: .trailing)
                                    .combined(with: .opacity)
                            )
                        )
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

    // MARK: - Menu Content

    @ViewBuilder
    private func menuContent(geometry: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: viewModel.configuration.sectionSpacing) {
                // User header
                if let user = viewModel.user {
                    ARCMenuUserHeader(
                        user: user,
                        configuration: viewModel.configuration,
                        onTap: nil
                    )
                }

                // Menu items
                VStack(spacing: 4) {
                    ForEach(viewModel.menuItems) { item in
                        ARCMenuItemRow(
                            item: item,
                            configuration: viewModel.configuration,
                            action: {
                                viewModel.executeAction(for: item)
                            }
                        )

                        // Divider between items (except last)
                        if item.id != viewModel.menuItems.last?.id {
                            Divider()
                                .padding(.leading, 64)
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(
                                    Color.white.opacity(0.1),
                                    lineWidth: 0.5
                                )
                        }
                }

                // App version (optional)
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("Version \(version)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 8)
                }
            }
            .padding(viewModel.configuration.contentInsets)
        }
        .frame(width: viewModel.configuration.menuWidth)
        .frame(maxHeight: geometry.size.height)
        .liquidGlass(configuration: viewModel.configuration)
        .offset(
            x: viewModel.dragOffset,
            y: viewModel.configuration.topPadding
        )
        .gesture(
            viewModel.configuration.allowsDragToDismiss
                ? dragGesture
                : nil
        )
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                viewModel.updateDragOffset(value.translation.width)
            }
            .onEnded { value in
                viewModel.endDrag(at: value.translation.width)
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

#Preview("ARCMenu - Full Example") {
    @Previewable @State var viewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            subtitle: "Premium Member",
            avatarImage: .initials("CR")
        ),
        configuration: .default,
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
