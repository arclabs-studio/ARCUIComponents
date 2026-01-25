//
//  ARCBottomSheetShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCBottomSheetShowcase

/// Comprehensive showcase of ARCBottomSheet configurations and features
///
/// This view demonstrates all available configurations, detent options,
/// and interaction patterns for the bottom sheet component.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBottomSheetShowcase: View {
    // MARK: - State

    @State var selectedSection: ShowcaseSection = .configurations
    @State var showSheet = false
    @State var currentDetent: ARCBottomSheetDetent = .medium
    @State var selectedConfig: ConfigOption = .default

    // MARK: - Body

    public init() {}

    public var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 0) {
                sectionPicker

                TabView(selection: $selectedSection) {
                    configurationsTab
                        .tag(ShowcaseSection.configurations)

                    detentsTab
                        .tag(ShowcaseSection.detents)

                    interactiveTab
                        .tag(ShowcaseSection.interactive)
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
            }

            if showSheet {
                sheetOverlay
            }
        }
        .arcAnimation(.arcGentle, value: showSheet)
        .navigationTitle("ARCBottomSheet")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Background

    var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.arcBrandBurgundy.opacity(0.1),
                Color.purple.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // MARK: - Section Picker

    var sectionPicker: some View {
        Picker("Section", selection: $selectedSection) {
            Text("Configs").tag(ShowcaseSection.configurations)
            Text("Detents").tag(ShowcaseSection.detents)
            Text("Interactive").tag(ShowcaseSection.interactive)
        }
        .pickerStyle(.segmented)
        .padding()
    }

    // MARK: - Helpers

    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            Spacer()
        }
    }
}
