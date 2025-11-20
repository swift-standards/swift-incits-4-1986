// Character+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for Character extension predicates

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

@Suite
struct `Character - ASCII Whitespace` {

    @Test(arguments: [" ", "\t", "\n", "\r"])
    func `whitespace characters are recognized`(char: Character) {
        #expect(char.ascii.isWhitespace)
    }

    @Test(arguments: ["a", "Z", "0", "!"])
    func `non-whitespace characters are not recognized`(char: Character) {
        #expect(!char.ascii.isWhitespace)
    }

    @Test
    func `all ASCII whitespace characters`() {
        let whitespace: [Character] = [
            " ",   // Space (0x20)
            "\t",  // Tab (0x09)
            "\n",  // Line Feed (0x0A)
            "\r"   // Carriage Return (0x0D)
        ]
        for char in whitespace {
            #expect(char.ascii.isWhitespace)
        }
    }
}

@Suite
struct `Character - ASCII Digits` {

    @Test(arguments: Array("0123456789"))
    func `digit characters are recognized`(char: Character) {
        #expect(char.ascii.isDigit)
    }

    @Test(arguments: ["a", "Z", " ", "!"])
    func `non-digit characters are not recognized`(char: Character) {
        #expect(!char.ascii.isDigit)
    }

    @Test
    func `all ASCII digits 0-9`() {
        for ascii in UInt8.ascii.0...UInt8.ascii.9 {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isDigit, "Character '\(char)' should be a digit")
        }
    }
}

@Suite
struct `Character - ASCII Letters` {

    @Test
    func `uppercase letters A-Z are recognized`() {
        for ascii in UInt8.ascii.A...UInt8.ascii.Z {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
        }
    }

    @Test
    func `lowercase letters a-z are recognized`() {
        for ascii in UInt8.ascii.a...UInt8.ascii.z {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
        }
    }

    @Test(arguments: ["0", "9", " ", "!", "@"])
    func `non-letter characters are not recognized`(char: Character) {
        #expect(!char.ascii.isLetter)
    }
}

@Suite
struct `Character - ASCII Alphanumeric` {

    @Test
    func `letters and digits are alphanumeric`() {
        let alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        for char in alphanumeric {
            #expect(char.ascii.isAlphanumeric, "Character '\(char)' should be alphanumeric")
        }
    }

    @Test(arguments: [" ", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "="])
    func `special characters are not alphanumeric`(char: Character) {
        #expect(!char.ascii.isAlphanumeric)
    }
}

@Suite
struct `Character - ASCII Hex Digits` {

    @Test
    func `hex digits 0-9 are recognized`() {
        for char in "0123456789" {
            #expect(char.ascii.isHexDigit)
        }
    }

    @Test
    func `hex digits A-F uppercase are recognized`() {
        for char in "ABCDEF" {
            #expect(char.ascii.isHexDigit)
        }
    }

    @Test
    func `hex digits a-f lowercase are recognized`() {
        for char in "abcdef" {
            #expect(char.ascii.isHexDigit)
        }
    }

    @Test(arguments: ["G", "g", "Z", "z", " ", "!", "@"])
    func `non-hex characters are not recognized`(char: Character) {
        #expect(!char.ascii.isHexDigit)
    }

    @Test
    func `all valid hex characters`() {
        let hexChars = "0123456789ABCDEFabcdef"
        for char in hexChars {
            #expect(char.ascii.isHexDigit, "Character '\(char)' should be a hex digit")
        }
    }
}

@Suite
struct `Character - ASCII Case` {

    @Test
    func `uppercase letters A-Z are recognized`() {
        for ascii in UInt8.ascii.A...UInt8.ascii.Z {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
            #expect(!char.ascii.isLowercase, "Character '\(char)' should not be lowercase")
        }
    }

    @Test
    func `lowercase letters a-z are recognized`() {
        for ascii in UInt8.ascii.a...UInt8.ascii.z {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
            #expect(!char.ascii.isUppercase, "Character '\(char)' should not be uppercase")
        }
    }

    @Test(arguments: ["0", "9", " ", "!", "@", "#"])
    func `non-letter characters are neither uppercase nor lowercase`(char: Character) {
        #expect(!char.ascii.isUppercase)
        #expect(!char.ascii.isLowercase)
    }
}

extension `Performance Tests` {
    @Suite
    struct `Character - Performance` {

        @Test(.timed(threshold: .milliseconds(10), maxAllocations: 1_000_000))
        func `character whitespace check 1M times`() {
            let char: Character = " "
            for _ in 0..<1_000_000 {
                _ = char.ascii.isWhitespace
            }
        }

        @Test(.timed(threshold: .milliseconds(10), maxAllocations: 1_000_000))
        func `character digit check 1M times`() {
            let char: Character = "5"
            for _ in 0..<1_000_000 {
                _ = char.ascii.isDigit
            }
        }

        @Test(.timed(threshold: .milliseconds(10), maxAllocations: 1_000_000))
        func `character letter check 1M times`() {
            let char: Character = "A"
            for _ in 0..<1_000_000 {
                _ = char.ascii.isLetter
            }
        }
    }
}
