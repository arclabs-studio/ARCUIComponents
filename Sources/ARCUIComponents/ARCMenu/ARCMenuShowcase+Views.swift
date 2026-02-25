//
//  ARCMenuShowcase+Views.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Style Card

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseStyleCard: View {
    let style: ShowcaseStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: style.icon)
                    .font(.title)
                    .foregroundStyle(isSelected ? style.accentColor : Color.secondary)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(style.accentColor.opacity(isSelected ? 0.2 : 0.05))
                    }

                VStack(spacing: 4) {
                    Text(style.name)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(style.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                #if os(iOS)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                #else
                    .fill(Color(nsColor: .underPageBackgroundColor))
                #endif
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(style.accentColor, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Variant Card

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseVariantCard: View {
    let variant: ShowcaseVariant
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: variant.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.blue : Color.secondary)
                    .frame(width: 30, height: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(variant.name)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(variant.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                #if os(iOS)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                #else
                    .fill(Color(nsColor: .underPageBackgroundColor))
                #endif
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.blue, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Option Toggle

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseOptionToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let accentColor: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.body)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(accentColor)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
            #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
            #else
                .fill(Color(nsColor: .underPageBackgroundColor))
            #endif
        }
    }
}

// MARK: - Option Stepper

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseOptionStepper: View {
    let title: String
    let icon: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let accentColor: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(accentColor)
                .frame(width: 30)

            Text(title)
                .font(.body)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    if value > range.lowerBound {
                        value -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(accentColor)
                }

                Text("\(value)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(minWidth: 30)

                Button {
                    if value < range.upperBound {
                        value += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(accentColor)
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
            #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
            #else
                .fill(Color(nsColor: .underPageBackgroundColor))
            #endif
        }
    }
}

// MARK: - Code Block

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseCodeBlock: View {
    let code: String
    let accentColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(size: 13, design: .monospaced))
                .padding(16)
        }
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
            #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
            #else
                .fill(Color(nsColor: .underPageBackgroundColor))
            #endif
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(accentColor.opacity(0.3), lineWidth: 1)
                }
        }
    }
}

// MARK: - Live Preview Miniature

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseLivePreviewMiniature: View {
    let style: ShowcaseStyle
    let variant: ShowcaseVariant
    let showBadge: Bool
    let badgeCount: Int
    let showUserHeader: Bool

    @State private var showMenu = false
    @State private var viewModel: ARCMenuViewModel

    init(style: ShowcaseStyle, variant: ShowcaseVariant, showBadge: Bool, badgeCount: Int, showUserHeader: Bool) {
        self.style = style
        self.variant = variant
        self.showBadge = showBadge
        self.badgeCount = badgeCount
        self.showUserHeader = showUserHeader

        let user = showUserHeader
            ? ARCMenuUser(name: style.sampleUser.name,
                          email: style.sampleUser.email,
                          avatarImage: .initials(style.sampleUser.initials))
            : nil

        if style.isSectioned {
            _viewModel = State(initialValue: ARCMenuViewModel(user: user,
                                                              sections: style.sampleSections,
                                                              configuration: style.configuration))
        } else {
            _viewModel = State(initialValue: ARCMenuViewModel(user: user,
                                                              menuItems: [.Common.settings {},
                                                                          .Common.profile {},
                                                                          .Common.feedback {},
                                                                          .Common.logout {}],
                                                              configuration: style.configuration))
        }
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [style.accentColor.opacity(0.3),
                                    style.accentColor.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // Menu button mock
            VStack {
                HStack {
                    Spacer()

                    ARCMenuButton(isPresented: $showMenu,
                                  viewModel: viewModel,
                                  showsBadge: showBadge,
                                  badgeCount: badgeCount)
                        .padding(16)
                }

                Spacer()

                Text("Tap button to preview →")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
            }
        }
        .arcMenu(isPresented: $showMenu, viewModel: viewModel)
    }
}

// MARK: - Gallery Card

@available(iOS 17.0, macOS 14.0, *) struct ShowcaseGalleryCard: View {
    let style: ShowcaseStyle

    @State private var showMenu = false
    @State private var viewModel: ARCMenuViewModel

    init(style: ShowcaseStyle) {
        self.style = style

        let user = ARCMenuUser(name: style.sampleUser.name,
                               email: style.sampleUser.email,
                               avatarImage: .initials(style.sampleUser.initials))

        if style.isSectioned {
            _viewModel = State(initialValue: ARCMenuViewModel(user: user,
                                                              sections: style.sampleSections,
                                                              configuration: style.configuration))
        } else {
            _viewModel = State(initialValue: ARCMenuViewModel(user: user,
                                                              menuItems: [.Common.settings {},
                                                                          .Common.profile {},
                                                                          .Common.logout {}],
                                                              configuration: style.configuration))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundStyle(style.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text(style.name)
                        .font(.headline)

                    Text(style.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    showMenu = true
                } label: {
                    Text("Preview")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background {
                            Capsule()
                                .fill(style.accentColor)
                        }
                }
            }

            // Mini screenshot mockup
            ZStack {
                LinearGradient(colors: [style.accentColor.opacity(0.2),
                                        style.accentColor.opacity(0.05)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text("Style: \(style.name)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
            #if os(iOS)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
            #else
                .fill(Color(nsColor: .underPageBackgroundColor))
            #endif
        }
        .arcMenu(isPresented: $showMenu, viewModel: viewModel)
    }
}
