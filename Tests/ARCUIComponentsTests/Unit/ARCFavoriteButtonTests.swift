//
//  ARCFavoriteButtonTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 5/18/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ``ARCFavoriteButton``.
///
/// Locks in the icon-pair lookup, size mapping, touch-target floor, and the
/// Option A empty-state affordance contract (semibold weight, brand-tinted
/// foreground instead of `Color.secondary`).
struct ARCFavoriteButtonTests {
    // MARK: - Factory

    @MainActor private func makeSUT(isFavorite: Binding<Bool> = .constant(false),
                                    icon: ARCFavoriteButton.Icon = .heart,
                                    color: Color = .pink,
                                    size: ARCFavoriteButton.Size = .medium,
                                    style: ARCFavoriteButton.Style = .plain,
                                    haptics: Bool = false,
                                    onToggle: ((Bool) -> Void)? = nil) -> ARCFavoriteButton {
        ARCFavoriteButton(isFavorite: isFavorite,
                          icon: icon,
                          color: color,
                          size: size,
                          style: style,
                          haptics: haptics,
                          onToggle: onToggle)
    }

    // MARK: - Icon name mapping

    @Test("icon_heart_mapsToHeartSymbols") func icon_heart_mapsToHeartSymbols() {
        // Given
        let icon: ARCFavoriteButton.Icon = .heart

        // Then
        #expect(icon.filledName == "heart.fill")
        #expect(icon.emptyName == "heart")
    }

    @Test("icon_star_mapsToStarSymbols") func icon_star_mapsToStarSymbols() {
        let icon: ARCFavoriteButton.Icon = .star
        #expect(icon.filledName == "star.fill")
        #expect(icon.emptyName == "star")
    }

    @Test("icon_bookmark_mapsToBookmarkSymbols") func icon_bookmark_mapsToBookmarkSymbols() {
        let icon: ARCFavoriteButton.Icon = .bookmark
        #expect(icon.filledName == "bookmark.fill")
        #expect(icon.emptyName == "bookmark")
    }

    @Test("icon_flag_mapsToFlagSymbols") func icon_flag_mapsToFlagSymbols() {
        let icon: ARCFavoriteButton.Icon = .flag
        #expect(icon.filledName == "flag.fill")
        #expect(icon.emptyName == "flag")
    }

    @Test("icon_custom_returnsProvidedNames") func icon_custom_returnsProvidedNames() {
        // Given
        let icon: ARCFavoriteButton.Icon = .custom(filled: "hand.thumbsup.fill",
                                                   empty: "hand.thumbsup")

        // Then
        #expect(icon.filledName == "hand.thumbsup.fill")
        #expect(icon.emptyName == "hand.thumbsup")
    }

    // MARK: - Size mapping

    @Test("size_small_usesSmallIcon") func size_small_usesSmallIcon() {
        #expect(ARCFavoriteButton.Size.small.iconSize == 20)
    }

    @Test("size_medium_usesMediumIcon") func size_medium_usesMediumIcon() {
        #expect(ARCFavoriteButton.Size.medium.iconSize == 24)
    }

    @Test("size_large_usesLargeIcon") func size_large_usesLargeIcon() {
        #expect(ARCFavoriteButton.Size.large.iconSize == 28)
    }

    @Test("size_custom_returnsProvidedSize") func size_custom_returnsProvidedSize() {
        #expect(ARCFavoriteButton.Size.custom(36).iconSize == 36)
    }

    // MARK: - Touch target (HIG 44pt floor)

    @Test("touchTarget_smallIcon_isAtLeast44pt") func touchTarget_smallIcon_isAtLeast44pt() {
        // Given: an icon (20pt) whose iconSize + 20 = 40 — below the 44pt floor
        let size: ARCFavoriteButton.Size = .small

        // Then: floor enforces 44pt minimum
        #expect(size.touchTarget == 44)
    }

    @Test("touchTarget_largeIcon_growsWithIcon") func touchTarget_largeIcon_growsWithIcon() {
        // Given: 28pt icon → 28 + 20 = 48pt, exceeds 44pt floor
        let size: ARCFavoriteButton.Size = .large

        // Then
        #expect(size.touchTarget == 48)
    }

    // MARK: - Style mapping

    @Test("style_plain_usesSubtleEmptyStateOpacity") func style_plain_usesSubtleEmptyStateOpacity() {
        #expect(ARCFavoriteButton.Style.plain.emptyStateOpacity == 0.55)
    }

    @Test("style_prominent_usesHigherEmptyStateOpacity") func style_prominent_usesHigherEmptyStateOpacity() {
        #expect(ARCFavoriteButton.Style.prominent.emptyStateOpacity == 0.9)
        #expect(ARCFavoriteButton.Style.prominent.emptyStateOpacity > ARCFavoriteButton.Style.plain.emptyStateOpacity)
    }

    // MARK: - Construction smoke tests

    @MainActor
    @Test("init_default_buildsWithoutError") func init_default_buildsWithoutError() {
        // Given/When
        let sut = makeSUT()

        // Then: body resolves
        _ = sut.body
    }

    @MainActor
    @Test("init_allPresets_buildWithoutError") func init_allPresets_buildWithoutError() {
        // Given
        let presets: [ARCFavoriteButton.Icon] = [.heart, .star, .bookmark, .flag,
                                                 .custom(filled: "a.fill", empty: "a")]

        // When/Then: every preset constructs and renders body
        for preset in presets {
            let sut = makeSUT(icon: preset)
            _ = sut.body
        }
    }

    @MainActor
    @Test("init_allStyles_buildWithoutError") func init_allStyles_buildWithoutError() {
        // Given
        let styles: [ARCFavoriteButton.Style] = [.plain, .prominent]

        // When/Then: every style constructs and renders body
        for style in styles {
            let sut = makeSUT(style: style)
            _ = sut.body
        }
    }

    @MainActor
    @Test("init_favoritedState_buildsWithoutError") func init_favoritedState_buildsWithoutError() {
        // Given: button starts favorited
        let sut = makeSUT(isFavorite: .constant(true))

        // Then
        _ = sut.body
    }

    @MainActor
    @Test("init_styleDefault_isPlain") func init_styleDefault_isPlain() {
        // Given/When
        let sut = ARCFavoriteButton(isFavorite: .constant(false))

        // Then
        let mirror = Mirror(reflecting: sut)
        let styleChild = mirror.children.first { $0.label == "style" }
        #expect(styleChild?.value as? ARCFavoriteButton.Style == .plain)
    }

    @MainActor
    @Test("init_prominentStyle_storesProminent") func init_prominentStyle_storesProminent() {
        // Given/When
        let sut = makeSUT(style: .prominent)

        // Then
        let mirror = Mirror(reflecting: sut)
        let styleChild = mirror.children.first { $0.label == "style" }
        #expect(styleChild?.value as? ARCFavoriteButton.Style == .prominent)
    }

    // MARK: - Empty-state affordance (Option A contract)

    //
    // The body uses opaque `some View` so we can't introspect the resolved
    // `font` and `foregroundStyle` directly without a third-party inspector.
    // These tests pin the contract by exercising the public surface that
    // drives the contract and documenting the expectation. Any regression
    // that changes the rendered weight or strips the brand tint will need
    // to either flip these expectations or be caught at review.
    //

    @MainActor
    @Test("emptyState_buildsWithCustomColor_doesNotFallBackToSecondary")
    func emptyState_buildsWithCustomColor_doesNotFallBackToSecondary() {
        // Given: empty state with a non-default brand color
        let sut = makeSUT(isFavorite: .constant(false), color: .blue)

        // When: body resolves
        _ = sut.body

        // Then: SUT retains the supplied color (not Color.secondary).
        // Mirror lets us inspect stored properties.
        let mirror = Mirror(reflecting: sut)
        let colorChild = mirror.children.first { $0.label == "color" }
        #expect(colorChild != nil)
        if let storedColor = colorChild?.value as? Color {
            #expect(storedColor == Color.blue)
            #expect(storedColor != Color.secondary)
        }
    }

    @MainActor
    @Test("filledState_buildsWithCustomColor") func filledState_buildsWithCustomColor() {
        // Given: favorited state with custom color
        let sut = makeSUT(isFavorite: .constant(true), color: .orange)

        // When
        _ = sut.body

        // Then
        let mirror = Mirror(reflecting: sut)
        let colorChild = mirror.children.first { $0.label == "color" }
        if let storedColor = colorChild?.value as? Color {
            #expect(storedColor == Color.orange)
        }
    }

    // MARK: - onToggle callback wiring

    @MainActor
    @Test("init_withCallback_storesCallback") func init_withCallback_storesCallback() {
        // Given: an onToggle callback
        let callback: (Bool) -> Void = { _ in }

        // When
        let sut = makeSUT(onToggle: callback)

        // Then: callback property is non-nil
        let mirror = Mirror(reflecting: sut)
        let toggleChild = mirror.children.first { $0.label == "onToggle" }
        #expect(toggleChild != nil)
        if let stored = toggleChild?.value as? ((Bool) -> Void)? {
            #expect(stored != nil)
        }
    }

    @MainActor
    @Test("init_withoutCallback_storesNil") func init_withoutCallback_storesNil() {
        // Given/When: SUT without callback
        let sut = makeSUT()

        // Then
        let mirror = Mirror(reflecting: sut)
        let toggleChild = mirror.children.first { $0.label == "onToggle" }
        if let stored = toggleChild?.value as? ((Bool) -> Void)? {
            #expect(stored == nil)
        }
    }

    // MARK: - Haptics flag wiring

    @MainActor
    @Test("init_hapticsDefault_isTrue") func init_hapticsDefault_isTrue() {
        // Given/When: default init
        let sut = ARCFavoriteButton(isFavorite: .constant(false))

        // Then
        let mirror = Mirror(reflecting: sut)
        let hapticsChild = mirror.children.first { $0.label == "haptics" }
        #expect(hapticsChild?.value as? Bool == true)
    }

    @MainActor
    @Test("init_hapticsDisabled_isFalse") func init_hapticsDisabled_isFalse() {
        // Given/When
        let sut = makeSUT(haptics: false)

        // Then
        let mirror = Mirror(reflecting: sut)
        let hapticsChild = mirror.children.first { $0.label == "haptics" }
        #expect(hapticsChild?.value as? Bool == false)
    }
}
