import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986 {
    @Suite struct `Case Conversion Tests` {
        @Suite struct Unit {
            @Test func `converting a string to upper case transforms letters only`() {
                #expect(INCITS_4_1986.convert("hello World 123!", to: .upper) == "HELLO WORLD 123!")
            }

            @Test func `converting a string to lower case transforms letters only`() {
                #expect(INCITS_4_1986.convert("HELLO World 123!", to: .lower) == "hello world 123!")
            }

            @Test func `converting a code array to upper case transforms letters only`() {
                let codes = [ASCII::ASCII.Code](ascii: "hello!")!
                let expected = [ASCII::ASCII.Code](ascii: "HELLO!")!
                #expect(INCITS_4_1986.convert(codes, to: .upper) == expected)
            }

            @Test func `converting a code array to lower case transforms letters only`() {
                let codes = [ASCII::ASCII.Code](ascii: "HELLO!")!
                let expected = [ASCII::ASCII.Code](ascii: "hello!")!
                #expect(INCITS_4_1986.convert(codes, to: .lower) == expected)
            }
        }

        @Suite struct `Edge Case` {
            @Test func `converting preserves non-letter characters unchanged`() {
                #expect(INCITS_4_1986.convert("123-456", to: .upper) == "123-456")
            }

            @Test func `converting non-ASCII text preserves it exactly`() {
                #expect(INCITS_4_1986.convert("hello🌍", to: .upper) == "HELLO🌍")
            }

            @Test func `converting an empty string returns an empty string`() {
                #expect(INCITS_4_1986.convert("", to: .upper).isEmpty)
            }
        }

        @Suite struct Integration {}
    }
}
