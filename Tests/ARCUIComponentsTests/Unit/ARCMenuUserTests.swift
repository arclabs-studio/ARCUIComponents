//
//  ARCMenuUserTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import Foundation
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuUser
///
/// Tests cover initialization and avatar image types.
@Suite("ARCMenuUser Tests")
struct ARCMenuUserTests {
    // MARK: - Initialization Tests

    @Test("init_withRequiredParameters_createsUser")
    func init_withRequiredParameters_createsUser() {
        let user = ARCMenuUser(
            name: "Test User",
            avatarImage: .initials("TU")
        )

        #expect(user.name == "Test User")
        #expect(user.email == nil)
        #expect(user.subtitle == nil)
    }

    @Test("init_withAllParameters_createsUserCorrectly")
    func init_withAllParameters_createsUserCorrectly() {
        let user = ARCMenuUser(
            name: "Full User",
            email: "full@example.com",
            subtitle: "Premium Member",
            avatarImage: .initials("FU")
        )

        #expect(user.name == "Full User")
        #expect(user.email == "full@example.com")
        #expect(user.subtitle == "Premium Member")
    }

    @Test("init_generatesUniqueId")
    func init_generatesUniqueId() {
        let user1 = ARCMenuUser(name: "User 1", avatarImage: .initials("U1"))
        let user2 = ARCMenuUser(name: "User 2", avatarImage: .initials("U2"))

        #expect(user1.id != user2.id)
    }

    @Test("init_withCustomId_usesProvidedId")
    func init_withCustomId_usesProvidedId() {
        let customId = UUID()
        let user = ARCMenuUser(
            id: customId,
            name: "Test",
            avatarImage: .initials("T")
        )

        #expect(user.id == customId)
    }

    @Test("init_withEmptyName_createsUserWithEmptyName")
    func init_withEmptyName_createsUserWithEmptyName() {
        let user = ARCMenuUser(
            name: "",
            avatarImage: .initials("")
        )

        #expect(user.name.isEmpty)
    }

    // MARK: - Identifiable Conformance Tests

    @Test("conformsToIdentifiable_hasValidId")
    func conformsToIdentifiable_hasValidId() {
        let user = ARCMenuUser(
            name: "Test",
            avatarImage: .initials("T")
        )

        // Verify id is a valid UUID
        #expect(user.id.uuidString.isEmpty == false)
    }

    // MARK: - Sendable Conformance Tests

    @Test("conformsToSendable_canBeSentAcrossBoundaries")
    func conformsToSendable_canBeSentAcrossBoundaries() async {
        let user = ARCMenuUser(
            name: "Sendable Test",
            avatarImage: .initials("ST")
        )

        let result = await Task.detached {
            user.name
        }.value

        #expect(result == "Sendable Test")
    }
}

// MARK: - ARCMenuUserImage Tests

@Suite("ARCMenuUserImage Tests")
struct ARCMenuUserImageTests {
    @Test("systemImage_createsCorrectType")
    func systemImage_createsCorrectType() {
        let image = ARCMenuUserImage.systemImage("person.circle.fill")

        if case let .systemImage(name) = image {
            #expect(name == "person.circle.fill")
        } else {
            #expect(Bool(false), "Expected systemImage type")
        }
    }

    @Test("imageName_createsCorrectType")
    func imageName_createsCorrectType() {
        let image = ARCMenuUserImage.imageName("custom-avatar")

        if case let .imageName(name) = image {
            #expect(name == "custom-avatar")
        } else {
            #expect(Bool(false), "Expected imageName type")
        }
    }

    @Test("url_createsCorrectType")
    func url_createsCorrectType() {
        guard let testURL = URL(string: "https://example.com/avatar.png") else {
            #expect(Bool(false), "Failed to create test URL")
            return
        }
        let image = ARCMenuUserImage.url(testURL)

        if case let .url(url) = image {
            #expect(url == testURL)
        } else {
            #expect(Bool(false), "Expected url type")
        }
    }

    @Test("initials_createsCorrectType")
    func initials_createsCorrectType() {
        let image = ARCMenuUserImage.initials("AB")

        if case let .initials(text) = image {
            #expect(text == "AB")
        } else {
            #expect(Bool(false), "Expected initials type")
        }
    }

    @Test("initials_withEmptyString_createsEmptyInitials")
    func initials_withEmptyString_createsEmptyInitials() {
        let image = ARCMenuUserImage.initials("")

        if case let .initials(text) = image {
            #expect(text.isEmpty)
        } else {
            #expect(Bool(false), "Expected initials type")
        }
    }

    @Test("initials_withLongString_preservesFullString")
    func initials_withLongString_preservesFullString() {
        let image = ARCMenuUserImage.initials("ABCD")

        if case let .initials(text) = image {
            #expect(text == "ABCD")
        } else {
            #expect(Bool(false), "Expected initials type")
        }
    }
}
