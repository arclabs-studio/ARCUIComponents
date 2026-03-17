//
//  ARCTextFieldValidationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import Testing
@testable import ARCUIComponents

// MARK: - Validation Mode Tests

@Suite("ARCTextFieldValidation Tests") struct ARCTextFieldValidationTests {
    // MARK: - SUT

    private typealias Validation = ARCTextFieldValidation

    private func makeSUT(rules: [Validation.ValidationRule],
                         mode: Validation.ValidationMode = .all) -> ARCTextFieldValidation {
        ARCTextFieldValidation(rules: rules, mode: mode)
    }

    // MARK: - validate() with .all mode

    @Test("validate_allMode_allRulesPass_returnsNil") func validate_allMode_allRulesPass_returnsNil() {
        let sut = makeSUT(rules: [Validation.required(),
                                  Validation.minLength(3)])

        #expect(sut.validate("hello") == nil)
    }

    @Test("validate_allMode_firstRuleFails_returnsFirstError")
    func validate_allMode_firstRuleFails_returnsFirstError() {
        let sut = makeSUT(rules: [Validation.required("Required"),
                                  Validation.minLength(3, message: "Too short")])

        #expect(sut.validate("") == "Required")
    }

    @Test("validate_allMode_secondRuleFails_returnsSecondError")
    func validate_allMode_secondRuleFails_returnsSecondError() {
        let sut = makeSUT(rules: [Validation.required("Required"),
                                  Validation.minLength(5, message: "Too short")])

        #expect(sut.validate("hi") == "Too short")
    }

    // MARK: - validate() with .any mode

    @Test("validate_anyMode_oneRulePasses_returnsNil") func validate_anyMode_oneRulePasses_returnsNil() {
        let sut = makeSUT(rules: [Validation.minLength(10, message: "Too short"),
                                  Validation.email("Invalid email")],
                          mode: .any)

        // "test@a.co" is 9 chars (fails minLength 10) but passes email
        #expect(sut.validate("test@a.co") == nil)
    }

    @Test("validate_anyMode_noRulesPass_returnsFirstError") func validate_anyMode_noRulesPass_returnsFirstError() {
        let sut = makeSUT(rules: [Validation.minLength(10, message: "Too short"),
                                  Validation.containsDigit("Needs digit")],
                          mode: .any)

        #expect(sut.validate("hi") == "Too short")
    }

    // MARK: - isValid()

    @Test("isValid_validInput_returnsTrue") func isValid_validInput_returnsTrue() {
        let sut = makeSUT(rules: [Validation.required()])

        #expect(sut.isValid("hello") == true)
    }

    @Test("isValid_invalidInput_returnsFalse") func isValid_invalidInput_returnsFalse() {
        let sut = makeSUT(rules: [Validation.required()])

        #expect(sut.isValid("") == false)
    }

    // MARK: - Built-in Rules: required

    @Test("required_nonEmptyString_passes") func required_nonEmptyString_passes() {
        let rule = ARCTextFieldValidation.required()

        #expect(rule.validate("hello") == true)
    }

    @Test("required_emptyString_fails") func required_emptyString_fails() {
        let rule = ARCTextFieldValidation.required()

        #expect(rule.validate("") == false)
    }

    @Test("required_whitespaceOnly_fails") func required_whitespaceOnly_fails() {
        let rule = ARCTextFieldValidation.required()

        #expect(rule.validate("   ") == false)
    }

    // MARK: - Built-in Rules: minLength

    @Test("minLength_atMinimum_passes") func minLength_atMinimum_passes() {
        let rule = ARCTextFieldValidation.minLength(3)

        #expect(rule.validate("abc") == true)
    }

    @Test("minLength_belowMinimum_fails") func minLength_belowMinimum_fails() {
        let rule = ARCTextFieldValidation.minLength(3)

        #expect(rule.validate("ab") == false)
    }

    // MARK: - Built-in Rules: maxLength

    @Test("maxLength_atMaximum_passes") func maxLength_atMaximum_passes() {
        let rule = ARCTextFieldValidation.maxLength(5)

        #expect(rule.validate("abcde") == true)
    }

    @Test("maxLength_aboveMaximum_fails") func maxLength_aboveMaximum_fails() {
        let rule = ARCTextFieldValidation.maxLength(5)

        #expect(rule.validate("abcdef") == false)
    }

    // MARK: - Built-in Rules: email

    @Test("email_validEmail_passes") func email_validEmail_passes() {
        let rule = ARCTextFieldValidation.email()

        #expect(rule.validate("user@example.com") == true)
    }

    @Test("email_invalidEmail_fails") func email_invalidEmail_fails() {
        let rule = ARCTextFieldValidation.email()

        #expect(rule.validate("notanemail") == false)
    }

    @Test("email_emptyString_passes") func email_emptyString_passes() {
        // email rule allows empty (use required + email for mandatory)
        let rule = ARCTextFieldValidation.email()

        #expect(rule.validate("") == true)
    }

    // MARK: - Built-in Rules: regex

    @Test("regex_matchingPattern_passes") func regex_matchingPattern_passes() {
        let rule = ARCTextFieldValidation.regex("^[a-z]+$", message: "Lowercase only")

        #expect(rule.validate("abc") == true)
    }

    @Test("regex_nonMatchingPattern_fails") func regex_nonMatchingPattern_fails() {
        let rule = ARCTextFieldValidation.regex("^[a-z]+$", message: "Lowercase only")

        #expect(rule.validate("ABC") == false)
    }

    @Test("regex_emptyString_passes") func regex_emptyString_passes() {
        let rule = ARCTextFieldValidation.regex("^[a-z]+$", message: "Lowercase only")

        #expect(rule.validate("") == true)
    }

    // MARK: - Built-in Rules: phone

    @Test("phone_validPhone_passes") func phone_validPhone_passes() {
        let rule = ARCTextFieldValidation.phone()

        #expect(rule.validate("+1 (555) 123-4567") == true)
    }

    @Test("phone_tooShort_fails") func phone_tooShort_fails() {
        let rule = ARCTextFieldValidation.phone()

        #expect(rule.validate("12345") == false)
    }

    @Test("phone_emptyString_passes") func phone_emptyString_passes() {
        let rule = ARCTextFieldValidation.phone()

        #expect(rule.validate("") == true)
    }

    // MARK: - Built-in Rules: url

    @Test("url_validURL_passes") func url_validURL_passes() {
        let rule = ARCTextFieldValidation.url()

        #expect(rule.validate("https://example.com") == true)
    }

    @Test("url_invalidURL_fails") func url_invalidURL_fails() {
        let rule = ARCTextFieldValidation.url()

        #expect(rule.validate("not a url") == false)
    }

    @Test("url_emptyString_passes") func url_emptyString_passes() {
        let rule = ARCTextFieldValidation.url()

        #expect(rule.validate("") == true)
    }

    // MARK: - Character Rules

    @Test("containsUppercase_withUppercase_passes") func containsUppercase_withUppercase_passes() {
        let rule = ARCTextFieldValidation.containsUppercase()

        #expect(rule.validate("Hello") == true)
    }

    @Test("containsUppercase_withoutUppercase_fails") func containsUppercase_withoutUppercase_fails() {
        let rule = ARCTextFieldValidation.containsUppercase()

        #expect(rule.validate("hello") == false)
    }

    @Test("containsLowercase_withLowercase_passes") func containsLowercase_withLowercase_passes() {
        let rule = ARCTextFieldValidation.containsLowercase()

        #expect(rule.validate("Hello") == true)
    }

    @Test("containsLowercase_withoutLowercase_fails") func containsLowercase_withoutLowercase_fails() {
        let rule = ARCTextFieldValidation.containsLowercase()

        #expect(rule.validate("HELLO") == false)
    }

    @Test("containsDigit_withDigit_passes") func containsDigit_withDigit_passes() {
        let rule = ARCTextFieldValidation.containsDigit()

        #expect(rule.validate("abc1") == true)
    }

    @Test("containsDigit_withoutDigit_fails") func containsDigit_withoutDigit_fails() {
        let rule = ARCTextFieldValidation.containsDigit()

        #expect(rule.validate("abc") == false)
    }

    @Test("containsSpecialCharacter_withSpecial_passes") func containsSpecialCharacter_withSpecial_passes() {
        let rule = ARCTextFieldValidation.containsSpecialCharacter()

        #expect(rule.validate("abc!") == true)
    }

    @Test("containsSpecialCharacter_withoutSpecial_fails") func containsSpecialCharacter_withoutSpecial_fails() {
        let rule = ARCTextFieldValidation.containsSpecialCharacter()

        #expect(rule.validate("abc123") == false)
    }

    // MARK: - Custom Rule

    @Test("custom_passingRule_passes") func custom_passingRule_passes() {
        let rule = ARCTextFieldValidation.custom({ $0 == "magic" }, message: "Not magic")

        #expect(rule.validate("magic") == true)
    }

    @Test("custom_failingRule_fails") func custom_failingRule_fails() {
        let rule = ARCTextFieldValidation.custom({ $0 == "magic" }, message: "Not magic")

        #expect(rule.validate("other") == false)
    }

    // MARK: - Preset Tests

    @Test("emailPreset_validEmail_isValid") func emailPreset_validEmail_isValid() {
        let sut = ARCTextFieldValidation.email

        #expect(sut.isValid("user@example.com") == true)
    }

    @Test("emailPreset_emptyString_isInvalid") func emailPreset_emptyString_isInvalid() {
        let sut = ARCTextFieldValidation.email

        #expect(sut.isValid("") == false)
    }

    @Test("passwordPreset_validPassword_isValid") func passwordPreset_validPassword_isValid() {
        let sut = ARCTextFieldValidation.password

        #expect(sut.isValid("password1") == true)
    }

    @Test("passwordPreset_tooShort_isInvalid") func passwordPreset_tooShort_isInvalid() {
        let sut = ARCTextFieldValidation.password

        #expect(sut.isValid("pass1") == false)
    }

    @Test("passwordPreset_noDigit_isInvalid") func passwordPreset_noDigit_isInvalid() {
        let sut = ARCTextFieldValidation.password

        #expect(sut.isValid("password") == false)
    }

    @Test("strongPasswordPreset_validStrongPassword_isValid") func strongPasswordPreset_validStrongPassword_isValid() {
        let sut = ARCTextFieldValidation.strongPassword

        #expect(sut.isValid("P@ssw0rd") == true)
    }

    @Test("strongPasswordPreset_noSpecialChar_isInvalid") func strongPasswordPreset_noSpecialChar_isInvalid() {
        let sut = ARCTextFieldValidation.strongPassword

        #expect(sut.isValid("Passw0rd") == false)
    }

    @Test("requiredPreset_nonEmpty_isValid") func requiredPreset_nonEmpty_isValid() {
        let sut = ARCTextFieldValidation.required

        #expect(sut.isValid("hello") == true)
    }

    @Test("requiredPreset_empty_isInvalid") func requiredPreset_empty_isInvalid() {
        let sut = ARCTextFieldValidation.required

        #expect(sut.isValid("") == false)
    }

    @Test("usernamePreset_validUsername_isValid") func usernamePreset_validUsername_isValid() {
        let sut = ARCTextFieldValidation.username

        #expect(sut.isValid("user_123") == true)
    }

    @Test("usernamePreset_tooShort_isInvalid") func usernamePreset_tooShort_isInvalid() {
        let sut = ARCTextFieldValidation.username

        #expect(sut.isValid("ab") == false)
    }

    @Test("usernamePreset_specialChars_isInvalid") func usernamePreset_specialChars_isInvalid() {
        let sut = ARCTextFieldValidation.username

        #expect(sut.isValid("user@name") == false)
    }

    @Test("phoneNumberPreset_validPhone_isValid") func phoneNumberPreset_validPhone_isValid() {
        let sut = ARCTextFieldValidation.phoneNumber

        #expect(sut.isValid("5551234567") == true)
    }

    @Test("phoneNumberPreset_empty_isInvalid") func phoneNumberPreset_empty_isInvalid() {
        let sut = ARCTextFieldValidation.phoneNumber

        #expect(sut.isValid("") == false)
    }

    @Test("urlPreset_validURL_isValid") func urlPreset_validURL_isValid() {
        let sut = ARCTextFieldValidation.urlValidation

        #expect(sut.isValid("https://example.com") == true)
    }

    @Test("urlPreset_empty_isInvalid") func urlPreset_empty_isInvalid() {
        let sut = ARCTextFieldValidation.urlValidation

        #expect(sut.isValid("") == false)
    }
}
