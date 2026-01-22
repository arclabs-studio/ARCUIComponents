//
//  ARCOnboardingPageView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCOnboardingPageView

/// Internal view for rendering a single onboarding page
///
/// This view handles the layout and animation of individual page content,
/// including the image, title, and subtitle.
@available(iOS 17.0, macOS 14.0, *)
struct ARCOnboardingPageView: View {
    // MARK: - Properties

    let page: ARCOnboardingPage
    let configuration: ARCOnboardingConfiguration
    let isCurrentPage: Bool

    // MARK: - State

    @State private var imageScale: CGFloat = 0.8
    @State private var imageOpacity: Double = 0
    @State private var textOpacity: Double = 0

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .title)
    private var imageSize: CGFloat = 120

    @ScaledMetric(relativeTo: .body)
    private var contentSpacing: CGFloat = 24

    @ScaledMetric(relativeTo: .body)
    private var textSpacing: CGFloat = 12

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: contentSpacing) {
                imageSection(height: geometry.size.height * configuration.imageHeight)

                textSection

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            animateContent()
        }
        .onChange(of: isCurrentPage) { _, newValue in
            if newValue {
                animateContent()
            } else {
                resetAnimation()
            }
        }
    }

    // MARK: - Image Section

    @ViewBuilder
    private func imageSection(height: CGFloat) -> some View {
        VStack {
            Spacer(minLength: 0)

            imageView
                .frame(maxWidth: .infinity)
                .frame(height: height * 0.8)
                .scaleEffect(imageScale)
                .opacity(imageOpacity)

            Spacer(minLength: 0)
        }
        .frame(height: height)
    }

    @ViewBuilder private var imageView: some View {
        switch page.image {
        case let .systemImage(name):
            Image(systemName: name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.system(size: imageSize, weight: .light))
                .foregroundStyle(page.imageColor ?? page.accentColor ?? .accentColor)
                .symbolRenderingMode(.hierarchical)
                .frame(maxWidth: imageSize * 1.5, maxHeight: imageSize * 1.5)
                .accessibilityHidden(true)

        case let .assetImage(name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .accessibilityHidden(true)

        case let .url(url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .scaleEffect(1.5)
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .accessibilityHidden(true)

        case let .custom(view):
            view
                .accessibilityHidden(true)
        }
    }

    // MARK: - Text Section

    @ViewBuilder private var textSection: some View {
        VStack(spacing: textSpacing) {
            Text(page.title)
                .font(configuration.titleFont)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(page.subtitle)
                .font(configuration.subtitleFont)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
        .opacity(textOpacity)
    }

    // MARK: - Animation

    private func animateContent() {
        guard configuration.animateImages, !reduceMotion else {
            imageScale = 1.0
            imageOpacity = 1.0
            textOpacity = 1.0
            return
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
            imageScale = 1.0
            imageOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
            textOpacity = 1.0
        }
    }

    private func resetAnimation() {
        guard configuration.animateImages, !reduceMotion else { return }

        imageScale = 0.8
        imageOpacity = 0
        textOpacity = 0
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Page View - SF Symbol") {
    ARCOnboardingPageView(
        page: .systemImage(
            "star.fill",
            color: .yellow,
            title: "Welcome to MyApp",
            subtitle: "Discover amazing features that will transform how you work and play every day."
        ),
        configuration: .default,
        isCurrentPage: true
    )
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Page View - Dark Mode") {
    ARCOnboardingPageView(
        page: .systemImage(
            "moon.stars.fill",
            color: .purple,
            title: "Dark Mode Support",
            subtitle: "Easy on your eyes, day or night."
        ),
        configuration: .default,
        isCurrentPage: true
    )
    .preferredColorScheme(.dark)
}
