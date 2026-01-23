//
//  ARCTextField+Views.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 23/1/26.
//

import SwiftUI

// MARK: - Background Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextField {
    @ViewBuilder var backgroundView: some View {
        switch configuration.style {
        case .outlined:
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(currentBorderColor, lineWidth: currentBorderWidth)
                }

        case .filled:
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(filledBackgroundColor)
                .overlay {
                    if isErrorState {
                        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                            .strokeBorder(configuration.errorBorderColor, lineWidth: configuration.borderWidth)
                    }
                }

        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .fill(currentBorderColor)
                    .frame(height: currentBorderWidth)
            }

        case .glass:
            glassBackground
        }
    }

    @ViewBuilder var glassBackground: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay {
                if isErrorState {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(configuration.errorBorderColor, lineWidth: currentBorderWidth)
                } else {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isFocused ? 0.5 : 0.3),
                                    Color.white.opacity(isFocused ? 0.2 : 0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: currentBorderWidth
                        )
                }
            }
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }
}

// MARK: - Field Content Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextField {
    @ViewBuilder var fieldContent: some View {
        HStack(alignment: hasFloatingLabel ? .center : .center, spacing: 12) {
            leadingContent
            textFieldContent
            trailingContent
        }
        .padding(.horizontal, configuration.horizontalPadding)
    }

    @ViewBuilder var leadingContent: some View {
        if let icon = configuration.leadingIcon {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 24, height: 24)
        }
    }

    @ViewBuilder var textFieldContent: some View {
        if let label = configuration.label {
            VStack(alignment: .leading, spacing: 2) {
                floatingLabel(label)
                textInputView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            textInputView
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    func floatingLabel(_ label: String) -> some View {
        Text(label)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(labelColor)
            .scaleEffect(shouldFloatLabel ? 1 : 1.2, anchor: .leading)
            .offset(y: shouldFloatLabel ? 0 : 10)
            .opacity(shouldFloatLabel ? 1 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: shouldFloatLabel)
    }
}

// MARK: - Input Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextField {
    @ViewBuilder var textInputView: some View {
        Group {
            if configuration.isMultiline {
                multilineTextField
            } else {
                singleLineTextField
            }
        }
        .focused($isFocused)
        .autocorrectionDisabled(!configuration.autocorrection)
        .submitLabel(configuration.submitLabel)
        .onSubmit {
            handleSubmit()
        }
        #if os(iOS)
        .textInputAutocapitalization(configuration.textInputAutocapitalization)
        .keyboardType(configuration.keyboardType)
        .textContentType(configuration.textContentType)
        #endif
    }

    @ViewBuilder var singleLineTextField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty, !shouldFloatLabel {
                Text(placeholder)
                    .font(.body)
                    .foregroundStyle(.secondary.opacity(0.6))
            }

            TextField("", text: $text)
                .font(.body)
                .foregroundStyle(.primary)
        }
    }

    @ViewBuilder var multilineTextField: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty, !shouldFloatLabel {
                Text(placeholder)
                    .font(.body)
                    .foregroundStyle(.secondary.opacity(0.6))
                    .padding(.top, 8)
            }

            TextEditor(text: $text)
                .font(.body)
                .foregroundStyle(.primary)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 60)
        }
    }
}

// MARK: - Trailing Content Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextField {
    @ViewBuilder var trailingContent: some View {
        HStack(spacing: 8) {
            if shouldShowClearButton {
                clearButton
            }

            if configuration.showValidationIcon {
                validationIcon
            }

            if let icon = configuration.trailingIcon, !configuration.showValidationIcon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(iconColor)
            }
        }
    }

    @ViewBuilder var clearButton: some View {
        Button {
            text = ""
            validationState = .idle
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .transition(.opacity.combined(with: .scale))
    }

    @ViewBuilder var validationIcon: some View {
        Group {
            switch validationState {
            case .idle, .validating:
                EmptyView()

            case .valid:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(configuration.successBorderColor)

            case .invalid:
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(configuration.errorBorderColor)
            }
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.spring(response: 0.3), value: validationState)
    }
}

// MARK: - Bottom Content

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextField {
    @ViewBuilder var bottomContent: some View {
        HStack {
            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(configuration.errorBorderColor)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else if let helperText = configuration.helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if configuration.showCharacterCount, let limit = configuration.characterLimit {
                Text("\(text.count)/\(limit)")
                    .font(.caption)
                    .foregroundStyle(isOverCharacterLimit ? configuration.errorBorderColor : .secondary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 4)
        .animation(.easeInOut(duration: 0.2), value: validationState)
    }
}
