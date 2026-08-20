//
//  AIRecommenderItem.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import SwiftUI

/// Protocol for items that can be displayed in ARCAIRecommender
///
/// Implement this protocol on your model types to display them
/// in the AI recommender component.
///
/// ## Example
///
/// ```swift
/// struct Restaurant: AIRecommenderItem {
///     let id: UUID
///     let title: String
///     var subtitle: String? { "\(cuisineType) · \(priceRange)" }
///     var rating: Double? { averageRating }
///     var imageSource: AIRecommenderImageSource? { .system(cuisineIcon) }
///     var aiReason: String? { "Te encanta la cocina italiana" }
///     var location: String? { "Centro, Madrid · 0.5 km" }
///     var highlightDetail: String? { "Pasta Carbonara" }
///
///     // Your own properties
///     let cuisineType: String
///     let priceRange: String
///     let averageRating: Double
///     let cuisineIcon: String
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *) public protocol AIRecommenderItem: Identifiable, Sendable {
    /// Unique identifier for the item
    var id: ID { get }

    /// Primary title displayed prominently
    var title: String { get }

    /// Optional subtitle with additional context (e.g., "Italian · $$$")
    var subtitle: String? { get }

    /// Optional rating value (typically 0-10 or 0-5)
    var rating: Double? { get }

    /// Optional image source for the item artwork
    var imageSource: AIRecommenderImageSource? { get }

    /// Optional AI-generated reason for the recommendation
    var aiReason: String? { get }

    /// Optional location description (e.g., "Centro, Madrid · 0.5 km")
    var location: String? { get }

    /// Optional highlight detail (e.g., featured dish or standout feature)
    var highlightDetail: String? { get }
}

// MARK: - Default Implementations

@available(iOS 17.0, macOS 14.0, *) extension AIRecommenderItem {
    public var subtitle: String? {
        nil
    }

    public var rating: Double? {
        nil
    }

    public var imageSource: AIRecommenderImageSource? {
        nil
    }

    public var aiReason: String? {
        nil
    }

    public var location: String? {
        nil
    }

    public var highlightDetail: String? {
        nil
    }
}

// MARK: - AIRecommenderImageSource

/// Image source options for recommendation items
///
/// Supports SF Symbols, asset catalog images, remote URLs, and gradient placeholders.
///
/// ## Usage
///
/// ```swift
/// // SF Symbol
/// .system("fork.knife", color: .orange)
///
/// // Asset catalog
/// .image("restaurant-photo")
///
/// // Remote URL
/// .url(URL(string: "https://example.com/image.jpg")!)
///
/// // Gradient placeholder with initials
/// .placeholder(text: "MR", colors: [.orange, .red])
/// ```
@available(iOS 17.0, macOS 14.0, *) public enum AIRecommenderImageSource: Sendable, Equatable {
    /// SF Symbol icon with optional tint color
    case system(String, color: Color = .primary)

    /// Image from asset catalog
    case image(String)

    /// Remote image URL (loaded with AsyncImage)
    case url(URL)

    /// Gradient placeholder with optional text overlay
    case placeholder(text: String? = nil, colors: [Color] = [.gray.opacity(0.3), .gray.opacity(0.1)])

    // MARK: - View Builder

    /// Creates a hero image view for card stack display
    /// - Parameter height: The height of the hero image container
    @ViewBuilder public func heroImageView(height: CGFloat = 200) -> some View {
        switch self {
        case let .system(name, color):
            heroSystemView(name: name, color: color, height: height)
        case let .image(name):
            heroAssetView(name: name, height: height)
        case let .url(imageURL):
            heroAsyncView(url: imageURL, height: height)
        case let .placeholder(text, colors):
            heroPlaceholderView(text: text, colors: colors, height: height)
        }
    }

    private func heroSystemView(name: String, color: Color, height: CGFloat) -> some View {
        ZStack {
            LinearGradient(colors: [color.opacity(0.4), color.opacity(0.15)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            Image(systemName: name)
                .font(.system(size: 80))
                .foregroundStyle(color.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }

    private func heroAssetView(name: String, height: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipped()
            .overlay(alignment: .bottom) { heroGradientOverlay(height: height) }
    }

    private func heroAsyncView(url: URL, height: CGFloat) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: height)

            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipped()
                    .overlay(alignment: .bottom) { heroGradientOverlay(height: height) }

            case .failure:
                heroFailurePlaceholder(height: height)

            @unknown default:
                Color.gray.opacity(0.1)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
            }
        }
    }

    private func heroPlaceholderView(text: String?, colors: [Color], height: CGFloat) -> some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            if let text {
                Text(text)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }

    private func heroGradientOverlay(height: CGFloat) -> some View {
        LinearGradient(colors: [.clear, .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
            .frame(height: height * 0.5)
    }

    private func heroFailurePlaceholder(height: CGFloat) -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            Image(systemName: "photo").font(.system(size: 40)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }

    /// Creates the image view for this source
    /// - Parameter size: The size of the image container
    @ViewBuilder public func imageView(size: CGFloat = 60) -> some View {
        switch self {
        case let .system(name, color):
            systemImageView(name: name, color: color, size: size)
        case let .image(name):
            assetImageView(name: name, size: size)
        case let .url(imageURL):
            asyncImageView(url: imageURL, size: size)
        case let .placeholder(text, colors):
            placeholderView(text: text, colors: colors, size: size)
        }
    }

    private func systemImageView(name: String, color: Color, size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.15))
            Image(systemName: name)
                .font(.title2)
                .foregroundStyle(color)
        }
        .frame(width: size, height: size)
    }

    private func assetImageView(name: String, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

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
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            case .failure:
                failurePlaceholder(size: size)
            @unknown default:
                failurePlaceholder(size: size)
            }
        }
    }

    private func failurePlaceholder(size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.2))
            Image(systemName: "photo")
                .foregroundStyle(.secondary)
        }
        .frame(width: size, height: size)
    }

    private func placeholderView(text: String?, colors: [Color], size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(LinearGradient(colors: colors,
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
            if let text {
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
    }
}
