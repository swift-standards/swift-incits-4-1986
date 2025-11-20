// INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for module-level INCITS_4_1986 namespace

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

// MARK: - Module Constants

@Suite
struct `INCITS_4_1986 - Constants` {

    @Test
    func `whitespaces set contains exactly 4 characters`() {
        #expect(INCITS_4_1986.whitespaces.count == 4)
    }

    @Test
    func `whitespaces contains SPACE, TAB, LF, CR`() {
        #expect(INCITS_4_1986.whitespaces.contains(0x20)) // SPACE
        #expect(INCITS_4_1986.whitespaces.contains(0x09)) // HT
        #expect(INCITS_4_1986.whitespaces.contains(0x0A)) // LF
        #expect(INCITS_4_1986.whitespaces.contains(0x0D)) // CR
    }

    @Test
    func `CRLF sequence is correct`() {
        #expect(INCITS_4_1986.crlf == [0x0D, 0x0A])
    }

    @Test
    func `case conversion offset is 0x20`() {
        #expect(INCITS_4_1986.caseConversionOffset == 0x20)
        #expect(INCITS_4_1986.caseConversionOffset == 32)
    }

    @Test
    func `case conversion offset matches letter distance`() {
        let a = UInt8.ascii.a
        let A = UInt8.ascii.A
        #expect(a - A == INCITS_4_1986.caseConversionOffset)
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `INCITS_4_1986 - Performance` {

        @Test(.timed(threshold: .milliseconds(1), maxAllocations: 1_000_000))
        func `whitespaces set lookup 1M times`() {
            let testBytes: [UInt8] = [0x20, 0x41, 0x09, 0x61]
            for _ in 0..<250_000 {
                for byte in testBytes {
                    _ = INCITS_4_1986.whitespaces.contains(byte)
                }
            }
        }
    }
}
