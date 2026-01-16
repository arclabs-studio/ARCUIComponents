//
//  ARCMenuUser.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import Foundation
import SwiftUI

/// Represents a user profile in the ARCMenu
///
/// This model encapsulates user information displayed in the menu header,
/// following Apple's design patterns for user representation.
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
public struct ARCMenuUser: Sendable, Identifiable {
    // MARK: - Properties

    public let id: UUID
    public let name: String
    public let email: String?
    public let subtitle: String?
    public let avatarImage: ARCMenuUserImage

    // MARK: - Initialization

    /// Creates a new menu user
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - name: User's display name
    ///   - email: Optional email address
    ///   - subtitle: Optional subtitle (e.g., membership tier, role)
    ///   - avatarImage: User's avatar image
    public init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        subtitle: String? = nil,
        avatarImage: ARCMenuUserImage
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.subtitle = subtitle
        self.avatarImage = avatarImage
    }
}

// MARK: - ARCMenuUserImage

/// Represents different types of user avatars
///
/// Supports system images, asset catalog images, URLs, and initials
/// for maximum flexibility across different app contexts.
public enum ARCMenuUserImage: Sendable {
    case systemImage(String)
    case imageName(String)
    case url(URL)
    case initials(String)

    // MARK: - Public Methods

    /// Returns the appropriate SwiftUI view for the avatar
    @ViewBuilder
    public func avatarView(size: CGFloat = 60) -> some View {
        switch self {
        case let .systemImage(name):
            systemImageView(name: name, size: size)
        case let .imageName(name):
            assetImageView(name: name, size: size)
        case let .url(url):
            asyncImageView(url: url, size: size)
        case let .initials(text):
            initialsView(text: text, size: size)
        }
    }

    // MARK: - Private Helpers

    @ViewBuilder
    private func systemImageView(name: String, size: CGFloat) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private func assetImageView(name: String, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }

    @ViewBuilder
    private func asyncImageView(url: URL, size: CGFloat) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            case .failure:
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundStyle(.secondary)
            @unknown default:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func initialsView(text: String, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(text)
                .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}
