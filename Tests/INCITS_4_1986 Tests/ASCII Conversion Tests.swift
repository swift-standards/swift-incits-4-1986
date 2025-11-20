import Testing
@testable import INCITS_4_1986

// MARK: - Round-trip Conversion Tests

@Suite
struct `ASCII Round-trip Conversions` {

    @Test
    func `String to bytes using static method`() {
        // The improvement the user requested - static factory method!
        let bytes = [UInt8].ascii.from("hello")
        #expect(bytes == [104, 101, 108, 108, 111])
    }

    @Test
    func `String to bytes using static method unchecked`() {
        let bytes = [UInt8].ascii.from(unchecked: "hello")
        #expect(bytes == [104, 101, 108, 108, 111])
    }

    @Test
    func `String to bytes using static method with validation`() {
        let bytes = [UInt8].ascii.from("hello")
        #expect(bytes == [104, 101, 108, 108, 111])
    }

    @Test
    func `String to bytes using static method directly`() {
        let str = "hello"
        let bytes = [UInt8].ascii.from(str)
        #expect(bytes == [104, 101, 108, 108, 111])
    }

    @Test
    func `Non-ASCII string returns nil`() {
        #expect([UInt8].ascii.from("hello🌍") == nil)
    }

    @Test
    func `Bytes to String using static method`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        #expect(String.ascii(bytes) == "hello")
    }

    @Test
    func `Bytes to String using static method unchecked`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        #expect(String.ascii(unchecked: bytes) == "hello")
    }

    @Test
    func `Bytes to String using static method with validation`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        #expect(String.ascii(bytes) == "hello")
    }

    @Test
    func `Bytes to String using static method directly`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        #expect(String.ascii(bytes) == "hello")
    }

    @Test
    func `Bytes to String using initializer unchecked`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        #expect(String.ascii(unchecked: bytes) == "hello")
    }

    @Test
    func `Unchecked conversion for performance`() {
        let bytes = [UInt8].ascii.from(unchecked: "hello")
        #expect(bytes == [104, 101, 108, 108, 111])

        let str = String.ascii(unchecked: bytes)
        #expect(str == "hello")
    }

    @Test
    func `isAllASCII validation helper`() {
        #expect([104, 101, 108, 108, 111].ascii.isAllASCII == true)
        #expect([104, 255, 108].ascii.isAllASCII == false)
    }

    @Test
    func `Complete round-trip String → [UInt8] → String`() {
        let original = "Hello, World!"
        let bytes = [UInt8].ascii.from(original)!
        let restored = String.ascii(bytes)!
        #expect(restored == original)
    }

    @Test
    func `Complete round-trip [UInt8] → String → [UInt8]`() {
        let original: [UInt8] = [104, 101, 108, 108, 111]
        let string = String.ascii(original)!
        let restored = [UInt8].ascii.from(string)!
        #expect(restored == original)
    }
}

@Suite
struct `ASCII Case Conversion` {

    @Test
    func `String case conversion to uppercase`() {
        #expect("hello".ascii(case: .upper) == "HELLO")
        #expect("Hello World".ascii(case: .upper) == "HELLO WORLD")
    }

    @Test
    func `String case conversion to lowercase`() {
        #expect("HELLO".ascii(case: .lower) == "hello")
        #expect("Hello World".ascii(case: .lower) == "hello world")
    }

    @Test
    func `String case conversion preserves non-ASCII`() {
        #expect("hello🌍".ascii(case: .upper) == "HELLO🌍")
        #expect("HELLO🌍".ascii(case: .lower) == "hello🌍")
    }

    @Test
    func `Array case conversion matches String case conversion`() {
        let str = "Hello World"
        let strUpper = str.ascii(case: .upper)
        let bytesUpper = String.ascii(unchecked: [UInt8].ascii.from(unchecked: str).ascii.ascii(case: .upper))
        #expect(strUpper == bytesUpper)
    }

    @Test
    func `Case conversion round-trip`() {
        let original = "Hello World"
        let upper = original.ascii(case: .upper)
        let lower = upper.ascii(case: .lower)
        #expect(lower == "hello world")
    }
}

@Suite
struct `ASCII Validation` {

    @Test
    func `Valid ASCII bytes`() {
        let ascii: [UInt8] = [0, 65, 127]  // All valid ASCII
        #expect(ascii.ascii.isAllASCII)
    }

    @Test
    func `Invalid ASCII bytes`() {
        let nonAscii: [UInt8] = [65, 128, 255]  // Contains non-ASCII
        #expect(!nonAscii.ascii.isAllASCII)
    }

    @Test
    func `Empty array is valid ASCII`() {
        let empty: [UInt8] = []
        #expect(empty.ascii.isAllASCII)
    }

    @Test
    func `Boundary values`() {
        #expect([0].ascii.isAllASCII)      // Minimum ASCII
        #expect([127].ascii.isAllASCII)    // Maximum ASCII
        #expect(![128].ascii.isAllASCII)   // Just above ASCII range
    }
}

@Suite
struct `Performance Variants` {

    @Test
    func `Unchecked String to bytes avoids validation`() {
        let str = "hello world"
        let bytes = [UInt8].ascii.from(unchecked: str)
        #expect(bytes == [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100])
    }

    @Test
    func `Unchecked bytes to String avoids validation`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        let str = String.ascii(unchecked: bytes)
        #expect(str == "hello")
    }

    @Test
    func `Checked and unchecked produce same result for valid ASCII`() {
        let str = "hello"

        let checkedBytes = [UInt8].ascii.from(str)!
        let uncheckedBytes = [UInt8].ascii.from(unchecked: str)
        #expect(checkedBytes == uncheckedBytes)

        let checkedString = String.ascii(checkedBytes)!
        let uncheckedString = String.ascii(unchecked: uncheckedBytes)
        #expect(checkedString == uncheckedString)
    }
}
