import Foundation
import SwiftUI

/// Represents a user profile in the ARCMenu.
///
/// `ARCMenuUser` encapsulates user information displayed in the menu header section,
/// following Apple's design patterns for user representation across their native apps.
///
/// ## Overview
///
/// The user model provides flexible avatar options including initials, images, symbols,
/// and remote URLs. It supports both email and custom subtitle for additional context.
///
/// ## Example Usage
///
/// ### Basic User with Initials
///
/// ```swift
/// let user = ARCMenuUser(
///     name: "Jane Cooper",
///     email: "jane@example.com",
///     avatarImage: .initials("JC")
/// )
/// ```
///
/// ### User with Remote Avatar
///
/// ```swift
/// let user = ARCMenuUser(
///     name: "John Doe",
///     subtitle: "Premium Member",
///     avatarImage: .url(URL(string: "https://example.com/avatar.jpg")!)
/// )
/// ```
///
/// ### User with SF Symbol
///
/// ```swift
/// let user = ARCMenuUser(
///     name: "Guest",
///     avatarImage: .systemImage("person.circle.fill")
/// )
/// ```
///
/// ## Topics
///
/// ### Creating a User
///
/// - ``init(id:name:email:subtitle:avatarImage:)``
///
/// ### User Properties
///
/// - ``id``
/// - ``name``
/// - ``email``
/// - ``subtitle``
/// - ``avatarImage``
///
/// ### Avatar Types
///
/// - ``ARCMenuUserImage``
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
/// - Important: Always provide a meaningful name for accessibility
public struct ARCMenuUser: Sendable, Identifiable {
    // MARK: - Properties

    /// Unique identifier for the user.
    ///
    /// Automatically generated on initialization unless explicitly provided.
    public let id: UUID

    /// The user's display name.
    ///
    /// This is the primary text shown in the menu header. Should be the user's
    /// full name or display name.
    ///
    /// - Important: Required for accessibility. VoiceOver reads this as the primary identifier.
    public let name: String

    /// Optional email address.
    ///
    /// Displayed as secondary text below the name. Mutually exclusive with ``subtitle``.
    /// If both are provided, email takes precedence in the UI.
    public let email: String?

    /// Optional subtitle text.
    ///
    /// Use for membership tier, role, or other contextual information.
    /// Examples: "Premium Member", "Pro Plan", "Administrator"
    ///
    /// - Note: Only displayed if ``email`` is nil
    public let subtitle: String?

    /// The user's avatar representation.
    ///
    /// Supports multiple types including initials, images, symbols, and URLs.
    /// See ``ARCMenuUserImage`` for all available options.
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

/// Represents different types of user avatars.
///
/// `ARCMenuUserImage` provides flexible avatar options to accommodate various use cases
/// and data sources. Each case handles its own rendering and loading states.
///
/// ## Overview
///
/// Choose the appropriate case based on your avatar data source:
/// - Use ``initials(_:)`` for generated avatars from user names
/// - Use ``systemImage(_:)`` for SF Symbol placeholders
/// - Use ``imageName(_:)`` for bundled assets
/// - Use ``url(_:)`` for remote images with automatic loading states
/// - Use ``custom(_:)`` for advanced custom implementations
///
/// ## Example Usage
///
/// ```swift
/// // Initials with gradient background
/// let avatar1: ARCMenuUserImage = .initials("JC")
///
/// // SF Symbol
/// let avatar2: ARCMenuUserImage = .systemImage("person.circle.fill")
///
/// // Bundled image
/// let avatar3: ARCMenuUserImage = .imageName("user-avatar")
///
/// // Remote URL with loading state
/// let avatar4: ARCMenuUserImage = .url(URL(string: "https://...")!)
/// ```
///
/// ## Topics
///
/// ### Avatar Types
///
/// - ``initials(_:)``
/// - ``systemImage(_:)``
/// - ``imageName(_:)``
/// - ``url(_:)``
/// - ``custom(_:)``
///
/// ### Rendering
///
/// - ``avatarView(size:)``
///
/// - Note: All cases conform to `Sendable` for thread-safe usage
public enum ARCMenuUserImage: Sendable {
    /// SF Symbol avatar.
    ///
    /// Renders a system symbol as the avatar. Useful for placeholder or guest users.
    ///
    /// - Parameter name: The SF Symbol name (e.g., "person.circle.fill")
    case systemImage(String)

    /// Bundled asset image avatar.
    ///
    /// Renders an image from the app's asset catalog.
    ///
    /// - Parameter name: The asset catalog image name
    case imageName(String)

    /// Remote URL avatar.
    ///
    /// Asynchronously loads an image from a remote URL. Shows a loading indicator
    /// while fetching and a fallback symbol on failure.
    ///
    /// - Parameter url: The remote image URL
    case url(URL)

    /// Initials avatar with gradient background.
    ///
    /// Generates a circular avatar with the user's initials on a blue-purple gradient.
    /// Ideal for users without profile pictures.
    ///
    /// - Parameter text: The initials to display (typically 1-2 characters)
    case initials(String)

    /// Custom avatar implementation.
    ///
    /// For advanced use cases requiring custom avatar rendering.
    /// Falls back to a system person symbol.
    ///
    /// - Parameter value: A hashable value identifying the custom avatar
    case custom(AnyHashable)

    // MARK: - Computed Properties

    /// Returns the appropriate SwiftUI view for the avatar.
    ///
    /// Renders the avatar based on the enum case, handling all loading states
    /// and styling automatically.
    ///
    /// - Parameter size: The diameter of the avatar in points. Defaults to 60.
    /// - Returns: A SwiftUI view representing the avatar
    ///
    /// ## Example
    ///
    /// ```swift
    /// let avatar = ARCMenuUserImage.initials("JD")
    /// avatar.avatarView(size: 80)  // Larger avatar
    /// ```
    @ViewBuilder
    public func avatarView(size: CGFloat = 60) -> some View {
        switch self {
        case .systemImage(let name):
            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(.primary)

        case .imageName(let name):
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())

        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
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

        case .initials(let text):
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

        case .custom:
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(.secondary)
        }
    }
}
