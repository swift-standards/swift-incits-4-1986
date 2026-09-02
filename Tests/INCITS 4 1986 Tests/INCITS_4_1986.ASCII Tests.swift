import Testing

@testable import INCITS_4_1986

@Suite struct `ASCII Wrapper Tests` {
    @Suite struct Unit {
        @Test func `code collection isAllASCII is trivially true`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(codes.ascii.isAllASCII)
        }

        @Test func `code collection uppercased converts letters only`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello 123!")!
            let expected = [ASCII::ASCII.Code](ascii: "HELLO 123!")!
            #expect(codes.ascii.uppercased() == expected)
        }

        @Test func `code collection lowercased converts letters only`() {
            let codes = [ASCII::ASCII.Code](ascii: "HELLO 123!")!
            let expected = [ASCII::ASCII.Code](ascii: "hello 123!")!
            #expect(codes.ascii.lowercased() == expected)
        }

        @Test func `trimming removes matching codes from both ends`() {
            let codes = [ASCII::ASCII.Code](ascii: "  Hi  ")!
            let trimmed = codes.ascii.trimming([.sp])
            #expect(Array(trimmed) == [ASCII::ASCII.Code](ascii: "Hi")!)
        }

        @Test func `elementsEqualCaseInsensitive matches differing case`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let lower = [ASCII::ASCII.Code](ascii: "content-type")!
            #expect(header.ascii.elementsEqualCaseInsensitive(lower))
        }

        @Test func `elementsEqualCaseInsensitive rejects differing length`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let other = [ASCII::ASCII.Code](ascii: "Content")!
            #expect(!header.ascii.elementsEqualCaseInsensitive(other))
        }

        @Test func `elementsEqualCaseInsensitive rejects differing content`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let other = [ASCII::ASCII.Code](ascii: "content-length")!
            #expect(!header.ascii.elementsEqualCaseInsensitive(other))
        }

        @Test func `hasPrefix caseInsensitive matches differing case prefix`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type: text/plain")!
            let prefix = [ASCII::ASCII.Code](ascii: "content-type")!
            #expect(header.ascii.hasPrefix(caseInsensitive: prefix))
        }

        @Test func `hasPrefix caseInsensitive rejects a prefix longer than the source`() {
            let header = [ASCII::ASCII.Code](ascii: "Content")!
            let prefix = [ASCII::ASCII.Code](ascii: "Content-Type")!
            #expect(!header.ascii.hasPrefix(caseInsensitive: prefix))
        }

        @Test func `lineRanges splits on LF CR and CRLF`() {
            let codes = [ASCII::ASCII.Code](ascii: "a\r\nb\nc\rd")!
            let ranges = codes.ascii.lineRanges()
            let lines = ranges.map { String(decoding: codes[$0].map(\.underlying), as: UTF8.self) }
            #expect(lines == ["a", "b", "c", "d"])
        }

        @Test func `lines returns copied code arrays per line`() {
            let codes = [ASCII::ASCII.Code](ascii: "Hello\r\nWorld")!
            let lines = codes.ascii.lines()
            #expect(lines.count == 2)
            #expect(lines[0] == [ASCII::ASCII.Code](ascii: "Hello")!)
            #expect(lines[1] == [ASCII::ASCII.Code](ascii: "World")!)
        }

        @Test func `predicate accessors classify a homogeneous code collection`() {
            let digits = [ASCII::ASCII.Code](ascii: "12345")!
            #expect(digits.ascii.isAllDigits)
            #expect(!digits.ascii.isAllLetters)

            let letters = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(letters.ascii.isAllLetters)
            #expect(letters.ascii.isAllLowercase)
            #expect(!letters.ascii.isAllUppercase)
        }

        @Test func `string isAllASCII reports non-ASCII content`() {
            #expect(INCITS_4_1986.ASCII("hello").isAllASCII)
            #expect(!INCITS_4_1986.ASCII("hello🌍").isAllASCII)
        }

        @Test func `string callAsFunction returns nil for non-ASCII input`() {
            #expect(INCITS_4_1986.ASCII("Hello")() == "Hello")
            #expect(INCITS_4_1986.ASCII("Hello🌍")() == nil)
        }

        @Test func `string uppercased and lowercased are Unicode-safe`() {
            #expect(INCITS_4_1986.ASCII("hello🌍").uppercased() == "HELLO🌍")
            #expect(INCITS_4_1986.ASCII("HELLO🌍").lowercased() == "hello🌍")
        }

        @Test func `string detectedLineEnding finds the first line ending style`() {
            #expect(INCITS_4_1986.ASCII("a\nb").detectedLineEnding() == .lf)
            #expect(INCITS_4_1986.ASCII("a\r\nb").detectedLineEnding() == .crlf)
            #expect(INCITS_4_1986.ASCII("a\rb").detectedLineEnding() == .cr)
            #expect(INCITS_4_1986.ASCII("ab").detectedLineEnding() == nil)
        }

        @Test func `string containsMixedLineEndings detects more than one style`() {
            #expect(INCITS_4_1986.ASCII("a\nb\r\nc").containsMixedLineEndings)
            #expect(!INCITS_4_1986.ASCII("a\nb\nc").containsMixedLineEndings)
        }

        @Test func `static line ending constants decode to the expected strings`() {
            #expect(INCITS_4_1986.ASCII<String>.lf == "\n")
            #expect(INCITS_4_1986.ASCII<String>.cr == "\r")
            #expect(INCITS_4_1986.ASCII<String>.crlf == "\r\n")
        }

        @Test func `unchecked decodes bytes without validation`() {
            let bytes: [UInt8] = [104, 101, 108, 108, 111]
            #expect(INCITS_4_1986.ASCII<String>.unchecked(bytes) == "hello")
        }
    }

    @Suite struct `Edge Case` {
        @Test func `code collection containsNonASCII is always false`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(!codes.ascii.containsNonASCII)
        }

        @Test func `trimming an all-matching collection returns an empty subsequence`() {
            let codes = [ASCII::ASCII.Code](ascii: "   ")!
            let trimmed = codes.ascii.trimming([.sp])
            #expect(trimmed.isEmpty)
        }

        @Test func `lineRanges on an empty collection returns no ranges`() {
            let codes = [ASCII::ASCII.Code]()
            #expect(codes.ascii.lineRanges().isEmpty)
        }

        @Test func `lineRanges on text without a trailing line ending includes the final line`() {
            let codes = [ASCII::ASCII.Code](ascii: "onlyline")!
            let ranges = codes.ascii.lineRanges()
            #expect(ranges.count == 1)
            #expect(Array(codes[ranges[0]]) == codes)
        }

        @Test func `lineRanges on a trailing line ending does not emit an empty final line`() {
            let codes = [ASCII::ASCII.Code](ascii: "a\n")!
            let ranges = codes.ascii.lineRanges()
            #expect(ranges.count == 1)
        }

        @Test func `elementsEqualCaseInsensitive on empty collections is true`() {
            let empty = [ASCII::ASCII.Code]()
            #expect(empty.ascii.elementsEqualCaseInsensitive(empty))
        }

        @Test func `string isAllWhitespace is vacuously true for an empty string`() {
            #expect(INCITS_4_1986.ASCII("").isAllWhitespace)
        }

        @Test func `string detectedLineEnding prioritizes CRLF over standalone CR or LF`() {
            #expect(INCITS_4_1986.ASCII("a\r\nb").detectedLineEnding() == .crlf)
        }
    }

    @Suite struct Integration {}
}
