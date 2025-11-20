// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

extension String {
    /// Creates a string from ASCII bytes, nil if any byte is non-ASCII
    ///
    /// Example:
    /// ```swift
    /// String.ascii([104, 101, 108, 108, 111])  // "hello"
    /// String.ascii([255])  // nil (not valid ASCII)
    /// ```
    public static func ascii(_ bytes: [UInt8]) -> String? {
        guard bytes.ascii.isAllASCII else { return nil }
        return String(decoding: bytes, as: UTF8.self)
    }

    /// Creates a string from bytes without ASCII validation
    ///
    /// Use when you know all bytes are ASCII. More efficient than `String.ascii(_:)`.
    ///
    /// Example:
    /// ```swift
    /// String.ascii(unchecked: [104, 101, 108, 108, 111])  // "hello"
    /// ```
    public static func ascii(unchecked bytes: [UInt8]) -> String {
        String(decoding: bytes, as: UTF8.self)
    }

    /// Creates a string from ASCII bytes, nil if any byte is non-ASCII
    ///
    /// Convenience initializer that calls `String.ascii(_:)`.
    ///
    /// Example:
    /// ```swift
    /// String(ascii: [104, 101, 108, 108, 111])  // "hello"
    /// String(ascii: [255])  // nil (not valid ASCII)
    /// ```
    public init?(ascii bytes: [UInt8]) {
        guard let string = Self.ascii(bytes) else { return nil }
        self = string
    }
}

extension String {
    /// Converts ASCII letters to specified case
    ///
    /// Convenience method that delegates to `INCITS_4_1986.ascii(_:case:)`.
    ///
    /// Example:
    /// ```swift
    /// "Hello World".ascii(case: .upper)  // "HELLO WORLD"
    /// "Hello World".ascii(case: .lower)  // "hello world"
    /// "hello🌍".ascii(case: .upper)  // "HELLO🌍"
    /// ```
    public func ascii(case: Character.Case) -> String {
        INCITS_4_1986.ascii(self, case: `case`)
    }
}

extension String {
    /// Trims characters from both ends of the string
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    public static func trimming(_ string: String, of characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(string[...], of: characterSet)
    }

    /// Trims characters from both ends of the string
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    @inlinable
    public func trimming(_ characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(self[...], of: characterSet)
    }
}

extension String {
    /// Normalizes ASCII line endings to the specified style
    ///
    /// Convenience method that delegates to `INCITS_4_1986.normalized(_:to:as:)`.
    ///
    /// Example:
    /// ```swift
    /// let text = "line1\nline2\r\nline3"
    /// text.normalized(to: .crlf)  // "line1\r\nline2\r\nline3"
    /// ```
    public func normalized<Encoding>(
        to lineEnding: LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        INCITS_4_1986.normalized(self, to: lineEnding, as: encoding)
    }
}

// MARK: - Line Endings

extension String {
    public init<Encoding>(
        _ lineEnding: String.LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        self = String(decoding: [UInt8](lineEnding), as: encoding)
    }
}
