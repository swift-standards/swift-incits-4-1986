import Testing

@testable import INCITS_4_1986

@Suite struct `ASCII Code Array Tests` {
    @Suite struct Unit {
        @Test func `init ascii string succeeds for all-ASCII input`() {
            let codes = [ASCII::ASCII.Code](ascii: "Hi!")
            #expect(codes != nil)
            #expect(codes?.count == 3)
        }

        @Test func `init ascii string fails for non-ASCII input`() {
            #expect([ASCII::ASCII.Code](ascii: "café") == nil)
        }

        @Test func `init ascii lineEnding produces the matching code sequence`() {
            #expect([ASCII::ASCII.Code](ascii: .lf) == [.lf])
            #expect([ASCII::ASCII.Code](ascii: .cr) == [.cr])
            #expect([ASCII::ASCII.Code](ascii: .crlf) == [.cr, .lf])
        }

        @Test func `static ascii unchecked decodes without validation`() {
            #expect(
                [ASCII::ASCII.Code].ascii.unchecked("Hi") == [
                    ASCII::ASCII.Code
                ](ascii: "Hi")!
            )
        }

        @Test func `static ascii crlf is CR followed by LF`() {
            #expect([ASCII::ASCII.Code].ascii.crlf == [.cr, .lf])
        }

        @Test func `static ascii whitespaces contains the four INCITS 4-1986 whitespace codes`() {
            let whitespaces = [ASCII::ASCII.Code].ascii.whitespaces
            #expect(whitespaces.contains(.sp))
            #expect(whitespaces.contains(.htab))
            #expect(whitespaces.contains(.lf))
            #expect(whitespaces.contains(.cr))
            #expect(whitespaces.count == 4)
        }
    }

    @Suite struct `Edge Case` {
        @Test func `init ascii string succeeds for an empty string`() {
            #expect([ASCII::ASCII.Code](ascii: "") == [])
        }

        @Test func `static ascii unchecked on an empty string is empty`() {
            #expect([ASCII::ASCII.Code].ascii.unchecked("").isEmpty)
        }

        @Test func `static ascii whitespaces does not contain a non-whitespace code`() {
            #expect(![ASCII::ASCII.Code].ascii.whitespaces.contains(.A))
        }
    }

    @Suite struct Integration {}
}

@Suite struct `Character Set ASCII Tests` {
    @Suite struct Unit {
        @Test func `whitespaces contains SPACE HTAB LF CR and CRLF grapheme`() {
            #expect(Set<Character>.ascii.whitespaces.contains(" "))
            #expect(Set<Character>.ascii.whitespaces.contains("\t"))
            #expect(Set<Character>.ascii.whitespaces.contains("\n"))
            #expect(Set<Character>.ascii.whitespaces.contains("\r"))
            #expect(Set<Character>.ascii.whitespaces.contains("\r\n"))
        }

        @Test func `whitespaces does not contain a non-whitespace character`() {
            #expect(!Set<Character>.ascii.whitespaces.contains("a"))
        }

        @Test func `isWhitespace recognizes the CRLF grapheme cluster as a single whitespace unit`()
        {
            #expect(Set<Character>.ASCII.isWhitespace("\r\n"))
        }

        @Test func `isWhitespace recognizes individual ASCII whitespace characters`() {
            #expect(Set<Character>.ASCII.isWhitespace(" "))
            #expect(Set<Character>.ASCII.isWhitespace("\t"))
        }

        @Test func `isWhitespace rejects a non-whitespace character`() {
            #expect(!Set<Character>.ASCII.isWhitespace("a"))
        }
    }

    @Suite struct `Edge Case` {
        @Test func `isWhitespace rejects a non-ASCII character even if it is Unicode whitespace`() {
            #expect(!Set<Character>.ASCII.isWhitespace("\u{00A0}"))
        }
    }

    @Suite struct Integration {}
}
