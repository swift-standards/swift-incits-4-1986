import Testing
@testable import INCITS_4_1986

// MARK: - Trimming Characters

@Suite
struct `String - trimmingCharacters with whitespace` {

    @Test
    func `Trim whitespace from both ends`() {
        let input = "  hello world  "
        let result = input.trimming(.whitespaces)
        #expect(result == "hello world")
    }

    @Test
    func `Trim only leading whitespace`() {
        let input = "  hello world"
        let result = input.trimming(.whitespaces)
        #expect(result == "hello world")
    }

    @Test
    func `Trim only trailing whitespace`() {
        let input = "hello world  "
        let result = input.trimming(.whitespaces)
        #expect(result == "hello world")
    }

    @Test
    func `No trimming needed`() {
        let input = "hello world"
        let result = input.trimming(.whitespaces)
        #expect(result == "hello world")
    }

    @Test
    func `Trim all whitespace types`() {
        let input = " \t\n\rhello\t\n\r "
        let result = input.trimming(.whitespaces)
        #expect(result == "hello")
    }

    @Test
    func `Preserve internal whitespace`() {
        let input = "  hello  world  "
        let result = input.trimming(.whitespaces)
        #expect(result == "hello  world")
    }

    @Test
    func `Empty string remains empty`() {
        let input = ""
        let result = input.trimming(.whitespaces)
        #expect(result == "")
    }

    @Test
    func `Only whitespace becomes empty`() {
        let input = "   \t\n\r   "
        let result = input.trimming(.whitespaces)
        #expect(result == "")
    }

    @Test
    func `Single character with whitespace`() {
        let input = "  a  "
        let result = input.trimming(.whitespaces)
        #expect(result == "a")
    }
}

@Suite
struct `String - trimmingCharacters with custom character sets` {

    @Test
    func `Trim custom characters`() {
        let input = "xxhello worldxx"
        let result = input.trimming( ["x"])
        #expect(result == "hello world")
    }

    @Test
    func `Trim multiple custom characters`() {
        let input = "xyzHello Worldzyx"
        let result = input.trimming( ["x", "y", "z"])
        #expect(result == "Hello World")
    }

    @Test
    func `Trim punctuation`() {
        let input = "!!!Hello World!!!"
        let result = input.trimming( ["!"])
        #expect(result == "Hello World")
    }

    @Test
    func `No matching characters to trim`() {
        let input = "hello world"
        let result = input.trimming( ["x", "y", "z"])
        #expect(result == "hello world")
    }

    @Test
    func `Preserve internal matching characters`() {
        let input = "xxhello x worldxx"
        let result = input.trimming( ["x"])
        #expect(result == "hello x world")
    }

    @Test
    func `Empty character set performs no trimming`() {
        let input = "  hello  "
        let result = input.trimming( [])
        #expect(result == "  hello  ")
    }
}

@Suite
struct `String - static trimmingCharacters` {

    @Test
    func `Static method trims whitespace`() {
        let input = "  hello  "
        let result = String.trimming(input, of: .whitespaces)
        #expect(result == "hello")
    }

    @Test
    func `Static method with custom character set`() {
        let input = "***text***"
        let result = String.trimming(input, of: ["*"])
        #expect(result == "text")
    }
}

// MARK: - Hex Encoding

@Suite
struct `String - init(hexEncoding:)` {

    @Test
    func `Encode empty bytes`() {
        let bytes: [UInt8] = []
        let result = String(hexEncoding: bytes)
        #expect(result == "")
    }

    @Test
    func `Encode known bytes produces expected output`() {
        #expect(String(hexEncoding: [0xFF]) == "ff")
        #expect(String(hexEncoding: [0x00]) == "00")
        #expect(String(hexEncoding: [0x48, 0x65, 0x6c, 0x6c, 0x6f]) == "48656c6c6f")
        #expect(String(hexEncoding: [0xAB, 0xCD, 0xEF]) == "abcdef")
    }

    @Test
    func `Encode produces lowercase hex by default`() {
        let bytes: [UInt8] = [0xAB, 0xCD, 0xEF]
        let result = String(hexEncoding: bytes)
        #expect(result == "abcdef")
        #expect(!result.contains("A"))
        #expect(!result.contains("B"))
    }

    @Test
    func `Encode produces 2 characters per byte`() {
        #expect(String(hexEncoding: [0x01]).count == 2)
        #expect(String(hexEncoding: [0x01, 0x02]).count == 4)
        #expect(String(hexEncoding: [0x01, 0x02, 0x03]).count == 6)
    }

    @Test
    func `Encode boundary values`() {
        #expect(String(hexEncoding: [0x00]) == "00")
        #expect(String(hexEncoding: [0xFF]) == "ff")
        #expect(String(hexEncoding: [0x7F]) == "7f")
        #expect(String(hexEncoding: [0x80]) == "80")
    }

    @Test
    func `Encode full byte range`() {
        let bytes: [UInt8] = .init(0...255)
        let result = String(hexEncoding: bytes)
        #expect(result.count == 512) // 256 bytes * 2 hex chars each
        #expect(result.hasPrefix("00"))
        #expect(result.hasSuffix("ff"))
    }
}

// MARK: - Percent Encoding

@Suite
struct `String - percentEncoded` {

    @Test
    func `Encode empty string`() {
        let result = "".percentEncoded(allowing: [])
        #expect(result == "")
    }

    @Test
    func `Encode known characters produces expected output`() {
        #expect("a".percentEncoded(allowing: []) == "%61")
        #expect(" ".percentEncoded(allowing: []) == "%20")
        #expect("?".percentEncoded(allowing: []) == "%3f")
        #expect("#".percentEncoded(allowing: []) == "%23")
        #expect("abc".percentEncoded(allowing: []) == "%61%62%63")
    }

    @Test
    func `Encode uses lowercase hex by default`() {
        let result = "?#".percentEncoded(allowing: [])
        #expect(result == "%3f%23")  // lowercase
        #expect(!result.contains("F"))
    }

    @Test
    func `Encode with uppercase hex flag`() {
        let result = "?#".percentEncoded(allowing: [], uppercaseHex: true)
        #expect(result == "%3F%23")  // uppercase
    }

    @Test
    func `Don't encode allowed characters`() {
        let result = "hello".percentEncoded(allowing: Set("helo"))
        #expect(result == "hello")
    }

    @Test
    func `Encode mixed allowed and disallowed`() {
        let result = "hello world".percentEncoded(allowing: Set("helowrd"))
        #expect(result == "hello%20world")
    }

    @Test
    func `Encode preserves allowed special characters`() {
        let unreserved: Set<Character> = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        let input = "hello-world_123.test~abc"
        let result = input.percentEncoded(allowing: unreserved)
        #expect(result == input)
    }

    @Test
    func `Encode multi-byte UTF-8 characters`() {
        // Each character gets encoded as multiple percent-encoded bytes
        let result = "世".percentEncoded(allowing: [])
        #expect(result.hasPrefix("%"))
        #expect(result.filter { $0 == "%" }.count == 3)  // 3-byte UTF-8 character
    }

    @Test
    func `Static percentEncoded method`() {
        let result = String.percentEncoded(string: "test value", allowing: Set("testvalue"))
        #expect(result == "test%20value")
    }
}

@Suite
struct `String - percentDecoded` {

    @Test
    func `Decode empty string`() {
        let result = "".percentDecoded()
        #expect(result == "")
    }

    @Test
    func `Decode known percent-encoded strings`() {
        #expect("%61".percentDecoded() == "a")
        #expect("%20".percentDecoded() == " ")
        #expect("%3f".percentDecoded() == "?")
        #expect("%3F".percentDecoded() == "?")  // uppercase
        #expect("%61%62%63".percentDecoded() == "abc")
    }

    @Test
    func `Decode handles mixed case hex`() {
        #expect("%3f".percentDecoded() == "?")  // lowercase
        #expect("%3F".percentDecoded() == "?")  // uppercase
        #expect("%3f%3F".percentDecoded() == "??")  // mixed
    }

    @Test
    func `Decode complete string with encoding`() {
        #expect("hello%20world".percentDecoded() == "hello world")
        #expect("test%2Fvalue".percentDecoded() == "test/value")
        #expect("hello%20world%3Ftest".percentDecoded() == "hello world?test")
    }

    @Test
    func `Decode without percent encoding returns original`() {
        #expect("hello world".percentDecoded() == "hello world")
        #expect("test".percentDecoded() == "test")
    }

    @Test
    func `Decode rejects invalid sequences`() {
        // Incomplete sequences - return original
        #expect("test%2".percentDecoded() == "test%2")
        #expect("test%".percentDecoded() == "test%")

        // Invalid hex - return original
        #expect("test%GG".percentDecoded() == "test%GG")
        #expect("test%ZZ".percentDecoded() == "test%ZZ")
    }

    @Test
    func `Decode multi-byte UTF-8 sequences`() {
        // "世界" in UTF-8 percent-encoded
        #expect("%E4%B8%96%E7%95%8C".percentDecoded() == "世界")
        #expect("hello%20%E4%B8%96%E7%95%8C".percentDecoded() == "hello 世界")
    }

    @Test
    func `Static percentDecoded method`() {
        let result = String.percentDecoded(string: "hello%20world")
        #expect(result == "hello world")
    }
}

@Suite
struct `String - Percent encoding round trip` {

    @Test
    func `Round trip ASCII text`() {
        let original = "Hello, World! How are you?"
        let allowed: Set<Character> = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        let encoded = original.percentEncoded(allowing: allowed)
        let decoded = encoded.percentDecoded()
        #expect(decoded == original)
    }

    @Test
    func `Round trip special characters`() {
        let original = "path/to/file?query=value&foo=bar#anchor"
        let encoded = original.percentEncoded(allowing: [])
        let decoded = encoded.percentDecoded()
        #expect(decoded == original)
    }

    @Test
    func `Round trip unicode text`() {
        let original = "Hello 世界 🌍"
        let allowed: Set<Character> = Set("Hello ")
        let encoded = original.percentEncoded(allowing: allowed)
        let decoded = encoded.percentDecoded()
        #expect(decoded == original)
    }
}

// MARK: - Base64 Encoding

@Suite
struct `String - init(base64Encoding:)` {

    @Test
    func `Encode empty bytes`() {
        let result = String(base64Encoding: [])
        #expect(result == "")
    }

    @Test
    func `Encode known bytes produces expected output`() {
        #expect(String(base64Encoding: [0x61]) == "YQ==")  // "a"
        #expect(String(base64Encoding: [0x61, 0x62]) == "YWI=")  // "ab"
        #expect(String(base64Encoding: [0x61, 0x62, 0x63]) == "YWJj")  // "abc"
        #expect(String(base64Encoding: [0x48, 0x65, 0x6c, 0x6c, 0x6f]) == "SGVsbG8=")  // "Hello"
    }

    @Test
    func `Encode padding scenarios`() {
        // 1 byte: double padding
        #expect(String(base64Encoding: [0x61]).hasSuffix("=="))
        #expect(String(base64Encoding: [0x61]) == "YQ==")

        // 2 bytes: single padding
        #expect(String(base64Encoding: [0x61, 0x62]).hasSuffix("="))
        #expect(String(base64Encoding: [0x61, 0x62]) == "YWI=")

        // 3 bytes: no padding
        #expect(!String(base64Encoding: [0x61, 0x62, 0x63]).contains("="))
        #expect(String(base64Encoding: [0x61, 0x62, 0x63]) == "YWJj")
    }

    @Test
    func `Encode boundary values`() {
        #expect(String(base64Encoding: [0x00, 0x00, 0x00]) == "AAAA")
        #expect(String(base64Encoding: [0xFF, 0xFF]) == "//8=")
    }

    @Test
    func `Encode output length is always multiple of 4`() {
        for count in 1...10 {
            let bytes = Array(repeating: UInt8(0x42), count: count)
            let result = String(base64Encoding: bytes)
            #expect(result.count % 4 == 0)
        }
    }

    @Test
    func `Encode uses standard Base64 alphabet`() {
        // Verify it uses A-Za-z0-9+/
        let result = String(base64Encoding: [0xFF, 0xFF])
        #expect(result.contains("/"))  // Should use / not _
        #expect(result.contains("+") || result == "//8=")  // Standard alphabet
    }

    @Test
    func `Encode complete known strings`() {
        #expect(String(base64Encoding: Array("Hello World!".utf8)) == "SGVsbG8gV29ybGQh")
        #expect(String(base64Encoding: Array("Man".utf8)) == "TWFu")
    }
}

// MARK: - Case Insensitive Comparison

@Suite
struct `String.CaseInsensitive - Equality` {

    @Test
    func `Same strings are equal`() {
        let a = "hello".caseInsensitive
        let b = "hello".caseInsensitive
        #expect(a == b)
    }

    @Test
    func `Different case strings are equal`() {
        let a = "hello".caseInsensitive
        let b = "HELLO".caseInsensitive
        #expect(a == b)
    }

    @Test
    func `Mixed case strings are equal`() {
        #expect("Hello".caseInsensitive == "HELLO".caseInsensitive)
        #expect("HeLLo".caseInsensitive == "hello".caseInsensitive)
        #expect("HELLO".caseInsensitive == "hello".caseInsensitive)
    }

    @Test
    func `Different strings are not equal`() {
        #expect("hello".caseInsensitive != "world".caseInsensitive)
        #expect("test".caseInsensitive != "testing".caseInsensitive)
    }

    @Test
    func `Empty strings are equal`() {
        #expect("".caseInsensitive == "".caseInsensitive)
    }
}

@Suite
struct `String.CaseInsensitive - Hashing` {

    @Test
    func `Same case strings have same hash`() {
        let a = "hello".caseInsensitive
        let b = "hello".caseInsensitive
        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func `Different case strings have same hash`() {
        let a = "hello".caseInsensitive
        let b = "HELLO".caseInsensitive
        #expect(a.hashValue == b.hashValue)
    }
}

@Suite
struct `String.CaseInsensitive - Dictionary usage` {

    @Test
    func `Can be used as dictionary key`() {
        var dict: [String.CaseInsensitive: Int] = [:]
        dict["Content-Type".caseInsensitive] = 1
        #expect(dict["content-type".caseInsensitive] == 1)
        #expect(dict["CONTENT-TYPE".caseInsensitive] == 1)
    }

    @Test
    func `Dictionary lookup is case insensitive`() {
        var headers: [String.CaseInsensitive: String] = [:]
        headers["Content-Type".caseInsensitive] = "text/html"
        #expect(headers["content-type".caseInsensitive] == "text/html")
        #expect(headers["CONTENT-TYPE".caseInsensitive] == "text/html")
        #expect(headers["CoNtEnT-TyPe".caseInsensitive] == "text/html")
    }

    @Test
    func `Value property provides original string`() {
        let original = "Hello World"
        let caseInsensitive = original.caseInsensitive
        #expect(caseInsensitive.value == original)
    }
}

@Suite
struct `String.CaseInsensitive - Ordering` {

    @Test
    func `Ordering is case insensitive`() {
        #expect("Apple".caseInsensitive < "banana".caseInsensitive)
        #expect("APPLE".caseInsensitive < "Banana".caseInsensitive)
    }

    @Test
    func `Same strings in different cases are equal for ordering`() {
        let a = "hello".caseInsensitive
        let b = "HELLO".caseInsensitive
        #expect(!(a < b))
        #expect(!(b < a))
    }

    @Test
    func `Can be sorted case insensitively`() {
        let items = ["Banana", "apple", "Cherry", "APRICOT"]
            .map { $0.caseInsensitive }
            .sorted()
            .map { $0.value }

        #expect(items[0].lowercased() == "apple")
        #expect(items[1].lowercased() == "apricot")
        #expect(items[2].lowercased() == "banana")
        #expect(items[3].lowercased() == "cherry")
    }
}

// MARK: - ASCII Validation

@Suite
struct `String - asciiBytes` {

    @Test
    func `Pure ASCII string returns bytes`() {
        let result = "hello".asciiBytes
        #expect(result != nil)
        #expect(result == [104, 101, 108, 108, 111])
    }

    @Test
    func `ASCII with numbers and symbols`() {
        let result = "Hello123!".asciiBytes
        #expect(result != nil)
        #expect(result?.count == 9)
    }

    @Test
    func `Empty string returns empty array`() {
        let result = "".asciiBytes
        #expect(result != nil)
        #expect(result == [])
    }

    @Test
    func `Non-ASCII character returns nil`() {
        #expect("hello🌍".asciiBytes == nil)
        #expect("世界".asciiBytes == nil)
        #expect("café".asciiBytes == nil)
    }

    @Test
    func `All ASCII characters 0-127`() {
        for byte: UInt8 in 0...127 {
            let str = String(UnicodeScalar(byte))
            let result = str.asciiBytes
            #expect(result != nil)
            #expect(result == [byte])
        }
    }
}

@Suite
struct `String - init(ascii:)` {

    @Test
    func `Valid ASCII bytes create string`() {
        let bytes: [UInt8] = [104, 101, 108, 108, 111]
        let result = String(ascii: bytes)
        #expect(result == "hello")
    }

    @Test
    func `Empty bytes create empty string`() {
        let result = String(ascii: [])
        #expect(result == "")
    }

    @Test
    func `Non-ASCII byte returns nil`() {
        #expect(String(ascii: [128]) == nil)
        #expect(String(ascii: [255]) == nil)
        #expect(String(ascii: [104, 101, 200]) == nil)
    }

    @Test
    func `Boundary values`() {
        #expect(String(ascii: [0]) != nil)
        #expect(String(ascii: [127]) != nil)
        #expect(String(ascii: [128]) == nil)
    }

    @Test
    func `Round trip ASCII conversion`() {
        let original = "Hello, World! 123"
        let bytes = original.asciiBytes
        #expect(bytes != nil)
        let reconstructed = String(ascii: bytes!)
        #expect(reconstructed == original)
    }
}

// MARK: - Line Ending Normalization

@Suite
struct `String - normalized(to:) with LF` {

    @Test
    func `CRLF to LF`() {
        #expect("line1\r\nline2".normalized(to: .lf) == "line1\nline2")
        #expect("a\r\nb\r\nc".normalized(to: .lf) == "a\nb\nc")
    }

    @Test
    func `CR to LF`() {
        #expect("line1\rline2".normalized(to: .lf) == "line1\nline2")
    }

    @Test
    func `Already LF returns fast`() {
        let text = "line1\nline2\nline3"
        #expect(text.normalized(to: .lf) == text)
    }

    @Test
    func `Mixed line endings to LF`() {
        let mixed = "line1\nline2\r\nline3\rline4"
        let result = mixed.normalized(to: .lf)
        #expect(result == "line1\nline2\nline3\nline4")
    }

    @Test
    func `No line endings unchanged`() {
        #expect("hello world".normalized(to: .lf) == "hello world")
    }

    @Test
    func `Empty string`() {
        #expect("".normalized(to: .lf) == "")
    }
}

@Suite
struct `String - normalized(to:) with CRLF` {

    @Test
    func `LF to CRLF`() {
        #expect("line1\nline2".normalized(to: .crlf) == "line1\r\nline2")
    }

    @Test
    func `CR to CRLF`() {
        #expect("line1\rline2".normalized(to: .crlf) == "line1\r\nline2")
    }

    @Test
    func `Already CRLF preserved`() {
        #expect("line1\r\nline2".normalized(to: .crlf) == "line1\r\nline2")
    }

    @Test
    func `Mixed line endings to CRLF`() {
        let mixed = "line1\nline2\r\nline3\rline4"
        let result = mixed.normalized(to: .crlf)
        #expect(result == "line1\r\nline2\r\nline3\r\nline4")
    }

    @Test
    func `Multiple consecutive line endings`() {
        #expect("\n\n".normalized(to: .crlf) == "\r\n\r\n")
        #expect("\r\r".normalized(to: .crlf) == "\r\n\r\n")
    }
}

@Suite
struct `String - normalized(to:) with CR` {

    @Test
    func `LF to CR`() {
        #expect("line1\nline2".normalized(to: .cr) == "line1\rline2")
    }

    @Test
    func `CRLF to CR`() {
        #expect("line1\r\nline2".normalized(to: .cr) == "line1\rline2")
    }

    @Test
    func `Already CR preserved`() {
        let text = "line1\rline2"
        // Note: fast path check should detect this
        #expect(text.normalized(to: .cr) == text)
    }

    @Test
    func `Mixed line endings to CR`() {
        let mixed = "line1\nline2\r\nline3\rline4"
        let result = mixed.normalized(to: .cr)
        #expect(result == "line1\rline2\rline3\rline4")
    }
}

@Suite
struct `String - LineEnding enum` {

    @Test
    func `LF string value`() {
        #expect(String.LineEnding.lf.rawValue == "\n")
    }

    @Test
    func `CR string value`() {
        #expect(String.LineEnding.cr.rawValue == "\r")
    }

    @Test
    func `CRLF string value`() {
        #expect(String.LineEnding.crlf.rawValue == "\r\n")
    }
}
