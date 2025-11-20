// Substring+INCITS_4_1986 Tests.swift
// swift-incits-4-1986
//
// Tests for Substring extension methods

import Testing
import StandardsTestSupport
@testable import INCITS_4_1986

@Suite
struct `Substring - API Surface` {

    @Test
    func `substring has trimming method`() {
        let str = "  hello  "
        let sub = str[...]
        #expect(sub.trimming(Set<Character>.ascii.whitespaces) == "hello")
    }

    @Test
    func `substring trimming preserves content`() {
        let str = "  test content  "
        let sub = str[...]
        let trimmed = sub.trimming(Set<Character>.ascii.whitespaces)
        #expect(trimmed == "test content")
    }

    @Test
    func `substring trimming with custom character set`() {
        let str = "***hello***"
        let sub = str[...]
        let trimmed = sub.trimming(Set<Character>(["*"]))
        #expect(trimmed == "hello")
    }

    @Test
    func `substring trimming empty string`() {
        let str = ""
        let sub = str[...]
        #expect(sub.trimming(Set<Character>.ascii.whitespaces) == "")
    }
}

extension `Performance Tests` {
    @Suite
    struct `Substring - Performance` {

        @Test(.timed(threshold: .milliseconds(2000), maxAllocations: 1_000_000))
        func `substring trimming 10K times`() {
            let str = "  hello world  "
            let sub = str[...]
            for _ in 0..<10_000 {
                _ = sub.trimming(Set<Character>.ascii.whitespaces)
            }
        }
    }
}
