//
//  ARCToastModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCToastModifier

/// View modifier for presenting a toast with binding control
@available(iOS 17.0, macOS 14.0, *)
struct ARCToastModifier: ViewModifier {
    // MARK: - Properties

    @Binding var isPresented: Bool
    let message: String
    let type: ARCToastType
    let action: ARCToastAction?
    let configuration: ARCToastConfiguration

    // MARK: - State

    @State private var isVisible = false

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(alignment: overlayAlignment) {
                if isVisible {
                    toastView
                        .transition(toastTransition)
                        .zIndex(1000)
                }
            }
            .onChange(of: isPresented) { _, newValue in
                handlePresentedChange(newValue)
            }
    }

    // MARK: - Toast View

    @ViewBuilder private var toastView: some View {
        ARCToast(
            message: message,
            type: type,
            action: action,
            configuration: configuration,
            onDismiss: {
                dismissToast()
            }
        )
        .padding(.horizontal, 16)
        .padding(configuration.position == .top ? .top : .bottom, 8)
        .onAppear {
            scheduleAutoDismissIfNeeded()
        }
    }

    // MARK: - Layout

    private var overlayAlignment: Alignment {
        configuration.position == .top ? .top : .bottom
    }

    // MARK: - Transitions

    private var toastTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }

        return .asymmetric(
            insertion: .move(edge: configuration.position == .top ? .top : .bottom)
                .combined(with: .opacity),
            removal: .opacity.combined(with: .scale(scale: 0.95))
        )
    }

    // MARK: - Presentation Logic

    private func handlePresentedChange(_ newValue: Bool) {
        if newValue {
            showToast()
        } else {
            hideToast()
        }
    }

    private func showToast() {
        #if os(iOS)
        if configuration.hapticFeedback {
            type.triggerHaptic()
        }
        #endif

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isVisible = true
        }
    }

    private func hideToast() {
        withAnimation(.easeOut(duration: 0.2)) {
            isVisible = false
        }
    }

    private func dismissToast() {
        isPresented = false
    }

    private func scheduleAutoDismissIfNeeded() {
        guard let duration = configuration.duration.seconds else { return }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(duration))

            guard isPresented else { return }

            dismissToast()
        }
    }
}

// MARK: - ARCToastContainerModifier

/// View modifier for presenting toasts from ARCToastManager
@available(iOS 17.0, macOS 14.0, *)
struct ARCToastContainerModifier: ViewModifier {
    // MARK: - Properties

    @State private var manager = ARCToastManager.shared

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                bottomToastContainer
            }
            .overlay(alignment: .top) {
                topToastContainer
            }
    }

    // MARK: - Toast Containers

    @ViewBuilder private var bottomToastContainer: some View {
        if let toast = manager.currentToast, toast.configuration.position == .bottom {
            toastView(for: toast)
                .transition(bottomTransition)
        }
    }

    @ViewBuilder private var topToastContainer: some View {
        if let toast = manager.currentToast, toast.configuration.position == .top {
            toastView(for: toast)
                .transition(topTransition)
        }
    }

    @ViewBuilder
    private func toastView(for toast: ToastItem) -> some View {
        ARCToast(
            message: toast.message,
            type: toast.type,
            action: toast.action,
            configuration: toast.configuration,
            onDismiss: {
                manager.dismiss()
            }
        )
        .padding(.horizontal, 16)
        .padding(toast.configuration.position == .top ? .top : .bottom, 8)
        .zIndex(1000)
        .id(toast.id)
    }

    // MARK: - Transitions

    private var bottomTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .opacity.combined(with: .scale(scale: 0.95))
        )
    }

    private var topTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .opacity.combined(with: .scale(scale: 0.95))
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
extension View {
    /// Presents a toast notification with binding control
    ///
    /// Use this modifier to show a toast that is controlled by a boolean binding.
    /// The toast will automatically dismiss after the configured duration.
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control toast visibility
    ///   - message: The message to display
    ///   - type: The toast type (default: .info)
    ///   - action: Optional action button
    ///   - configuration: Toast configuration (default: .default)
    /// - Returns: A view with toast presentation capability
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showToast = false
    ///
    ///     var body: some View {
    ///         Button("Save") {
    ///             // perform save
    ///             showToast = true
    ///         }
    ///         .arcToast(
    ///             isPresented: $showToast,
    ///             message: "Changes saved",
    ///             type: .success
    ///         )
    ///     }
    /// }
    /// ```
    public func arcToast(
        isPresented: Binding<Bool>,
        message: String,
        type: ARCToastType = .info,
        action: ARCToastAction? = nil,
        configuration: ARCToastConfiguration = .default
    ) -> some View {
        modifier(
            ARCToastModifier(
                isPresented: isPresented,
                message: message,
                type: type,
                action: action,
                configuration: configuration
            )
        )
    }

    /// Adds a toast container for ARCToastManager
    ///
    /// Add this modifier to your root view to enable toast presentation
    /// from anywhere in your app using `ARCToastManager.shared`.
    ///
    /// - Returns: A view with toast container overlay
    ///
    /// ## Example
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .arcToastContainer()
    ///         }
    ///     }
    /// }
    ///
    /// // Then from anywhere:
    /// ARCToastManager.shared.show("Message saved", type: .success)
    /// ```
    public func arcToastContainer() -> some View {
        modifier(ARCToastContainerModifier())
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Toast Modifier") {
    struct PreviewView: View {
        @State private var showSuccessToast = false
        @State private var showErrorToast = false

        var body: some View {
            VStack(spacing: 20) {
                Button("Show Success Toast") {
                    showSuccessToast = true
                }
                .buttonStyle(.borderedProminent)

                Button("Show Error Toast") {
                    showErrorToast = true
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .arcToast(
                isPresented: $showSuccessToast,
                message: "Changes saved successfully",
                type: .success
            )
            .arcToast(
                isPresented: $showErrorToast,
                message: "Failed to save changes",
                type: .error,
                configuration: .top
            )
        }
    }

    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Toast Container") {
    struct PreviewView: View {
        var body: some View {
            VStack(spacing: 20) {
                Button("Success") {
                    ARCToastManager.shared.showSuccess("Upload complete")
                }

                Button("Error") {
                    ARCToastManager.shared.showError("Network error", action: .retry {})
                }

                Button("Warning") {
                    ARCToastManager.shared.showWarning("Low storage")
                }

                Button("Info") {
                    ARCToastManager.shared.showInfo("New update available")
                }

                Button("Queue Multiple") {
                    ARCToastManager.shared.show("Step 1 complete", type: .success)
                    ARCToastManager.shared.show("Step 2 complete", type: .success)
                    ARCToastManager.shared.show("All done!", type: .success)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .arcToastContainer()
        }
    }

    return PreviewView()
}
