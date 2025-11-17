// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

extension String {
    /// Returns ASCII bytes if all characters are ASCII, nil otherwise
    ///
    /// Example:
    /// ```swift
    /// "hello".asciiBytes  // [104, 101, 108, 108, 111]
    /// "hello🌍".asciiBytes  // nil
    /// ```
    public var asciiBytes: [UInt8]? {
        guard allSatisfy({ $0.isASCII }) else { return nil }
        return Array(utf8)
    }

    /// Creates a string from ASCII bytes, nil if any byte is non-ASCII
    ///
    /// Example:
    /// ```swift
    /// String(ascii: [104, 101, 108, 108, 111])  // "hello"
    /// String(ascii: [255])  // nil (not valid ASCII)
    /// ```
    public init?(ascii bytes: [UInt8]) {
        guard bytes.allSatisfy({ $0 <= 127 }) else { return nil }
        self.init(decoding: bytes, as: UTF8.self)
    }
}

extension String {
    /// Trims characters from both ends of the string
    /// - Parameters:
    ///   - string: The string to trim
    ///   - characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    public static func trimming(_ string: String, of characterSet: Set<Character>) -> String {
        Substring.trimming(string[...], of: characterSet)
    }

    /// Trims characters from both ends of the string
    /// - Parameter characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    @inlinable
    public func trimming(_ characterSet: Set<Character>) -> String {
        Self.trimming(self, of: characterSet)
    }
}
