// [UInt8]+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for [UInt8] array extension methods

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

// Note: [UInt8] validation tests are in INCITS_4_1986.Validation Tests.swift
// Note: [UInt8] case conversion tests are in INCITS_4_1986.CaseConversion Tests.swift
// Note: [UInt8] line ending tests are in String.LineEnding+INCITS_4_1986 Tests.swift

@Suite
struct `[UInt8] - API Surface` {

    @Test
    func `byte array has validation method`() {
        let ascii: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(ascii.ascii.isAllASCII)

        let nonAscii: [UInt8] = [0x48, 0xFF]
        #expect(!nonAscii.ascii.isAllASCII)
    }

    @Test
    func `byte array has case conversion method`() {
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F] // "Hello"
        let upper = bytes.ascii.convertingCase(to: .upper)
        #expect(upper == [0x48, 0x45, 0x4C, 0x4C, 0x4F]) // "HELLO"
    }

    @Test
    func `byte array has line ending conversion`() {
        let lf = [UInt8].ascii(lineEnding: .lf)
        #expect(lf == [0x0A])

        let crlf = [UInt8].ascii(lineEnding: .crlf)
        #expect(crlf == [0x0D, 0x0A])
    }

    @Test
    func `byte array has string conversion`() {
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect([UInt8].ascii("Hello") == bytes)
    }

    @Test
    func `byte array has whitespaces constant`() {
        let ws = [UInt8].ascii.whitespaces
        #expect(ws.contains(0x20)) // Space
        #expect(ws.contains(0x09)) // Tab
        #expect(ws.contains(0x0A)) // LF
        #expect(ws.contains(0x0D)) // CR
    }
}

extension `Performance Tests` {
    @Suite
    struct `[UInt8] - Performance` {

        @Test(.timed(threshold: .milliseconds(150), maxAllocations: 1_000_000))
        func `byte array string conversion 10K times`() {
            for _ in 0..<10_000 {
                _ = [UInt8].ascii("Hello World!")
            }
        }

        @Test(.timed(threshold: .milliseconds(2000), maxAllocations: 1_000_000))
        func `byte array case conversion 10K arrays`() {
            let bytes: [UInt8] = Array(repeating: 0x41, count: 100) // "AAA..."
            for _ in 0..<10_000 {
                _ = bytes.ascii.convertingCase(to: .lower)
            }
        }

        @Test(.timed(threshold: .milliseconds(10000), maxAllocations: 1_000_000))
        func `byte array validation 10K arrays`() {
            let bytes: [UInt8] = Array(repeating: 0x41, count: 1000)
            for _ in 0..<10_000 {
                _ = bytes.ascii.isAllASCII
            }
        }
    }
}
