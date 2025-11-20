// String+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for String extension methods

import StandardsTestSupport
import Testing

@testable import INCITS_4_1986

// Note: String conversion tests are in INCITS_4_1986 Tests.swift
// Note: String case conversion tests are in INCITS_4_1986.CaseConversion Tests.swift
// Note: String trimming tests are in INCITS_4_1986.StringOperations Tests.swift
// Note: String normalization tests are in INCITS_4_1986.FormatEffectors Tests.swift

@Suite
struct `String - API Surface` {

    @Test
    func `string has ascii conversion method`() {
        let bytes: [UInt8] = [UInt8.ascii.H, .ascii.e, .ascii.l, .ascii.l, .ascii.o]
        let string = String.ascii(bytes)
        #expect(string == "Hello")
    }

    @Test
    func `string has case conversion method`() {
        let str = "Hello"
        #expect(str.ascii(case: .upper) == "HELLO")
        #expect(str.ascii(case: .lower) == "hello")
    }

    @Test
    func `string has trimming method`() {
        let str = "  hello  "
        #expect(str.trimming(Set<Character>.ascii.whitespaces) == "hello")
    }

    @Test
    func `string has normalization method`() {
        let str = "hello\r\nworld"
        #expect(str.normalized(to: .lf) == "hello\nworld")
    }
}

extension `Performance Tests` {
    @Suite
    struct `String - Performance` {

        @Test(.timed(threshold: .milliseconds(150)))
        func `string to bytes conversion 10K times`() {
            let str = "Hello World!"
            for _ in 0..<10_000 {
                _ = [UInt8].ascii(str)
            }
        }

        @Test(.timed(threshold: .milliseconds(150)))
        func `bytes to string conversion 10K times`() {
            let bytes: [UInt8] = [UInt8.ascii.H, .ascii.e, .ascii.l, .ascii.l, .ascii.o]
            for _ in 0..<10_000 {
                _ = String.ascii(bytes)
            }
        }
    }
}
