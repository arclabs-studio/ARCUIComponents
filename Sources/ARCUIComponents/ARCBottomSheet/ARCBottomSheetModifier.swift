//
//  ARCBottomSheetModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCBottomSheetModifier

/// View modifier for presenting a bottom sheet as an overlay
///
/// This modifier provides a convenient way to present a bottom sheet over
/// existing content, with optional background dimming and dismissal callbacks.
@available(iOS 17.0, macOS 14.0, *)
struct ARCBottomSheetModifier<SheetContent: View>: ViewModifier {
    // MARK: - Properties

    @Binding var isPresented: Bool
    let detents: Set<ARCBottomSheetDetent>
    @Binding var selectedDetent: ARCBottomSheetDetent
    let configuration: ARCBottomSheetConfiguration
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    sheetOverlay
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(
                reduceMotion ? .none : configuration.animation,
                value: isPresented
            )
    }

    // MARK: - Sheet Overlay

    @ViewBuilder private var sheetOverlay: some View {
        GeometryReader { _ in
            ZStack(alignment: .bottom) {
                if configuration.dimBackground {
                    dimmedBackground
                }

                ARCBottomSheet(
                    selectedDetent: $selectedDetent,
                    detents: detents,
                    configuration: configuration,
                    content: sheetContent
                )
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }

    // MARK: - Dimmed Background

    @ViewBuilder private var dimmedBackground: some View {
        Color.black
            .opacity(configuration.dimOpacity)
            .ignoresSafeArea()
            .onTapGesture {
                if configuration.tapBackgroundToDismiss, configuration.isDismissable {
                    dismiss()
                }
            }
            .accessibilityHidden(true)
    }

    // MARK: - Dismiss

    private func dismiss() {
        withAnimation(reduceMotion ? .none : configuration.animation) {
            isPresented = false
        }
        onDismiss?()
    }
}

// MARK: - ARCPersistentSheetModifier

/// View modifier for presenting a persistent (always visible) bottom sheet
///
/// Use this for sheets like Apple Maps that stay on screen and cannot be dismissed,
/// only resized between detents.
@available(iOS 17.0, macOS 14.0, *)
struct ARCPersistentSheetModifier<SheetContent: View>: ViewModifier {
    // MARK: - Properties

    @Binding var selectedDetent: ARCBottomSheetDetent
    let detents: Set<ARCBottomSheetDetent>
    let configuration: ARCBottomSheetConfiguration
    let sheetContent: () -> SheetContent

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                ARCBottomSheet(
                    selectedDetent: $selectedDetent,
                    detents: detents,
                    configuration: configuration,
                    content: sheetContent
                )
                .ignoresSafeArea(.container, edges: .bottom)
            }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
extension View {
    /// Presents a bottom sheet overlay when a binding to a Boolean value is true
    ///
    /// Use this modifier to present a dismissable bottom sheet that slides up from
    /// the bottom of the screen. The sheet can be dismissed by dragging, tapping
    /// the dimmed background, or programmatically setting `isPresented` to `false`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showSheet = false
    ///     @State private var detent: ARCBottomSheetDetent = .medium
    ///
    ///     var body: some View {
    ///         Button("Show Sheet") {
    ///             showSheet = true
    ///         }
    ///         .arcBottomSheet(
    ///             isPresented: $showSheet,
    ///             detents: [.medium, .large],
    ///             selectedDetent: $detent
    ///         ) {
    ///             SheetContent()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean that determines whether to present the sheet
    ///   - detents: The set of detents the sheet can snap to (default: [.medium, .large])
    ///   - selectedDetent: Binding to the currently selected detent
    ///   - configuration: Configuration options for appearance and behavior
    ///   - onDismiss: Closure called when the sheet is dismissed
    ///   - content: The content to display inside the sheet
    /// - Returns: A view with the bottom sheet modifier applied
    public func arcBottomSheet(
        isPresented: Binding<Bool>,
        detents: Set<ARCBottomSheetDetent> = [.medium, .large],
        selectedDetent: Binding<ARCBottomSheetDetent>,
        configuration: ARCBottomSheetConfiguration = .default,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(ARCBottomSheetModifier(
            isPresented: isPresented,
            detents: detents,
            selectedDetent: selectedDetent,
            configuration: configuration,
            onDismiss: onDismiss,
            sheetContent: content
        ))
    }

    /// Presents a persistent bottom sheet that cannot be dismissed
    ///
    /// Use this modifier for sheets that stay visible at all times, like the
    /// search drawer in Apple Maps. Users can resize the sheet between detents
    /// but cannot dismiss it.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct MapView: View {
    ///     @State private var detent: ARCBottomSheetDetent = .small
    ///
    ///     var body: some View {
    ///         Map()
    ///             .arcPersistentSheet(
    ///                 selectedDetent: $detent,
    ///                 detents: [.small, .medium, .large],
    ///                 configuration: .drawer
    ///             ) {
    ///                 SearchResultsList()
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - selectedDetent: Binding to the currently selected detent
    ///   - detents: The set of detents the sheet can snap to
    ///   - configuration: Configuration options for appearance and behavior (default: .persistent)
    ///   - content: The content to display inside the sheet
    /// - Returns: A view with the persistent sheet modifier applied
    public func arcPersistentSheet(
        selectedDetent: Binding<ARCBottomSheetDetent>,
        detents: Set<ARCBottomSheetDetent>,
        configuration: ARCBottomSheetConfiguration = .persistent,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(ARCPersistentSheetModifier(
            selectedDetent: selectedDetent,
            detents: detents,
            configuration: configuration,
            sheetContent: content
        ))
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Bottom Sheet Modifier") {
    struct PreviewWrapper: View {
        @State private var showSheet = false
        @State private var detent: ARCBottomSheetDetent = .medium

        var body: some View {
            VStack(spacing: 20) {
                Button("Show Sheet") {
                    showSheet = true
                }
                .buttonStyle(.borderedProminent)

                Text("Selected detent: \(detent.accessibilityDescription)")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .arcBottomSheet(
                isPresented: $showSheet,
                detents: [.small, .medium, .large],
                selectedDetent: $detent,
                configuration: .modal,
                onDismiss: { print("Sheet dismissed") },
                content: {
                    VStack(spacing: 16) {
                        Text("Modal Sheet").font(.headline)
                        Text("Tap outside or drag down to dismiss")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button {
                            showSheet = false
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            )
        }
    }

    return PreviewWrapper()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Persistent Sheet") {
    struct PreviewWrapper: View {
        @State private var detent: ARCBottomSheetDetent = .small

        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [.green.opacity(0.3), .blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Text("Map View")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Image(systemName: "map")
                        .font(.system(size: 100))
                        .foregroundStyle(.secondary.opacity(0.5))
                }
            }
            .arcPersistentSheet(
                selectedDetent: $detent,
                detents: [.small, .medium, .large],
                configuration: .drawer
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        Text("Search maps")
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))

                    if detent != .small {
                        Text("Recent Searches")
                            .font(.headline)

                        ForEach(["Coffee shops", "Restaurants", "Gas stations"], id: \.self) { item in
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text(item)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding()
            }
        }
    }

    return PreviewWrapper()
}
