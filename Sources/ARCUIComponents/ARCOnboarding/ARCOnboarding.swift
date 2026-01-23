//
//  ARCOnboarding.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCOnboarding

/// A customizable onboarding flow component with horizontal page navigation
///
/// `ARCOnboarding` provides a complete onboarding experience with smooth transitions,
/// page indicators, and navigation controls. It guides users through app features
/// with illustrations, titles, and descriptions.
///
/// ## Overview
///
/// ARCOnboarding supports:
/// - Multiple page types (SF Symbols, images, custom views)
/// - Configurable navigation (skip, back, next buttons)
/// - Multiple indicator styles (dots, lines, numbers, progress)
/// - Smooth page transitions with animations
/// - Full accessibility support with VoiceOver
/// - Swipe gestures for natural navigation
///
/// ## Topics
///
/// ### Creating Onboarding
///
/// - ``init(pages:configuration:onComplete:onSkip:)``
///
/// ### Types
///
/// - ``ARCOnboardingPage``
/// - ``ARCOnboardingConfiguration``
///
/// ## Usage
///
/// ```swift
/// // Basic onboarding
/// ARCOnboarding(
///     pages: [
///         .systemImage(
///             "star.fill",
///             color: .yellow,
///             title: "Welcome",
///             subtitle: "Discover amazing features"
///         ),
///         .systemImage(
///             "bell.fill",
///             color: .blue,
///             title: "Stay Notified",
///             subtitle: "Get reminders when tasks are due"
///         ),
///         .systemImage(
///             "checkmark.circle.fill",
///             color: .green,
///             title: "Track Progress",
///             subtitle: "See your productivity grow"
///         )
///     ],
///     onComplete: {
///         hasSeenOnboarding = true
///     }
/// )
///
/// // Full screen cover usage
/// .fullScreenCover(isPresented: $showOnboarding) {
///     ARCOnboarding(pages: pages) {
///         showOnboarding = false
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCOnboarding: View {
    // MARK: - Properties

    private let pages: [ARCOnboardingPage]
    private let configuration: ARCOnboardingConfiguration
    private let onComplete: () -> Void
    private let onSkip: (() -> Void)?

    // MARK: - State

    @State private var currentPage: Int = 0
    @State private var dragOffset: CGFloat = 0

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var buttonHeight: CGFloat = 50

    @ScaledMetric(relativeTo: .body)
    private var horizontalPadding: CGFloat = 24

    @ScaledMetric(relativeTo: .body)
    private var bottomPadding: CGFloat = 32

    @ScaledMetric(relativeTo: .body)
    private var indicatorSpacing: CGFloat = 24

    // MARK: - Initialization

    /// Creates an onboarding flow with the specified pages and configuration
    ///
    /// - Parameters:
    ///   - pages: Array of pages to display in the onboarding flow
    ///   - configuration: Configuration options for appearance and behavior
    ///   - onComplete: Closure called when user completes the onboarding
    ///   - onSkip: Optional closure called when user skips the onboarding
    public init(
        pages: [ARCOnboardingPage],
        configuration: ARCOnboardingConfiguration = .default,
        onComplete: @escaping () -> Void,
        onSkip: (() -> Void)? = nil
    ) {
        self.pages = pages
        self.configuration = configuration
        self.onComplete = onComplete
        self.onSkip = onSkip
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: 0) {
                if configuration.indicatorPosition == .top {
                    topIndicatorSection
                }

                skipButtonSection

                pageContent

                bottomSection
            }
        }
        .gesture(swipeGesture)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Onboarding")
        .accessibilityValue("Page \(currentPage + 1) of \(pages.count)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                nextPage()
            case .decrement:
                previousPage()
            @unknown default:
                break
            }
        }
    }

    // MARK: - Background

    @ViewBuilder private var backgroundView: some View {
        Color.clear
            .background(.background)
            .ignoresSafeArea()
    }

    // MARK: - Top Indicator Section

    @ViewBuilder private var topIndicatorSection: some View {
        HStack {
            Spacer()
            ARCOnboardingIndicator(
                totalPages: pages.count,
                currentPage: currentPage,
                style: configuration.indicatorStyle,
                accentColor: currentAccentColor
            )
            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: - Skip Button Section

    @ViewBuilder private var skipButtonSection: some View {
        HStack {
            Spacer()

            if configuration.showSkipButton, !isLastPage {
                Button(configuration.skipButtonTitle) {
                    handleSkip()
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .padding(.trailing, horizontalPadding)
                .accessibilityLabel("Skip onboarding")
                .accessibilityHint("Skips remaining pages and starts using the app")
            }
        }
        .frame(height: 44)
        .padding(.top, configuration.indicatorPosition == .top ? 8 : 16)
    }

    // MARK: - Page Content

    @ViewBuilder private var pageContent: some View {
        #if os(iOS)
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                ARCOnboardingPageView(
                    page: page,
                    configuration: configuration,
                    isCurrentPage: index == currentPage
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(
            reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.8),
            value: currentPage
        )
        #else
        // macOS fallback - simple view with navigation
        ARCOnboardingPageView(
            page: pages[currentPage],
            configuration: configuration,
            isCurrentPage: true
        )
        .animation(
            reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.8),
            value: currentPage
        )
        #endif
    }

    // MARK: - Bottom Section

    @ViewBuilder private var bottomSection: some View {
        VStack(spacing: indicatorSpacing) {
            if configuration.indicatorPosition == .aboveButtons {
                ARCOnboardingIndicator(
                    totalPages: pages.count,
                    currentPage: currentPage,
                    style: configuration.indicatorStyle,
                    accentColor: currentAccentColor
                )
            }

            navigationButtons

            if configuration.indicatorPosition == .bottom {
                ARCOnboardingIndicator(
                    totalPages: pages.count,
                    currentPage: currentPage,
                    style: configuration.indicatorStyle,
                    accentColor: currentAccentColor
                )
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, bottomPadding)
    }

    // MARK: - Navigation Buttons

    @ViewBuilder private var navigationButtons: some View {
        VStack(spacing: 12) {
            primaryButton

            if configuration.showBackButton, currentPage > 0 {
                backButton
            }
        }
    }

    @ViewBuilder private var backButton: some View {
        Button {
            previousPage()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.subheadline.weight(.medium))
                Text("Back")
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Go to previous page")
    }

    @ViewBuilder private var primaryButton: some View {
        Button {
            if isLastPage {
                onComplete()
            } else {
                nextPage()
            }
        } label: {
            Text(buttonTitle)
                .font(.body.weight(.semibold))
                .foregroundStyle(primaryButtonTextColor)
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
        }
        .buttonStyle(OnboardingButtonStyle(
            style: configuration.buttonStyle,
            configuration: configuration,
            accentColor: currentAccentColor,
            isSecondary: false
        ))
        .accessibilityLabel(isLastPage ? "Complete onboarding" : "Go to next page")
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let threshold: CGFloat = 50
                let velocity = value.velocity.width

                if value.translation.width < -threshold || velocity < -500 {
                    nextPage()
                } else if value.translation.width > threshold || velocity > 500 {
                    previousPage()
                }
            }
    }

    // MARK: - Computed Properties

    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    private var buttonTitle: String {
        isLastPage ? configuration.finishButtonTitle : configuration.nextButtonTitle
    }

    private var currentAccentColor: Color {
        pages[safe: currentPage]?.accentColor ?? configuration.accentColor
    }

    private var primaryButtonTextColor: Color {
        switch configuration.buttonStyle {
        case .text:
            currentAccentColor
        case .filled:
            .white
        case .glass:
            .primary
        }
    }

    // MARK: - Navigation Functions

    private func nextPage() {
        guard currentPage < pages.count - 1 else { return }
        withAnimation(reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.8)) {
            currentPage += 1
        }
    }

    private func previousPage() {
        guard currentPage > 0 else { return }
        withAnimation(reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.8)) {
            currentPage -= 1
        }
    }

    private func handleSkip() {
        if let onSkip {
            onSkip()
        } else {
            onComplete()
        }
    }
}

// MARK: - OnboardingButtonStyle

@available(iOS 17.0, macOS 14.0, *)
private struct OnboardingButtonStyle: ButtonStyle {
    let style: ARCOnboardingConfiguration.ButtonStyle
    let configuration: ARCOnboardingConfiguration
    let accentColor: Color
    let isSecondary: Bool

    func makeBody(configuration pressedConfiguration: Configuration) -> some View {
        pressedConfiguration.label
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .scaleEffect(pressedConfiguration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: pressedConfiguration.isPressed)
    }

    @ViewBuilder private var backgroundView: some View {
        switch style {
        case .text:
            Color.clear

        case .filled:
            if isSecondary {
                accentColor.opacity(0.15)
            } else {
                accentColor
            }

        case .glass:
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Array Extension

extension Array {
    fileprivate subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCOnboarding") {
    ARCOnboarding(
        pages: [
            .systemImage("star.fill", color: .yellow, title: "Welcome", subtitle: "Get started"),
            .systemImage("bell.fill", color: .blue, title: "Notify", subtitle: "Stay updated"),
            .systemImage("checkmark.circle.fill", color: .green, title: "Done", subtitle: "All set")
        ],
        onComplete: {}
    )
}
