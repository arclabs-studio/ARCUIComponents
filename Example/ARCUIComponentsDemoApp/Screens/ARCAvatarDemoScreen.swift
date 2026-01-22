//
//  ARCAvatarDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCAvatar component.
///
/// Shows avatars with various content types, sizes, shapes, and status indicators.
@available(iOS 17.0, *)
struct ARCAvatarDemoScreen: View {
    // MARK: - State

    @State private var selectedStatus: ARCAvatarStatus = .online
    @State private var selectedSize: ARCAvatarConfiguration.Size = .md

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                contentTypesSection
                sizesSection
                shapesSection
                statusSection
                avatarGroupSection
                listExampleSection
                profileExampleSection
            }
            .padding()
        }
        .navigationTitle("ARCAvatar")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCAvatarDemoScreen {
    // MARK: - Content Types Section

    private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Content Types", subtitle: "Image, URL, initials, and placeholder")

            VStack(spacing: 16) {
                contentRow("From Name", description: "Automatically extracts initials") {
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            ARCAvatar(name: "John Doe")
                            Text("John Doe").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCAvatar(name: "Alice Smith")
                            Text("Alice Smith").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCAvatar(name: "Bob")
                            Text("Bob").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                contentRow("Explicit Initials", description: "Custom initials string") {
                    HStack(spacing: 24) {
                        ARCAvatar(initials: "JD")
                        ARCAvatar(initials: "AS")
                        ARCAvatar(initials: "BW")
                    }
                }

                contentRow("SF Symbol", description: "System image as avatar") {
                    HStack(spacing: 24) {
                        ARCAvatar(systemImage: "person.crop.circle.fill")
                        ARCAvatar(systemImage: "person.2.fill")
                        ARCAvatar(systemImage: "building.2.fill")
                    }
                }

                contentRow("Placeholder", description: "Default empty avatar") {
                    HStack(spacing: 24) {
                        ARCAvatar()
                        ARCAvatar(configuration: .small)
                        ARCAvatar(configuration: .large)
                    }
                }
            }
        }
    }

    private func contentRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Sizes Section

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Avatar Sizes", subtitle: "From extra small to extra extra large")

            HStack(alignment: .bottom, spacing: 12) {
                VStack(spacing: 4) {
                    ARCAvatar(name: "XS", configuration: ARCAvatarConfiguration(size: .xs))
                    Text("XS").font(.caption2).foregroundStyle(.secondary)
                    Text("24pt").font(.caption2).foregroundStyle(.tertiary)
                }

                VStack(spacing: 4) {
                    ARCAvatar(name: "SM", configuration: ARCAvatarConfiguration(size: .sm))
                    Text("SM").font(.caption2).foregroundStyle(.secondary)
                    Text("32pt").font(.caption2).foregroundStyle(.tertiary)
                }

                VStack(spacing: 4) {
                    ARCAvatar(name: "MD", configuration: ARCAvatarConfiguration(size: .md))
                    Text("MD").font(.caption2).foregroundStyle(.secondary)
                    Text("40pt").font(.caption2).foregroundStyle(.tertiary)
                }

                VStack(spacing: 4) {
                    ARCAvatar(name: "LG", configuration: ARCAvatarConfiguration(size: .lg))
                    Text("LG").font(.caption2).foregroundStyle(.secondary)
                    Text("56pt").font(.caption2).foregroundStyle(.tertiary)
                }

                VStack(spacing: 4) {
                    ARCAvatar(name: "XL", configuration: ARCAvatarConfiguration(size: .xl))
                    Text("XL").font(.caption2).foregroundStyle(.secondary)
                    Text("80pt").font(.caption2).foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Shapes Section

    private var shapesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Avatar Shapes", subtitle: "Circle, rounded square, and squircle")

            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Circle",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .circle
                        )
                    )
                    Text("Circle").font(.caption).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Rounded",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .roundedSquare(cornerRadius: 12)
                        )
                    )
                    Text("Rounded").font(.caption).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCAvatar(
                        name: "Squircle",
                        configuration: ARCAvatarConfiguration(
                            size: .lg,
                            shape: .squircle
                        )
                    )
                    Text("Squircle").font(.caption).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Status Section

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Status Indicators", subtitle: "Show online presence")

            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        ARCAvatar(name: "None", status: .none)
                        Text("None").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(name: "Online", status: .online)
                        Text("Online").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(name: "Offline", status: .offline)
                        Text("Offline").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(name: "Busy", status: .busy)
                        Text("Busy").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(name: "Away", status: .away)
                        Text("Away").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)

                Divider()

                Text("Badge Positions").font(.subheadline.weight(.medium))

                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        ARCAvatar(
                            name: "BR",
                            status: .online,
                            configuration: ARCAvatarConfiguration(
                                size: .lg,
                                statusBadgePosition: .bottomTrailing
                            )
                        )
                        Text("Bottom Trailing").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(
                            name: "TR",
                            status: .online,
                            configuration: ARCAvatarConfiguration(
                                size: .lg,
                                statusBadgePosition: .topTrailing
                            )
                        )
                        Text("Top Trailing").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCAvatar(
                            name: "BL",
                            status: .online,
                            configuration: ARCAvatarConfiguration(
                                size: .lg,
                                statusBadgePosition: .bottomLeading
                            )
                        )
                        Text("Bottom Leading").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Avatar Group Section

    private var avatarGroupSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Avatar Groups", subtitle: "Display multiple users")

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default (3 members)").font(.subheadline)
                    ARCAvatarGroup(
                        avatars: [
                            ARCAvatar(name: "Alice Brown"),
                            ARCAvatar(name: "Bob Smith"),
                            ARCAvatar(name: "Carol White"),
                        ]
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Overflow (6 members, max 4)").font(.subheadline)
                    ARCAvatarGroup(
                        avatars: [
                            ARCAvatar(name: "Alice"),
                            ARCAvatar(name: "Bob"),
                            ARCAvatar(name: "Carol"),
                            ARCAvatar(name: "David"),
                            ARCAvatar(name: "Eve"),
                            ARCAvatar(name: "Frank"),
                        ],
                        maxDisplay: 4
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Compact Style").font(.subheadline)
                    ARCAvatarGroup(
                        avatars: sampleAvatars,
                        configuration: .compact
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Large Style").font(.subheadline)
                    ARCAvatarGroup(
                        avatars: sampleAvatars,
                        maxDisplay: 3,
                        configuration: .large
                    )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - List Example Section

    private var listExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("List Example", subtitle: "Avatars in a user list")

            VStack(spacing: 0) {
                ForEach(sampleUsers, id: \.name) { user in
                    HStack(spacing: 12) {
                        ARCAvatar(
                            name: user.name,
                            status: user.status,
                            configuration: .listItem
                        )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.name)
                                .font(.body)
                            Text(user.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 12)

                    if user.name != sampleUsers.last?.name {
                        Divider()
                    }
                }
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Profile Example Section

    private var profileExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Profile Header", subtitle: "Large avatar for profile screens")

            VStack(spacing: 16) {
                ARCAvatar(
                    name: "John Appleseed",
                    status: .online,
                    configuration: .profile
                )

                Text("John Appleseed")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("iOS Developer at ARC Labs")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 40) {
                    VStack {
                        Text("142")
                            .font(.headline)
                        Text("Posts")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack {
                        Text("1.2K")
                            .font(.headline)
                        Text("Followers")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack {
                        Text("234")
                            .font(.headline)
                        Text("Following")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var sampleAvatars: [ARCAvatar] {
        [
            ARCAvatar(name: "Alice Brown"),
            ARCAvatar(name: "Bob Smith"),
            ARCAvatar(name: "Carol White"),
            ARCAvatar(name: "David Green"),
            ARCAvatar(name: "Eve Black"),
        ]
    }

    private var sampleUsers: [(name: String, email: String, status: ARCAvatarStatus)] {
        [
            (name: "Alice Brown", email: "alice@example.com", status: .online),
            (name: "Bob Smith", email: "bob@example.com", status: .busy),
            (name: "Carol White", email: "carol@example.com", status: .away),
            (name: "David Green", email: "david@example.com", status: .offline),
        ]
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCAvatarDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCAvatarDemoScreen()
    }
    .preferredColorScheme(.dark)
}
