import Testing
@testable import INCITS_4_1986

@Suite
struct `UInt8 - isASCIIWhitespace` {

    @Test(arguments: [0x20, 0x09, 0x0A, 0x0D])
    func `Whitespace bytes are recognized`(byte: UInt8) {
        #expect(byte.isASCIIWhitespace)
    }

    @Test
    func `Space (0x20) is whitespace`() {
        #expect(UInt8(0x20).isASCIIWhitespace)
    }

    @Test
    func `Tab (0x09) is whitespace`() {
        #expect(UInt8(0x09).isASCIIWhitespace)
    }

    @Test
    func `Line feed (0x0A) is whitespace`() {
        #expect(UInt8(0x0A).isASCIIWhitespace)
    }

    @Test
    func `Carriage return (0x0D) is whitespace`() {
        #expect(UInt8(0x0D).isASCIIWhitespace)
    }

    @Test(arguments: [0x00, 0x41, 0x61, 0x30, 0x21, 0xFF])
    func `Non-whitespace bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIIWhitespace)
    }
}

@Suite
struct `UInt8 - isASCIIDigit` {

    @Test
    func `All digits 0-9 are recognized`() {
        for byte in UInt8(ascii: "0")...UInt8(ascii: "9") {
            #expect(byte.isASCIIDigit, "Byte \(byte) (character '\(Character(UnicodeScalar(byte)))') should be a digit")
        }
    }

    @Test
    func `Byte before '0' is not a digit`() {
        let byte = UInt8(ascii: "0") - 1
        #expect(!byte.isASCIIDigit)
    }

    @Test
    func `Byte after '9' is not a digit`() {
        let byte = UInt8(ascii: "9") + 1
        #expect(!byte.isASCIIDigit)
    }

    @Test(arguments: [0x41, 0x61, 0x20, 0x00, 0xFF])
    func `Non-digit bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIIDigit)
    }
}

@Suite
struct `UInt8 - isASCIILetter` {

    @Test
    func `All uppercase letters A-Z are recognized`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            #expect(byte.isASCIILetter, "Byte \(byte) (character '\(Character(UnicodeScalar(byte)))') should be a letter")
        }
    }

    @Test
    func `All lowercase letters a-z are recognized`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            #expect(byte.isASCIILetter, "Byte \(byte) (character '\(Character(UnicodeScalar(byte)))') should be a letter")
        }
    }

    @Test
    func `Byte before 'A' is not a letter`() {
        let byte = UInt8(ascii: "A") - 1
        #expect(!byte.isASCIILetter)
    }

    @Test
    func `Byte after 'Z' is not a letter`() {
        let byte = UInt8(ascii: "Z") + 1
        #expect(!byte.isASCIILetter)
    }

    @Test
    func `Byte before 'a' is not a letter`() {
        let byte = UInt8(ascii: "a") - 1
        #expect(!byte.isASCIILetter)
    }

    @Test
    func `Byte after 'z' is not a letter`() {
        let byte = UInt8(ascii: "z") + 1
        #expect(!byte.isASCIILetter)
    }

    @Test(arguments: [0x30, 0x39, 0x20, 0x00, 0xFF])
    func `Non-letter bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIILetter)
    }
}

@Suite
struct `UInt8 - isASCIIAlphanumeric` {

    @Test
    func `All digits are alphanumeric`() {
        for byte in UInt8(ascii: "0")...UInt8(ascii: "9") {
            #expect(byte.isASCIIAlphanumeric)
        }
    }

    @Test
    func `All uppercase letters are alphanumeric`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            #expect(byte.isASCIIAlphanumeric)
        }
    }

    @Test
    func `All lowercase letters are alphanumeric`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            #expect(byte.isASCIIAlphanumeric)
        }
    }

    @Test(arguments: [0x20, 0x21, 0x40, 0x5B, 0x60, 0x7B, 0x00, 0xFF])
    func `Non-alphanumeric bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIIAlphanumeric)
    }

    @Test
    func `Alphanumeric is combination of digit and letter checks`() {
        for byte: UInt8 in 0...255 {
            let expectedResult = byte.isASCIIDigit || byte.isASCIILetter
            #expect(byte.isASCIIAlphanumeric == expectedResult)
        }
    }
}

@Suite
struct `UInt8 - isASCIIHexDigit` {

    @Test
    func `All digits 0-9 are hex digits`() {
        for byte in UInt8(ascii: "0")...UInt8(ascii: "9") {
            #expect(byte.isASCIIHexDigit)
        }
    }

    @Test
    func `Uppercase A-F are hex digits`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "F") {
            #expect(byte.isASCIIHexDigit)
        }
    }

    @Test
    func `Lowercase a-f are hex digits`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "f") {
            #expect(byte.isASCIIHexDigit)
        }
    }

    @Test(arguments: [
        UInt8(ascii: "G"), UInt8(ascii: "Z"),
        UInt8(ascii: "g"), UInt8(ascii: "z"),
        0x20, 0x00, 0xFF
    ])
    func `Non-hex bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIIHexDigit)
    }

    @Test
    func `All valid hex characters`() {
        let hexChars = "0123456789ABCDEFabcdef"
        for char in hexChars {
            guard let scalar = char.unicodeScalars.first else { continue }
            let byte = UInt8(ascii: scalar)
            #expect(byte.isASCIIHexDigit, "Character '\(char)' should be a hex digit")
        }
    }
}

@Suite
struct `UInt8 - isASCIIUppercase` {

    @Test
    func `All uppercase letters A-Z are recognized`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            #expect(byte.isASCIIUppercase)
        }
    }

    @Test
    func `Byte before 'A' is not uppercase`() {
        let byte = UInt8(ascii: "A") - 1
        #expect(!byte.isASCIIUppercase)
    }

    @Test
    func `Byte after 'Z' is not uppercase`() {
        let byte = UInt8(ascii: "Z") + 1
        #expect(!byte.isASCIIUppercase)
    }

    @Test
    func `Lowercase letters are not uppercase`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            #expect(!byte.isASCIIUppercase)
        }
    }

    @Test(arguments: [0x30, 0x39, 0x20, 0x00, 0xFF])
    func `Non-uppercase bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIIUppercase)
    }
}

@Suite
struct `UInt8 - isASCIILowercase` {

    @Test
    func `All lowercase letters a-z are recognized`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            #expect(byte.isASCIILowercase)
        }
    }

    @Test
    func `Byte before 'a' is not lowercase`() {
        let byte = UInt8(ascii: "a") - 1
        #expect(!byte.isASCIILowercase)
    }

    @Test
    func `Byte after 'z' is not lowercase`() {
        let byte = UInt8(ascii: "z") + 1
        #expect(!byte.isASCIILowercase)
    }

    @Test
    func `Uppercase letters are not lowercase`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            #expect(!byte.isASCIILowercase)
        }
    }

    @Test(arguments: [0x30, 0x39, 0x20, 0x00, 0xFF])
    func `Non-lowercase bytes are not recognized`(byte: UInt8) {
        #expect(!byte.isASCIILowercase)
    }
}

@Suite
struct `UInt8 - Case relationship` {

    @Test
    func `No byte is both uppercase and lowercase`() {
        for byte: UInt8 in 0...255 {
            if byte.isASCIIUppercase {
                #expect(!byte.isASCIILowercase)
            }
            if byte.isASCIILowercase {
                #expect(!byte.isASCIIUppercase)
            }
        }
    }

    @Test
    func `Uppercase and lowercase ranges don't overlap`() {
        let uppercaseRange = UInt8(ascii: "A")...UInt8(ascii: "Z")
        let lowercaseRange = UInt8(ascii: "a")...UInt8(ascii: "z")

        for uppercaseByte in uppercaseRange {
            #expect(!lowercaseRange.contains(uppercaseByte))
        }
    }
}

// Hex and Base64 whitespace tests belong in swift-standards, not ASCII package

// MARK: - ASCII Case Conversion

@Suite
struct `UInt8 - ascii(case:) to uppercase` {

    @Test
    func `Lowercase letters convert to uppercase`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            let result = byte.ascii(case: .upper)
            let expected = byte - 32
            #expect(result == expected, "'\(Character(UnicodeScalar(byte)))' should convert to '\(Character(UnicodeScalar(expected)))'")
        }
    }

    @Test
    func `Specific lowercase conversions`() {
        #expect(UInt8(ascii: "a").ascii(case: .upper) == UInt8(ascii: "A"))
        #expect(UInt8(ascii: "z").ascii(case: .upper) == UInt8(ascii: "Z"))
        #expect(UInt8(ascii: "m").ascii(case: .upper) == UInt8(ascii: "M"))
    }

    @Test
    func `Uppercase letters remain unchanged`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            let result = byte.ascii(case: .upper)
            #expect(result == byte)
        }
    }

    @Test
    func `Non-letter bytes remain unchanged`() {
        #expect(UInt8(ascii: "1").ascii(case: .upper) == UInt8(ascii: "1"))
        #expect(UInt8(ascii: " ").ascii(case: .upper) == UInt8(ascii: " "))
        #expect(UInt8(ascii: "!").ascii(case: .upper) == UInt8(ascii: "!"))
        #expect(UInt8(0x00).ascii(case: .upper) == 0x00)
        #expect(UInt8(0xFF).ascii(case: .upper) == 0xFF)
    }
}

@Suite
struct `UInt8 - ascii(case:) to lowercase` {

    @Test
    func `Uppercase letters convert to lowercase`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            let result = byte.ascii(case: .lower)
            let expected = byte + 32
            #expect(result == expected, "'\(Character(UnicodeScalar(byte)))' should convert to '\(Character(UnicodeScalar(expected)))'")
        }
    }

    @Test
    func `Specific uppercase conversions`() {
        #expect(UInt8(ascii: "A").ascii(case: .lower) == UInt8(ascii: "a"))
        #expect(UInt8(ascii: "Z").ascii(case: .lower) == UInt8(ascii: "z"))
        #expect(UInt8(ascii: "M").ascii(case: .lower) == UInt8(ascii: "m"))
    }

    @Test
    func `Lowercase letters remain unchanged`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            let result = byte.ascii(case: .lower)
            #expect(result == byte)
        }
    }

    @Test
    func `Non-letter bytes remain unchanged`() {
        #expect(UInt8(ascii: "1").ascii(case: .lower) == UInt8(ascii: "1"))
        #expect(UInt8(ascii: " ").ascii(case: .lower) == UInt8(ascii: " "))
        #expect(UInt8(ascii: "!").ascii(case: .lower) == UInt8(ascii: "!"))
        #expect(UInt8(0x00).ascii(case: .lower) == 0x00)
        #expect(UInt8(0xFF).ascii(case: .lower) == 0xFF)
    }
}

@Suite
struct `UInt8 - ascii(case:) round trip` {

    @Test
    func `Round trip uppercase to lowercase and back`() {
        for byte in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            let lowercased = byte.ascii(case: .lower)
            let uppercased = lowercased.ascii(case: .upper)
            #expect(uppercased == byte)
        }
    }

    @Test
    func `Round trip lowercase to uppercase and back`() {
        for byte in UInt8(ascii: "a")...UInt8(ascii: "z") {
            let uppercased = byte.ascii(case: .upper)
            let lowercased = uppercased.ascii(case: .lower)
            #expect(lowercased == byte)
        }
    }
}

@Suite
struct `[UInt8] - ascii(case:)` {

    @Test
    func `Array converts to uppercase`() {
        let input = Array("hello".utf8)
        let result = input.ascii(case: .upper)
        let expected = Array("HELLO".utf8)
        #expect(result == expected)
    }

    @Test
    func `Array converts to lowercase`() {
        let input = Array("WORLD".utf8)
        let result = input.ascii(case: .lower)
        let expected = Array("world".utf8)
        #expect(result == expected)
    }

    @Test
    func `Mixed case array`() {
        let input = Array("HeLLo WoRLd".utf8)
        let upper = input.ascii(case: .upper)
        let lower = input.ascii(case: .lower)
        #expect(upper == Array("HELLO WORLD".utf8))
        #expect(lower == Array("hello world".utf8))
    }

    @Test
    func `Array with non-letters`() {
        let input = Array("Hello123!".utf8)
        let result = input.ascii(case: .upper)
        let expected = Array("HELLO123!".utf8)
        #expect(result == expected)
    }

    @Test
    func `Empty array`() {
        let input: [UInt8] = []
        #expect(input.ascii(case: .upper) == [])
        #expect(input.ascii(case: .lower) == [])
    }

    @Test
    func `Array preserves non-ASCII bytes`() {
        let input: [UInt8] = [0x48, 0x65, 0xFF, 0x6C, 0x6C, 0x6F]  // "He<non-ASCII>llo"
        let result = input.ascii(case: .upper)
        #expect(result == [0x48, 0x45, 0xFF, 0x4C, 0x4C, 0x4F])
    }
}
