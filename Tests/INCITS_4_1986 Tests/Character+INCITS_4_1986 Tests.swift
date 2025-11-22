// Character+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for Character extension predicates

import StandardsTestSupport
import Testing

@testable import INCITS_4_1986

@Suite
struct `Character Tests` {
    
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
    }
    
    @Suite
    struct `Character - ASCII Letters` {
        
        @Test(arguments: Array(UInt8.ascii.A...UInt8.ascii.Z))
        func `uppercase letters A-Z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
        }
        
        @Test(arguments: Array(UInt8.ascii.a...UInt8.ascii.z))
        func `lowercase letters a-z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
        }
        
        @Test(arguments: ["0", "9", " ", "!", "@"])
        func `non-letter characters are not recognized`(char: Character) {
            #expect(!char.ascii.isLetter)
        }
    }
    
    @Suite
    struct `Character - ASCII Alphanumeric` {
        
        @Test(arguments: Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
        func `letters and digits are alphanumeric`(char: Character) {
            #expect(char.ascii.isAlphanumeric, "Character '\(char)' should be alphanumeric")
        }
        
        @Test(arguments: [" ", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "="])
        func `special characters are not alphanumeric`(char: Character) {
            #expect(!char.ascii.isAlphanumeric)
        }
    }
    
    @Suite
    struct `Character - ASCII Hex Digits` {
        
        @Test(arguments: Array("0123456789ABCDEFabcdef"))
        func `all valid hex characters`(char: Character) {
            #expect(char.ascii.isHexDigit, "Character '\(char)' should be a hex digit")
        }
        
        @Test(arguments: ["G", "g", "Z", "z", " ", "!", "@"])
        func `non-hex characters are not recognized`(char: Character) {
            #expect(!char.ascii.isHexDigit)
        }
    }
    
    @Suite
    struct `Character - ASCII Case` {
        
        @Test(arguments: Array(UInt8.ascii.A...UInt8.ascii.Z))
        func `uppercase letters A-Z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
            #expect(!char.ascii.isLowercase, "Character '\(char)' should not be lowercase")
        }
        
        @Test(arguments: Array(UInt8.ascii.a...UInt8.ascii.z))
        func `lowercase letters a-z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
            #expect(!char.ascii.isUppercase, "Character '\(char)' should not be uppercase")
        }
        
        @Test(arguments: ["0", "9", " ", "!", "@", "#"])
        func `non-letter characters are neither uppercase nor lowercase`(char: Character) {
            #expect(!char.ascii.isUppercase)
            #expect(!char.ascii.isLowercase)
        }
    }
}

extension `Performance Tests` {
    @Suite
    struct `Character - Performance` {

        @Test(.timed(threshold: .milliseconds(2000)))
        func `character whitespace check 1M times`() {
            let char: Character = " "
            for _ in 0..<1_000_000 {
                _ = char.ascii.isWhitespace
            }
        }

        @Test(.timed(threshold: .milliseconds(2000)))
        func `character digit check 1M times`() {
            let char: Character = "5"
            for _ in 0..<1_000_000 {
                _ = char.ascii.isDigit
            }
        }

        @Test(.timed(threshold: .milliseconds(2000)))
        func `character letter check 1M times`() {
            let char: Character = "A"
            for _ in 0..<1_000_000 {
                _ = char.ascii.isLetter
            }
        }
    }
}
