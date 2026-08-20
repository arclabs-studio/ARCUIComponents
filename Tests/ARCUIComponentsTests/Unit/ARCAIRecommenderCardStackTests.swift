//
//  ARCAIRecommenderCardStackTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/17/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

// MARK: - Mock Item

private struct MockCardItem: AIRecommenderItem {
    let id: UUID
    let title: String
    var subtitle: String?
    var rating: Double?
    var imageSource: AIRecommenderImageSource?
    var aiReason: String?
    var location: String?
    var highlightDetail: String?
}

// MARK: - Configuration Tests

@Suite("ARCAIRecommenderConfiguration Card Stack Tests")
struct ARCAIRecommenderCardStackConfigurationTests {
    @Test("default_preset_enablesCardStack") func default_preset_enablesCardStack() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.useCardStack == true)
    }

    @Test("list_preset_disablesCardStack") func list_preset_disablesCardStack() {
        let config = ARCAIRecommenderConfiguration.list

        #expect(config.useCardStack == false)
    }

    @Test("default_hasCorrectCardStackDepth") func default_hasCorrectCardStackDepth() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.cardStackDepth == 3)
    }

    @Test("default_hasCorrectSwipeThreshold") func default_hasCorrectSwipeThreshold() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.swipeThreshold == 0.3)
    }

    @Test("default_hasCorrectMaxSwipeRotation") func default_hasCorrectMaxSwipeRotation() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.maxSwipeRotation == 8.0)
    }

    @Test("default_showsCardIndicator") func default_showsCardIndicator() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.showCardIndicator == true)
    }

    @Test("default_hasCorrectBookmarkIcons") func default_hasCorrectBookmarkIcons() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.bookmarkIcon == "bookmark")
        #expect(config.bookmarkActiveIcon == "bookmark.fill")
    }

    @Test("default_hasAllViewedText") func default_hasAllViewedText() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(!config.allViewedText.isEmpty)
    }

    @Test("init_withCustomSwipeThreshold_setsCorrectly") func init_withCustomSwipeThreshold_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(swipeThreshold: 0.5)

        #expect(config.swipeThreshold == 0.5)
    }

    @Test("init_withCustomCardStackDepth_setsCorrectly") func init_withCustomCardStackDepth_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(cardStackDepth: 5)

        #expect(config.cardStackDepth == 5)
    }

    @Test("init_withCustomBookmarkIcons_setsCorrectly") func init_withCustomBookmarkIcons_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(bookmarkIcon: "heart",
                                                   bookmarkActiveIcon: "heart.fill")

        #expect(config.bookmarkIcon == "heart")
        #expect(config.bookmarkActiveIcon == "heart.fill")
    }

    @Test("minimal_preset_enablesCardStack") func minimal_preset_enablesCardStack() {
        let config = ARCAIRecommenderConfiguration.minimal

        #expect(config.useCardStack == true)
    }

    @Test("compact_preset_enablesCardStack") func compact_preset_enablesCardStack() {
        let config = ARCAIRecommenderConfiguration.compact

        #expect(config.useCardStack == true)
    }

    // MARK: - Peek Carousel Configuration Defaults

    @Test("default_hasCorrectPeekFraction") func default_hasCorrectPeekFraction() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.peekFraction == 0.85)
    }

    @Test("default_hasCorrectAdjacentCardScale") func default_hasCorrectAdjacentCardScale() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.adjacentCardScale == 0.95)
    }

    @Test("default_hasCorrectAdjacentCardOpacity") func default_hasCorrectAdjacentCardOpacity() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.adjacentCardOpacity == 0.85)
    }

    @Test("default_hasCorrectCardSpacing") func default_hasCorrectCardSpacing() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.cardSpacing == 12)
    }

    @Test("init_withCustomPeekFraction_setsCorrectly") func init_withCustomPeekFraction_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(peekFraction: 0.9)

        #expect(config.peekFraction == 0.9)
    }

    @Test("init_withCustomAdjacentCardScale_setsCorrectly") func init_withCustomAdjacentCardScale_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(adjacentCardScale: 0.9)

        #expect(config.adjacentCardScale == 0.9)
    }

    @Test("init_withCustomAdjacentCardOpacity_setsCorrectly") func init_withCustomAdjacentCardOpacity_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(adjacentCardOpacity: 0.7)

        #expect(config.adjacentCardOpacity == 0.7)
    }

    @Test("init_withCustomCardSpacing_setsCorrectly") func init_withCustomCardSpacing_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(cardSpacing: 8)

        #expect(config.cardSpacing == 8)
    }

    // MARK: - Card Content Visibility Defaults

    @Test("default_showsAllCardContent") func default_showsAllCardContent() {
        let config = ARCAIRecommenderConfiguration.default

        #expect(config.showTags == true)
        #expect(config.showLocation == true)
        #expect(config.showHighlightDetail == true)
    }

    @Test("init_withHiddenTags_setsCorrectly") func init_withHiddenTags_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(showTags: false)

        #expect(config.showTags == false)
    }

    @Test("init_withHiddenLocation_setsCorrectly") func init_withHiddenLocation_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(showLocation: false)

        #expect(config.showLocation == false)
    }

    @Test("init_withHiddenHighlightDetail_setsCorrectly") func init_withHiddenHighlightDetail_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(showHighlightDetail: false)

        #expect(config.showHighlightDetail == false)
    }

    @Test("init_withMultipleHiddenSections_setsCorrectly") func init_withMultipleHiddenSections_setsCorrectly() {
        let config = ARCAIRecommenderConfiguration(showTags: false,
                                                   showLocation: false,
                                                   showHighlightDetail: false)

        #expect(config.showTags == false)
        #expect(config.showLocation == false)
        #expect(config.showHighlightDetail == false)
    }
}

// MARK: - Protocol Extension Tests

@Suite("AIRecommenderItem Protocol Extension Tests")
struct AIRecommenderItemProtocolTests {
    @Test("defaultImplementation_location_returnsNil") func defaultImplementation_location_returnsNil() {
        struct MinimalItem: AIRecommenderItem {
            let id: UUID
            let title: String
        }

        let item = MinimalItem(id: UUID(), title: "Test")

        #expect(item.location == nil)
    }

    @Test("defaultImplementation_highlightDetail_returnsNil") func defaultImplementation_highlightDetail_returnsNil() {
        struct MinimalItem: AIRecommenderItem {
            let id: UUID
            let title: String
        }

        let item = MinimalItem(id: UUID(), title: "Test")

        #expect(item.highlightDetail == nil)
    }

    @Test("customImplementation_location_returnsValue") func customImplementation_location_returnsValue() {
        let item = MockCardItem(id: UUID(),
                                title: "Test",
                                location: "Centro, Madrid")

        #expect(item.location == "Centro, Madrid")
    }

    @Test("customImplementation_highlightDetail_returnsValue")
    func customImplementation_highlightDetail_returnsValue() {
        let item = MockCardItem(id: UUID(),
                                title: "Test",
                                highlightDetail: "Pasta Carbonara")

        #expect(item.highlightDetail == "Pasta Carbonara")
    }
}

// MARK: - Image Source Hero View Tests

@Suite("AIRecommenderImageSource Hero View Tests")
struct AIRecommenderImageSourceHeroTests {
    @Test("system_imageSource_createsHeroView") func system_imageSource_createsHeroView() {
        let source = AIRecommenderImageSource.system("fork.knife", color: .orange)

        // Verify hero view can be constructed without crash
        _ = source.heroImageView(height: 200)
    }

    @Test("placeholder_imageSource_createsHeroView") func placeholder_imageSource_createsHeroView() {
        let source = AIRecommenderImageSource.placeholder(text: "LT", colors: [.orange, .red])

        _ = source.heroImageView(height: 180)
    }

    @Test("url_imageSource_createsHeroView") func url_imageSource_createsHeroView() throws {
        let source = try AIRecommenderImageSource.url(#require(URL(string: "https://example.com/image.jpg")))

        _ = source.heroImageView(height: 200)
    }

    @Test("image_imageSource_createsHeroView") func image_imageSource_createsHeroView() {
        let source = AIRecommenderImageSource.image("test-image")

        _ = source.heroImageView(height: 200)
    }
}
