//
//  ARCMenu.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCMenu

/// ARCMenu - Native menu component following Apple's design language
///
/// A menu component that uses native SwiftUI sheet APIs for an Apple-native experience.
/// Supports iOS 26+ Liquid Glass effect when available, falling back to Material on earlier versions.
///
/// ## Features
/// - Native `.sheet()` presentation with `PresentationDetent` support
/// - Material background (ultraThinMaterial) for glass effect
/// - iOS 26+ Liquid Glass support via `@available`
/// - Drag indicator and X close button
/// - Haptic feedback
/// - Optional trailing panel mode for iPad/Mac
///
/// ## Usage
///
/// Use an external `@State` for presentation control. This follows SwiftUI's
/// declarative pattern and works with any architecture.
///
/// ```swift
/// struct ContentView: View {
///     @State private var showMenu = false
///     @State private var menuViewModel = ARCMenuViewModel(
///         user: ARCMenuUser(name: "John", avatarImage: .initials("JD")),
///         menuItems: [
///             .Common.settings { print("Settings") },
///             .Common.profile { print("Profile") },
///             .Common.logout { print("Logout") }
///         ]
///     )
///
///     var body: some View {
///         NavigationStack {
///             Text("My App")
///                 .arcMenuToolbarButton(
///                     isPresented: $showMenu,
///                     viewModel: menuViewModel
///                 )
///         }
///         .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
///     }
/// }
/// ```
///
/// ## Architecture Agnostic
///
/// ARCMenu works with any architecture (plain SwiftUI, MVVM, TCA, etc.).
/// The only requirement is a `Binding<Bool>` for presentation control.
public struct ARCMenu: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    @Bindable private var viewModel: ARCMenuViewModel

    // MARK: - Initialization

    /// Creates a new ARCMenu
    /// - Parameters:
    ///   - isPresented: Binding to control sheet presentation
    ///   - viewModel: View model containing menu state and configuration
    public init(isPresented: Binding<Bool>, viewModel: ARCMenuViewModel) {
        _isPresented = isPresented
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        switch viewModel.configuration.presentationStyle {
        case .bottomSheet:
            EmptyView() // Sheet is presented via modifier
        case .trailingPanel:
            trailingPanelOverlay
        }
    }

    // MARK: - Trailing Panel (Custom Implementation)

    private var trailingPanelOverlay: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                // Backdrop (Button for VoiceOver accessibility)
                if isPresented {
                    Button {
                        dismissWithHaptic()
                    } label: {
                        Color.black
                            .opacity(0.4)
                            .ignoresSafeArea()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(String(localized: "Close menu"))
                    .accessibilityHint(String(localized: "Double tap to close the menu"))
                    .transition(.opacity)
                }

                // Panel content
                if isPresented {
                    trailingPanelContent(geometry: geometry)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.arcGentle, value: isPresented)
        }
    }

    private func trailingPanelContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Header with close button
            if viewModel.configuration.showsCloseButton || viewModel.configuration.sheetTitle != nil {
                panelHeader
            }

            // Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                menuContentStack
            }
        }
        .frame(width: viewModel.configuration.menuWidth)
        .frame(maxHeight: geometry.size.height)
        .background {
            RoundedRectangle(cornerRadius: viewModel.configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, x: -5, y: 0)
        .gesture(panelDragGesture)
        .offset(x: viewModel.dragOffset)
    }

    private var panelDragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                if value.translation.width > 0 {
                    viewModel.dragOffset = value.translation.width
                }
            }
            .onEnded { value in
                if value.translation.width > 100 {
                    dismissWithHaptic()
                } else {
                    withAnimation(.arcSpring) {
                        viewModel.dragOffset = 0
                    }
                }
            }
    }

    // MARK: - Shared Content

    @ViewBuilder private var menuContentStack: some View {
        switch viewModel.configuration.layoutStyle {
        case .flat:
            flatContentStack
        case .grouped:
            groupedContentStack
        }
    }

    // MARK: - Flat Layout (Trailing Panel)

    private var flatContentStack: some View {
        VStack(spacing: viewModel.configuration.sectionSpacing) {
            flatUserHeaderSection
            flatMenuItemsSection
            flatVersionSection
        }
        .padding(viewModel.configuration.contentInsets)
    }

    @ViewBuilder private var flatUserHeaderSection: some View {
        if let user = viewModel.user {
            ARCMenuUserHeader(user: user, configuration: viewModel.configuration, onTap: nil)
        }
    }

    private var flatMenuItemsSection: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.menuItems) { item in
                ARCMenuItemRow(item: item,
                               configuration: viewModel.configuration,
                               action: {
                                   dismissWithHaptic()
                                   // Execute action after dismiss animation
                                   Task {
                                       try? await Task.sleep(for: .milliseconds(300))
                                       item.action()
                                   }
                               })
                if item.id != viewModel.menuItems.last?.id {
                    Divider()
                        .padding(.leading, 56)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder private var flatVersionSection: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Text("Version \(version)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .padding(.top, .arcSpacingSmall)
        }
    }

    // MARK: - Grouped Layout (Trailing Panel)

    @ViewBuilder private var groupedContentStack: some View {
        Form {
            if let user = viewModel.user {
                Section {
                    ARCMenuUserHeader(user: user, configuration: viewModel.configuration, onTap: nil)
                }
            }

            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.items) { item in
                        ARCMenuItemRow(item: item,
                                       configuration: viewModel.configuration,
                                       context: .form,
                                       action: {
                                           dismissWithHaptic()
                                           Task {
                                               try? await Task.sleep(for: .milliseconds(300))
                                               item.action()
                                           }
                                       })
                    }
                } header: {
                    if let title = section.title {
                        Text(title)
                    }
                } footer: {
                    if let footer = section.footer {
                        Text(footer)
                    }
                }
            }
        }
        #if os(iOS)
        .formStyle(.grouped)
        #endif
        .scrollContentBackground(.hidden)
    }

    // MARK: - Panel Header

    private var panelHeader: some View {
        HStack {
            if let title = viewModel.configuration.sheetTitle {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Spacer()

            if viewModel.configuration.showsCloseButton {
                closeButton
            }
        }
        .padding(.horizontal, .arcSpacingLarge)
        .padding(.vertical, .arcSpacingMedium)
    }

    private var closeButton: some View {
        Button {
            dismissWithHaptic()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 30, height: 30)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private func dismissWithHaptic() {
        viewModel.configuration.hapticFeedback.perform()
        isPresented = false
        viewModel.dragOffset = 0
    }
}

// MARK: - View Extension

extension View {
    /// Adds an ARCMenu to a view using native sheet presentation
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control menu visibility
    ///   - viewModel: View model containing menu data and configuration
    /// - Returns: View with menu sheet attached
    public func arcMenu(isPresented: Binding<Bool>, viewModel: ARCMenuViewModel) -> some View {
        modifier(ARCMenuModifier(isPresented: isPresented, viewModel: viewModel))
    }

    /// Adds an ARCMenu to a view using the view model's internal presentation state
    ///
    /// - Note: Deprecated. Use `arcMenu(isPresented:viewModel:)` with external `@State` binding.
    /// - Parameter viewModel: View model containing menu state and configuration
    /// - Returns: View with menu sheet attached
    @available(*, deprecated, message: "Use arcMenu(isPresented:viewModel:) with external @State binding")
    public func arcMenu(viewModel: ARCMenuViewModel) -> some View {
        modifier(ARCMenuLegacyModifier(viewModel: viewModel))
    }
}

// MARK: - Legacy Modifier (Backward Compatibility)

/// View modifier that uses ViewModel's internal isPresented state
///
/// - Note: Deprecated. Exists only for backward compatibility with v1.8.x code.
struct ARCMenuLegacyModifier: ViewModifier {
    @Bindable var viewModel: ARCMenuViewModel

    func body(content: Content) -> some View {
        let binding = Binding<Bool>(get: { viewModel.isPresented },
                                    set: { newValue in
                                        if newValue {
                                            viewModel.present()
                                        } else {
                                            viewModel.dismiss()
                                        }
                                    })

        switch viewModel.configuration.presentationStyle {
        case .bottomSheet:
            content
                .sheet(isPresented: binding) {
                    ARCMenuSheetContent(isPresented: binding, viewModel: viewModel)
                }
        case .trailingPanel:
            content
                .overlay {
                    ARCMenu(isPresented: binding, viewModel: viewModel)
                }
        }
    }
}

// MARK: - Menu Modifier

/// View modifier that handles both native sheet and custom trailing panel
struct ARCMenuModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Bindable var viewModel: ARCMenuViewModel

    func body(content: Content) -> some View {
        switch viewModel.configuration.presentationStyle {
        case .bottomSheet:
            content
                .sheet(isPresented: $isPresented) {
                    ARCMenuSheetContent(isPresented: $isPresented, viewModel: viewModel)
                }
        case .trailingPanel:
            content
                .overlay {
                    ARCMenu(isPresented: $isPresented, viewModel: viewModel)
                }
        }
    }
}
