//
//  ARCBottomSheetHandle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCBottomSheetHandle

/// Internal view representing the drag handle at the top of the sheet
///
/// The handle provides a visual indicator that the sheet can be dragged,
/// following Apple's Human Interface Guidelines for resizable sheets.
@available(iOS 17.0, macOS 14.0, *)
struct ARCBottomSheetHandle: View {
    // MARK: - Properties

    let configuration: ARCBottomSheetConfiguration
    let onTap: () -> Void

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        Capsule()
            .fill(configuration.handleColor)
            .frame(
                width: configuration.handleWidth,
                height: configuration.handleHeight
            )
            .scaleEffect(isPressed ? 1.1 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .contentShape(Rectangle().size(width: 60, height: 30))
            .onTapGesture {
                if configuration.tapHandleToCycle {
                    onTap()
                }
            }
            .onLongPressGesture(
                minimumDuration: 0,
                pressing: { pressing in
                    isPressed = pressing
                },
                perform: {}
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Sheet handle")
            .accessibilityHint(configuration.tapHandleToCycle ? "Tap to resize sheet" : "Drag to resize sheet")
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Handle Styles") {
    VStack(spacing: 40) {
        VStack(spacing: 8) {
            Text("Default")
                .font(.caption)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .overlay(alignment: .top) {
                    ARCBottomSheetHandle(
                        configuration: .default,
                        onTap: {}
                    )
                }
        }

        VStack(spacing: 8) {
            Text("Drawer")
                .font(.caption)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .frame(height: 100)
                .overlay(alignment: .top) {
                    ARCBottomSheetHandle(
                        configuration: .drawer,
                        onTap: {}
                    )
                }
        }

        VStack(spacing: 8) {
            Text("Glass")
                .font(.caption)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .overlay(alignment: .top) {
                    ARCBottomSheetHandle(
                        configuration: .glass,
                        onTap: {}
                    )
                }
        }
    }
    .padding()
    .background(
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
