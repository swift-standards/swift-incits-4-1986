import Testing
@testable import INCITS_4_1986

// MARK: - Base64 Decoding

@Suite
struct `[UInt8] - init(base64Encoded:)` {

    @Test
    func `Decode empty string`() {
        let bytes = [UInt8](base64Encoded: "")
        #expect(bytes == [])
    }

    @Test
    func `Decode single character`() {
        let bytes = [UInt8](base64Encoded: "YQ==")  // "a"
        #expect(bytes == [0x61])
    }

    @Test
    func `Decode two characters`() {
        let bytes = [UInt8](base64Encoded: "YWI=")  // "ab"
        #expect(bytes == [0x61, 0x62])
    }

    @Test
    func `Decode three characters`() {
        let bytes = [UInt8](base64Encoded: "YWJj")  // "abc"
        #expect(bytes == [0x61, 0x62, 0x63])
    }

    @Test
    func `Decode standard Base64 string`() {
        let bytes = [UInt8](base64Encoded: "SGVsbG8gV29ybGQh")  // "Hello World!"
        let expected = Array("Hello World!".utf8)
        #expect(bytes == expected)
    }

    @Test
    func `Decode with padding`() {
        let bytes = [UInt8](base64Encoded: "YQ==")
        #expect(bytes != nil)
    }

    @Test
    func `Decode with single padding`() {
        let bytes = [UInt8](base64Encoded: "YWI=")
        #expect(bytes != nil)
    }

    @Test
    func `Decode with whitespace`() {
        let bytes = [UInt8](base64Encoded: "SGVs bG8g V29y bGQh")
        let expected = Array("Hello World!".utf8)
        #expect(bytes == expected)
    }

    @Test
    func `Decode with newlines and tabs`() {
        let bytes = [UInt8](base64Encoded: "SGVs\nbG8g\tV29y\rbGQh")
        let expected = Array("Hello World!".utf8)
        #expect(bytes == expected)
    }

    @Test
    func `Decode returns nil for invalid characters`() {
        let bytes = [UInt8](base64Encoded: "SGVs!bG8h")
        #expect(bytes == nil)
    }

    @Test
    func `Decode returns nil for incomplete sequence`() {
        let bytes = [UInt8](base64Encoded: "YWJ")  // Missing padding or fourth character
        #expect(bytes == nil)
    }

    @Test
    func `Decode with plus and slash`() {
        let bytes = [UInt8](base64Encoded: "YWJj+/==")  // Contains + and /
        #expect(bytes != nil)
    }

    @Test
    func `Decode all zeros`() {
        let bytes = [UInt8](base64Encoded: "AAAA")
        #expect(bytes == [0x00, 0x00, 0x00])
    }

    @Test
    func `Decode all ones`() {
        let bytes = [UInt8](base64Encoded: "////")
        #expect(bytes != nil)
        #expect(bytes?.count == 3)
    }
}

@Suite
struct `[UInt8] - init(hexEncoded:)` {

    @Test
    func `Decode empty string`() {
        let bytes = [UInt8](hexEncoded: "")
        #expect(bytes == [])
    }

    @Test
    func `Decode single byte lowercase`() {
        let bytes = [UInt8](hexEncoded: "ff")
        #expect(bytes == [0xFF])
    }

    @Test
    func `Decode single byte uppercase`() {
        let bytes = [UInt8](hexEncoded: "FF")
        #expect(bytes == [0xFF])
    }

    @Test
    func `Decode mixed case`() {
        let bytes = [UInt8](hexEncoded: "aBcDeF")
        #expect(bytes == [0xAB, 0xCD, 0xEF])
    }

    @Test
    func `Decode multiple bytes`() {
        let bytes = [UInt8](hexEncoded: "0123456789abcdef")
        #expect(bytes == [0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF])
    }

    @Test
    func `Decode with 0x prefix lowercase`() {
        let bytes = [UInt8](hexEncoded: "0x48656c6c6f")
        #expect(bytes == Array("Hello".utf8))
    }

    @Test
    func `Decode with 0X prefix uppercase`() {
        let bytes = [UInt8](hexEncoded: "0X48656C6C6F")
        #expect(bytes == Array("Hello".utf8))
    }

    @Test
    func `Decode with whitespace`() {
        let bytes = [UInt8](hexEncoded: "48 65 6c 6c 6f")
        #expect(bytes == Array("Hello".utf8))
    }

    @Test
    func `Decode with tabs and newlines`() {
        let bytes = [UInt8](hexEncoded: "48\t65\n6c\r6c 6f")
        #expect(bytes == Array("Hello".utf8))
    }

    @Test
    func `Decode zero byte`() {
        let bytes = [UInt8](hexEncoded: "00")
        #expect(bytes == [0x00])
    }

    @Test
    func `Decode returns nil for odd length`() {
        let bytes = [UInt8](hexEncoded: "abc")
        #expect(bytes == nil)
    }

    @Test
    func `Decode returns nil for invalid characters`() {
        let bytes = [UInt8](hexEncoded: "gg")
        #expect(bytes == nil)
    }

    @Test
    func `Decode returns nil for non-hex characters`() {
        let bytes = [UInt8](hexEncoded: "xyz")
        #expect(bytes == nil)
    }

    @Test
    func `Decode all valid hex pairs`() {
        let hexString = "0123456789abcdefABCDEF"
        for i in stride(from: 0, to: hexString.count - 1, by: 2) {
            let start = hexString.index(hexString.startIndex, offsetBy: i)
            let end = hexString.index(start, offsetBy: 2)
            let pair = String(hexString[start..<end])
            let bytes = [UInt8](hexEncoded: pair)
            #expect(bytes != nil, "Failed to decode hex pair: \(pair)")
        }
    }

    @Test
    func `Decode with mixed whitespace types`() {
        let bytes = [UInt8](hexEncoded: "  48\t65\n6c\r6c  6f  ")
        #expect(bytes == Array("Hello".utf8))
    }
}

// MARK: - Round Trip Tests

@Suite
struct `[UInt8] - Base64 round trip` {

    @Test
    func `Round trip empty data`() {
        let original: [UInt8] = []
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip single byte`() {
        let original: [UInt8] = [0x42]
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip ASCII text`() {
        let original = Array("Hello, World!".utf8)
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip binary data`() {
        let original: [UInt8] = [0x00, 0xFF, 0x01, 0xFE, 0x80, 0x7F]
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip all byte values`() {
        let original = Array(UInt8(0)...UInt8(255))
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip with unicode source`() {
        let original = Array("Hello 世界 🌍".utf8)
        let encoded = String(base64Encoding: original)
        let decoded = [UInt8](base64Encoded: encoded)
        #expect(decoded == original)
    }
}

@Suite
struct `[UInt8] - Hex round trip` {

    @Test
    func `Round trip empty data`() {
        let original: [UInt8] = []
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip single byte`() {
        let original: [UInt8] = [0x42]
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip ASCII text`() {
        let original = Array("Hello, World!".utf8)
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip binary data`() {
        let original: [UInt8] = [0x00, 0xFF, 0x01, 0xFE, 0x80, 0x7F]
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip all byte values`() {
        let original = Array(UInt8(0)...UInt8(255))
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }

    @Test
    func `Round trip with unicode source`() {
        let original = Array("Hello 世界 🌍".utf8)
        let encoded = String(hexEncoding: original)
        let decoded = [UInt8](hexEncoded: encoded)
        #expect(decoded == original)
    }
}

// MARK: - Concrete Expected Outputs

@Suite
struct `[UInt8] - Base64 expected outputs` {

    @Test
    func `Decode known Base64 string`() {
        let bytes = [UInt8](base64Encoded: "SGVsbG8=")
        #expect(bytes == [0x48, 0x65, 0x6c, 0x6c, 0x6f])  // "Hello"
    }

    @Test
    func `Decode rejects invalid Base64 characters`() {
        let bytes = [UInt8](base64Encoded: "SGVs!bG8=")  // Contains !
        #expect(bytes == nil)
    }

    @Test
    func `Encode produces expected Base64 output`() {
        let result = String(base64Encoding: [0x48, 0x65, 0x6c, 0x6c, 0x6f])
        #expect(result == "SGVsbG8=")
    }

    @Test
    func `Decode Base64 with all padding scenarios`() {
        // No padding (multiple of 3 bytes)
        #expect([UInt8](base64Encoded: "YWJj") == [0x61, 0x62, 0x63])
        // Single padding (2 bytes)
        #expect([UInt8](base64Encoded: "YWI=") == [0x61, 0x62])
        // Double padding (1 byte)
        #expect([UInt8](base64Encoded: "YQ==") == [0x61])
    }
}

@Suite
struct `[UInt8] - Hex expected outputs` {

    @Test
    func `Decode known hex string lowercase`() {
        let bytes = [UInt8](hexEncoded: "48656c6c6f")
        #expect(bytes == [0x48, 0x65, 0x6c, 0x6c, 0x6f])  // "Hello"
    }

    @Test
    func `Decode known hex string uppercase`() {
        let bytes = [UInt8](hexEncoded: "48656C6C6F")
        #expect(bytes == [0x48, 0x65, 0x6c, 0x6c, 0x6f])  // "Hello"
    }

    @Test
    func `Decode rejects invalid hex characters`() {
        let bytes = [UInt8](hexEncoded: "48GG")  // Contains G
        #expect(bytes == nil)
    }

    @Test
    func `Encode produces expected hex output`() {
        let result = String(hexEncoding: [0x48, 0x65, 0x6c, 0x6c, 0x6f])
        #expect(result == "48656c6c6f")  // lowercase
    }

    @Test
    func `Decode hex boundary values`() {
        #expect([UInt8](hexEncoded: "00") == [0x00])
        #expect([UInt8](hexEncoded: "ff") == [0xFF])
        #expect([UInt8](hexEncoded: "FF") == [0xFF])
        #expect([UInt8](hexEncoded: "7f") == [0x7F])
        #expect([UInt8](hexEncoded: "80") == [0x80])
    }
}
