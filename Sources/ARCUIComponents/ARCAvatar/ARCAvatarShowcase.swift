//
//  ARCAvatarShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - ARCAvatarShowcase

/// Comprehensive showcase view for ARCAvatar demonstrating all configurations
///
/// Use this view to explore all avatar variants, sizes, shapes, and status options.
/// Perfect for design review and component documentation.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAvatarShowcase: View {
    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                contentTypesSection
                sizesSection
                shapesSection
                statusSection
                presetConfigurationsSection
                avatarGroupSection
                listExampleSection
                profileHeaderSection
            }
            .padding()
        }
        .navigationTitle("ARCAvatar")
    }

    // MARK: - Content Types Section

    private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Content Types")

            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    ARCAvatar(name: "John Doe")
                    Text("Name").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(initials: "AB")
                    Text("Initials").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(systemImage: "person.crop.circle.fill")
                    Text("SF Symbol").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar()
                    Text("Placeholder").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(url: URL(string: "https://example.com/avatar.jpg"))
                    Text("URL").font(.caption2)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Sizes Section

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Sizes")

            HStack(alignment: .bottom, spacing: 16) {
                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "XS",
                        configuration: ARCAvatarConfiguration(size: .xs)
                    )
                    Text("XS (24pt)").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "SM",
                        configuration: ARCAvatarConfiguration(size: .sm)
                    )
                    Text("SM (32pt)").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "MD",
                        configuration: ARCAvatarConfiguration(size: .md)
                    )
                    Text("MD (40pt)").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "LG",
                        configuration: ARCAvatarConfiguration(size: .lg)
                    )
                    Text("LG (56pt)").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "XL",
                        configuration: ARCAvatarConfiguration(size: .xl)
                    )
                    Text("XL (80pt)").font(.caption2)
                }
            }
            .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "XXL",
                        configuration: ARCAvatarConfiguration(size: .xxl)
                    )
                    Text("XXL (120pt)").font(.caption2)
                }
                Spacer()
            }
        }
    }

    // MARK: - Shapes Section

    private var shapesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Shapes")

            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Circle",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .circle
                        )
                    )
                    Text("Circle").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Rounded",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .roundedSquare(cornerRadius: 8)
                        )
                    )
                    Text("Rounded Square").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Squircle",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .squircle
                        )
                    )
                    Text("Squircle").font(.caption2)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Status Section

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Status Indicators")

            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    ARCAvatar(name: "No Status", status: .none)
                    Text("None").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(name: "Online User", status: .online)
                    Text("Online").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(name: "Offline User", status: .offline)
                    Text("Offline").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(name: "Busy User", status: .busy)
                    Text("Busy").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(name: "Away User", status: .away)
                    Text("Away").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(name: "Custom", status: .custom(.purple))
                    Text("Custom").font(.caption2)
                }
            }
            .frame(maxWidth: .infinity)

            // Status badge positions
            Text("Badge Positions").font(.subheadline).fontWeight(.medium)

            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "BR",
                        status: .online,
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            statusBadgePosition: .bottomTrailing
                        )
                    )
                    Text("Bottom Trailing").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "TR",
                        status: .online,
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            statusBadgePosition: .topTrailing
                        )
                    )
                    Text("Top Trailing").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "BL",
                        status: .online,
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            statusBadgePosition: .bottomLeading
                        )
                    )
                    Text("Bottom Leading").font(.caption2)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "TL",
                        status: .online,
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            statusBadgePosition: .topLeading
                        )
                    )
                    Text("Top Leading").font(.caption2)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Preset Configurations Section

    private var presetConfigurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Preset Configurations")

            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        ARCAvatar(name: "Default", configuration: .default)
                        Text(".default").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCAvatar(name: "Small", configuration: .small)
                        Text(".small").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCAvatar(name: "Large", configuration: .large)
                        Text(".large").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCAvatar(name: "Compact", configuration: .compact)
                        Text(".compact").font(.caption2).foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        ARCAvatar(name: "List Item", configuration: .listItem)
                        Text(".listItem").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCAvatar(name: "Comment", configuration: .comment)
                        Text(".comment").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCAvatar(name: "Bordered", configuration: .bordered)
                        Text(".bordered").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Example Sections

@available(iOS 17.0, macOS 14.0, *)
extension ARCAvatarShowcase {
    var avatarGroupSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Avatar Groups")
            VStack(alignment: .leading, spacing: 20) {
                groupExample("3 Members", avatars: [
                    ARCAvatar(name: "Alice Brown"),
                    ARCAvatar(name: "Bob Smith"),
                    ARCAvatar(name: "Carol White")
                ])
                groupExample(
                    "6 Members (max 4)",
                    avatars: [
                        ARCAvatar(name: "Alice"),
                        ARCAvatar(name: "Bob"),
                        ARCAvatar(name: "Carol"),
                        ARCAvatar(name: "David"),
                        ARCAvatar(name: "Eve"),
                        ARCAvatar(name: "Frank")
                    ],
                    maxDisplay: 4
                )
                groupExample("Compact Style", avatars: sampleAvatars, maxDisplay: 5, config: .compact)
                groupExample("Spread Style", avatars: sampleAvatars, maxDisplay: 4, config: .spread)
                groupExample("Large Style", avatars: sampleAvatars, maxDisplay: 3, config: .large)
            }
        }
    }

    var listExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("List Example")
            VStack(spacing: 0) {
                ForEach(sampleUsers, id: \.name) { user in
                    userRow(user)
                    if user.name != sampleUsers.last?.name { Divider() }
                }
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var profileHeaderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Profile Header Example")
            VStack(spacing: 16) {
                ARCAvatar(name: "John Appleseed", status: .online, configuration: .profile)
                Text("John Appleseed").font(.title2).fontWeight(.semibold)
                Text("iOS Developer").font(.subheadline).foregroundStyle(.secondary)
                HStack(spacing: 32) {
                    statView("142", "Posts")
                    statView("1.2K", "Followers")
                    statView("234", "Following")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Helpers

@available(iOS 17.0, macOS 14.0, *)
extension ARCAvatarShowcase {
    func sectionHeader(_ title: String) -> some View {
        Text(title).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
    }

    var sampleAvatars: [ARCAvatar] {
        [
            ARCAvatar(name: "Alice Brown"),
            ARCAvatar(name: "Bob Smith"),
            ARCAvatar(name: "Carol White"),
            ARCAvatar(name: "David Green"),
            ARCAvatar(name: "Eve Black")
        ]
    }

    var sampleUsers: [SampleUser] {
        [
            SampleUser(name: "Alice Brown", email: "alice@example.com", status: .online),
            SampleUser(name: "Bob Smith", email: "bob@example.com", status: .busy),
            SampleUser(name: "Carol White", email: "carol@example.com", status: .away),
            SampleUser(name: "David Green", email: "david@example.com", status: .offline)
        ]
    }

    private func groupExample(
        _ title: String,
        avatars: [ARCAvatar],
        maxDisplay: Int? = nil,
        config: ARCAvatarGroupConfiguration? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline)
            if let max = maxDisplay, let cfg = config {
                ARCAvatarGroup(avatars: avatars, maxDisplay: max, configuration: cfg)
            } else if let max = maxDisplay {
                ARCAvatarGroup(avatars: avatars, maxDisplay: max)
            } else {
                ARCAvatarGroup(avatars: avatars)
            }
        }
    }

    private func userRow(_ user: SampleUser) -> some View {
        HStack(spacing: 12) {
            ARCAvatar(name: user.name, status: user.status, configuration: .listItem)
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name).font(.body)
                Text(user.email).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
    }

    private func statView(_ value: String, _ label: String) -> some View {
        VStack {
            Text(value).font(.headline)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Sample User Model

private struct SampleUser {
    let name: String
    let email: String
    let status: ARCAvatarStatus
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCAvatar Showcase - Light") {
    NavigationStack {
        ARCAvatarShowcase()
    }
    .preferredColorScheme(.light)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCAvatar Showcase - Dark") {
    NavigationStack {
        ARCAvatarShowcase()
    }
    .preferredColorScheme(.dark)
}
