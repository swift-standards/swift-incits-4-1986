// INCITS_4_1986.GraphicCharacters Tests.swift
// swift-incits-4-1986
//
// Tests for INCITS_4_1986.GraphicCharacters (94 characters: 0x21-0x7E)

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

@Suite
struct `Graphic Characters - Digits` {

    @Test
    func `all digits 0-9 accessible`() {
        #expect(UInt8.ascii.0 == 0x30)
        #expect(UInt8.ascii.1 == 0x31)
        #expect(UInt8.ascii.9 == 0x39)
    }

    @Test(arguments: Array(0...9))
    func `digit constants correct`(digit: Int) {
        let char = Character("\(digit)")
        let byte = UInt8.ascii(char)!
        #expect(byte == 0x30 + UInt8(digit))
    }
}

@Suite
struct `Graphic Characters - Letters` {

    @Test
    func `uppercase letters accessible`() {
        #expect(UInt8.ascii.A == 0x41)
        #expect(UInt8.ascii.Z == 0x5A)
    }

    @Test
    func `lowercase letters accessible`() {
        #expect(UInt8.ascii.a == 0x61)
        #expect(UInt8.ascii.z == 0x7A)
    }

    @Test
    func `all 52 letters present`() {
        // Uppercase A-Z
        for (char, expected) in zip("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0x41...0x5A) {
            let byte = UInt8.ascii(char)!
            #expect(byte == expected)
        }
        // Lowercase a-z
        for (char, expected) in zip("abcdefghijklmnopqrstuvwxyz", 0x61...0x7A) {
            let byte = UInt8.ascii(char)!
            #expect(byte == expected)
        }
    }
}

@Suite
struct `Graphic Characters - Punctuation` {

    @Test
    func `common punctuation accessible`() {
        #expect(UInt8.ascii.exclamationPoint == 0x21)
        #expect(UInt8.ascii.period == 0x2E)
        #expect(UInt8.ascii.comma == 0x2C)
        #expect(UInt8.ascii.questionMark == 0x3F)
    }

    @Test
    func `brackets and parentheses accessible`() {
        #expect(UInt8.ascii.leftParenthesis == 0x28)
        #expect(UInt8.ascii.rightParenthesis == 0x29)
        #expect(UInt8.ascii.leftBracket == 0x5B)
        #expect(UInt8.ascii.rightBracket == 0x5D)
    }
}

extension `Performance Tests` {
    @Suite
    struct `Graphic Characters - Performance` {

        @Test(.timed(threshold: .microseconds(500), maxAllocations: 100_000))
        func `graphic character access 100K times`() {
            for _ in 0..<100_000 {
                _ = UInt8.ascii.A
                _ = UInt8.ascii.0
                _ = UInt8.ascii.period
            }
        }
    }
}
