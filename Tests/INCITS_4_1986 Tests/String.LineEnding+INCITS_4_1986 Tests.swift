// String.LineEnding+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for String.LineEnding support

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

// MARK: - Line Ending Constants

@Suite
struct `String.LineEnding - Constants` {

    @Test(arguments: [
        (String.LineEnding.lf, "LF", [UInt8.ascii.lf]),
        (String.LineEnding.cr, "CR", [UInt8.ascii.cr]),
        (String.LineEnding.crlf, "CRLF", [UInt8.ascii.cr, UInt8.ascii.lf])
    ])
    func `line ending conversions to bytes`(ending: String.LineEnding, name: String, expected: [UInt8]) {
        #expect([UInt8].ascii(lineEnding: ending) == expected, "\(name) should produce correct bytes")
    }

    @Test(arguments: [
        (String.LineEnding.lf, "\n"),
        (String.LineEnding.cr, "\r"),
        (String.LineEnding.crlf, "\r\n")
    ])
    func `line ending conversions to string`(ending: String.LineEnding, expected: String) {
        #expect(String.ascii(lineEnding: ending) == expected)
    }

    @Test
    func `line ending round-trip through bytes`() {
        for ending in [String.LineEnding.lf, .cr, .crlf] {
            let bytes = [UInt8].ascii(lineEnding: ending)
            let string = String.ascii(bytes)!
            let expectedString = String.ascii(lineEnding: ending)
            #expect(string == expectedString)
        }
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `String.LineEnding - Performance` {

        @Test(.timed(threshold: .milliseconds(200), maxAllocations: 100_000))
        func `line ending to bytes conversion 10K times`() {
            for _ in 0..<10_000 {
                _ = [UInt8].ascii(lineEnding: .lf)
                _ = [UInt8].ascii(lineEnding: .cr)
                _ = [UInt8].ascii(lineEnding: .crlf)
            }
        }
    }
}
