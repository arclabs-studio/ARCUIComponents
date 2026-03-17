//
//  ARCStepIndicator.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCStepIndicator

/// A multi-step progress indicator for wizard and checkout flows
///
/// `ARCStepIndicator` displays progress through a multi-step process,
/// showing completed, current, and pending steps with connecting lines.
///
/// ## Overview
///
/// Step indicators help users understand where they are in a multi-step
/// process and how many steps remain. They're commonly used in:
/// - Onboarding flows
/// - Checkout processes
/// - Registration wizards
/// - Multi-part forms
///
/// ARCStepIndicator provides:
/// - Four visual styles (numbered, dots, icons, labels)
/// - Horizontal and vertical layouts
/// - Animated transitions between steps
/// - Checkmark animation for completed steps
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating Step Indicators
///
/// - ``init(totalSteps:currentStep:configuration:)``
///
/// ## Usage
///
/// ```swift
/// // Basic numbered steps
/// ARCStepIndicator(totalSteps: 4, currentStep: 2)
///
/// // Compact dots
/// ARCStepIndicator(
///     totalSteps: 5,
///     currentStep: 3,
///     configuration: .compact
/// )
///
/// // With labels
/// ARCStepIndicator(
///     totalSteps: 4,
///     currentStep: 2,
///     configuration: .detailed(labels: [
///         "Cart", "Shipping", "Payment", "Confirm"
///     ])
/// )
///
/// // With icons
/// ARCStepIndicator(
///     totalSteps: 3,
///     currentStep: 1,
///     configuration: .withIcons([
///         "person.fill", "creditcard.fill", "checkmark.circle.fill"
///     ])
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStepIndicator: View {
    // MARK: - Properties

    private let totalSteps: Int
    private let currentStep: Int
    private let configuration: ARCStepIndicatorConfiguration

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a step indicator with the specified configuration
    ///
    /// - Parameters:
    ///   - totalSteps: Total number of steps in the process
    ///   - currentStep: Current active step (1-indexed)
    ///   - configuration: Visual configuration (default: .default)
    public init(
        totalSteps: Int,
        currentStep: Int,
        configuration: ARCStepIndicatorConfiguration = .default
    ) {
        self.totalSteps = max(1, totalSteps)
        self.currentStep = min(max(1, currentStep), totalSteps)
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch configuration.layout {
            case .horizontal:
                horizontalLayout
            case .vertical:
                verticalLayout
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(currentStep) of \(totalSteps)")
        .accessibilityValue(accessibilityValue)
        .accessibilityHint("\(totalSteps - currentStep) steps remaining")
    }

    // MARK: - Horizontal Layout

    @ViewBuilder private var horizontalLayout: some View {
        HStack(spacing: 0) {
            ForEach(1 ... totalSteps, id: \.self) { step in
                stepView(for: step)

                if step < totalSteps {
                    connectorView(after: step, isHorizontal: true)
                }
            }
        }
    }

    // MARK: - Vertical Layout

    @ViewBuilder private var verticalLayout: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(1 ... totalSteps, id: \.self) { step in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 0) {
                        stepView(for: step)

                        if step < totalSteps {
                            connectorView(after: step, isHorizontal: false)
                        }
                    }

                    if case .labels = configuration.style {
                        verticalLabel(for: step)
                    }
                }
            }
        }
    }

    // MARK: - Step View

    @ViewBuilder
    private func stepView(for step: Int) -> some View {
        let state = stepState(for: step)

        ZStack {
            // Background circle
            Circle()
                .fill(state.backgroundColor(using: configuration))
                .frame(width: configuration.stepSize, height: configuration.stepSize)

            // Content
            stepContent(for: step, state: state)
        }
        .animation(
            configuration.animated && !reduceMotion
                ? .easeInOut(duration: configuration.animationDuration)
                : .none,
            value: currentStep
        )
    }

    @ViewBuilder
    private func stepContent(for step: Int, state: StepState) -> some View {
        switch configuration.style {
        case .numbered:
            numberedContent(for: step, state: state)

        case .dots:
            dotsContent(state: state)

        case let .icons(iconArray):
            iconsContent(for: step, icons: iconArray, state: state)

        case .labels:
            numberedContent(for: step, state: state)
        }
    }

    @ViewBuilder
    private func numberedContent(for step: Int, state: StepState) -> some View {
        if state == .completed, configuration.showCheckmarkAnimation {
            Image(systemName: "checkmark")
                .font(.system(size: configuration.stepSize * 0.4, weight: .bold))
                .foregroundStyle(.white)
        } else {
            Text("\(step)")
                .font(configuration.numberFont)
                .foregroundStyle(state == .pending ? configuration.pendingColor : .white)
        }
    }

    @ViewBuilder
    private func dotsContent(state: StepState) -> some View {
        if state == .completed {
            Circle()
                .fill(.white)
                .frame(
                    width: configuration.stepSize * 0.4,
                    height: configuration.stepSize * 0.4
                )
        } else if state == .current {
            Circle()
                .fill(.white)
                .frame(
                    width: configuration.stepSize * 0.5,
                    height: configuration.stepSize * 0.5
                )
        }
    }

    @ViewBuilder
    private func iconsContent(for step: Int, icons: [String], state: StepState) -> some View {
        let iconIndex = step - 1
        let iconName: String = {
            if state == .completed, configuration.showCheckmarkAnimation {
                return "checkmark"
            }
            guard iconIndex < icons.count else {
                return "circle"
            }
            return icons[iconIndex]
        }()

        Image(systemName: iconName)
            .font(.system(size: configuration.stepSize * 0.45, weight: .semibold))
            .foregroundStyle(state == .pending ? configuration.pendingColor : .white)
    }

    // MARK: - Vertical Label

    @ViewBuilder
    private func verticalLabel(for step: Int) -> some View {
        let labelIndex = step - 1
        let state = stepState(for: step)

        VStack(alignment: .leading, spacing: 4) {
            if labelIndex < configuration.labels.count {
                Text(configuration.labels[labelIndex])
                    .font(configuration.labelFont)
                    .foregroundStyle(state == .pending ? .secondary : .primary)
                    .fontWeight(state == .current ? .semibold : .regular)
            }
        }
        .frame(height: configuration.stepSize, alignment: .center)
    }

    // MARK: - Connector View

    @ViewBuilder
    private func connectorView(after step: Int, isHorizontal: Bool) -> some View {
        let isCompleted = step < currentStep

        Group {
            if isHorizontal {
                Rectangle()
                    .fill(isCompleted ? configuration.completedColor : configuration.connectorColor)
                    .frame(width: configuration.connectorLength, height: configuration.connectorThickness)
            } else {
                Rectangle()
                    .fill(isCompleted ? configuration.completedColor : configuration.connectorColor)
                    .frame(width: configuration.connectorThickness, height: configuration.connectorLength)
            }
        }
        .animation(
            configuration.animated && !reduceMotion
                ? .easeInOut(duration: configuration.animationDuration)
                : .none,
            value: currentStep
        )
    }

    // MARK: - Step State

    private func stepState(for step: Int) -> StepState {
        if step < currentStep {
            .completed
        } else if step == currentStep {
            .current
        } else {
            .pending
        }
    }

    // MARK: - Accessibility

    private var accessibilityValue: String {
        if case let .labels(labelArray) = configuration.style, currentStep - 1 < labelArray.count {
            return labelArray[currentStep - 1]
        }
        return "Step \(currentStep)"
    }
}

// MARK: - StepState

@available(iOS 17.0, macOS 14.0, *)
private enum StepState {
    case completed
    case current
    case pending

    func backgroundColor(using configuration: ARCStepIndicatorConfiguration) -> Color {
        switch self {
        case .completed:
            configuration.completedColor
        case .current:
            configuration.currentColor
        case .pending:
            configuration.pendingColor.opacity(0.3)
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Numbered Steps") {
    VStack(spacing: 40) {
        ARCStepIndicator(totalSteps: 4, currentStep: 1)
        ARCStepIndicator(totalSteps: 4, currentStep: 2)
        ARCStepIndicator(totalSteps: 4, currentStep: 3)
        ARCStepIndicator(totalSteps: 4, currentStep: 4)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Compact Dots") {
    VStack(spacing: 40) {
        ARCStepIndicator(totalSteps: 5, currentStep: 1, configuration: .compact)
        ARCStepIndicator(totalSteps: 5, currentStep: 3, configuration: .compact)
        ARCStepIndicator(totalSteps: 5, currentStep: 5, configuration: .compact)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Icons") {
    VStack(spacing: 40) {
        ARCStepIndicator(
            totalSteps: 4,
            currentStep: 2,
            configuration: .withIcons([
                "cart.fill",
                "truck.box.fill",
                "creditcard.fill",
                "checkmark.seal.fill"
            ])
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Vertical with Labels") {
    ARCStepIndicator(
        totalSteps: 4,
        currentStep: 2,
        configuration: .detailed(labels: [
            "Account Details",
            "Shipping Address",
            "Payment Method",
            "Review Order"
        ])
    )
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Custom Colors") {
    VStack(spacing: 40) {
        ARCStepIndicator(
            totalSteps: 4,
            currentStep: 2,
            configuration: ARCStepIndicatorConfiguration(
                completedColor: .green,
                currentColor: .blue,
                pendingColor: Color.gray.opacity(0.3)
            )
        )

        ARCStepIndicator(
            totalSteps: 4,
            currentStep: 3,
            configuration: ARCStepIndicatorConfiguration(
                completedColor: .orange,
                currentColor: .orange,
                pendingColor: Color.orange.opacity(0.2)
            )
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 40) {
        ARCStepIndicator(totalSteps: 4, currentStep: 2)
        ARCStepIndicator(totalSteps: 5, currentStep: 3, configuration: .compact)
    }
    .padding()
    .preferredColorScheme(.dark)
}
