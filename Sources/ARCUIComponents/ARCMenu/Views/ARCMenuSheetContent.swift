//
//  ARCMenuSheetContent.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/25/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Sheet Content View

/// Internal view for sheet content with native presentation modifiers
struct ARCMenuSheetContent: View {
    @Binding var isPresented: Bool
    @Bindable var viewModel: ARCMenuViewModel

    var body: some View {
        sheetContent
            .presentationDetents(viewModel.configuration.detents,
                                 selection: .constant(viewModel.configuration.selectedDetent ?? .medium))
            .presentationDragIndicator(viewModel.configuration.showsGrabber ? .visible : .hidden)
            .presentationCornerRadius(32)
            .presentationBackground {
                materialBackground
            }
            .presentationBackgroundInteraction(viewModel.configuration.allowsBackgroundInteraction
                ? .enabled(upThrough: .medium)
                : .disabled)
                .presentationContentInteraction(viewModel.configuration.contentInteraction)
                .onAppear {
                    viewModel.configuration.hapticFeedback.perform()
                }
    }

    // MARK: - Content Branching

    @ViewBuilder private var sheetContent: some View {
        switch viewModel.configuration.layoutStyle {
        case .flat:
            flatSheetContent
        case .grouped:
            groupedSheetContent
        }
    }

    // MARK: - Flat Layout

    private var flatSheetContent: some View {
        VStack(spacing: 0) {
            sheetHeader

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: viewModel.configuration.sectionSpacing) {
                    flatUserHeaderSection
                    flatMenuItemsSection
                    flatVersionSection
                }
                .padding(viewModel.configuration.contentInsets)
            }
        }
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
                                   viewModel.configuration.hapticFeedback.perform()
                                   isPresented = false
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

    // MARK: - Grouped Layout

    private var groupedSheetContent: some View {
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
                                           viewModel.configuration.hapticFeedback.perform()
                                           isPresented = false
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

    // MARK: - Background

    @ViewBuilder private var materialBackground: some View {
        if #available(iOS 26.0, *) {
            Rectangle()
                .fill(.ultraThinMaterial)
        } else {
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }

    // MARK: - Header

    @ViewBuilder private var sheetHeader: some View {
        if viewModel.configuration.showsCloseButton || viewModel.configuration.sheetTitle != nil {
            HStack {
                if viewModel.configuration.showsCloseButton {
                    Button {
                        viewModel.configuration.hapticFeedback.perform()
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                            .frame(width: 30, height: 30)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                } else {
                    Spacer().frame(width: 30)
                }

                Spacer()

                if let title = viewModel.configuration.sheetTitle {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }

                Spacer()

                Spacer().frame(width: 30)
            }
            .padding(.horizontal, .arcSpacingMedium)
            .padding(.vertical, .arcSpacingSmall)
        }
    }
}
