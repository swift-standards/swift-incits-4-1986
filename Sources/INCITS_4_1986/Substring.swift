// Substring.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII substring operations

import Standards

extension Substring {
    /// Trims characters from both ends of the substring
    /// - Parameters:
    ///   - substring: The substring to trim
    ///   - characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 byte-level processing when trimming ASCII whitespace.
    public static func trimming(_ substring: Substring, of characterSet: Set<Character>) -> String {
        // Fast path: UTF-8 optimization for ASCII whitespace
        if characterSet == .whitespaces {
            let utf8 = substring.utf8
            var start = utf8.startIndex
            var end = utf8.endIndex

            while start < end, utf8[start].isASCIIWhitespace {
                utf8.formIndex(after: &start)
            }

            while end > start, utf8[utf8.index(before: end)].isASCIIWhitespace {
                utf8.formIndex(before: &end)
            }

            return String(decoding: utf8[start..<end], as: UTF8.self)
        }

        // Generic path for other character sets
        var start = substring.startIndex
        var end = substring.endIndex

        while start < end, characterSet.contains(substring[start]) {
            start = substring.index(after: start)
        }

        while end > start, characterSet.contains(substring[substring.index(before: end)]) {
            end = substring.index(before: end)
        }

        return String(substring[start..<end])
    }

    /// Trims characters from both ends of the substring
    /// - Parameter characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 byte-level processing when trimming ASCII whitespace.
    public func trimming(_ characterSet: Set<Character>) -> String {
        Self.trimming(self, of: characterSet)
    }
}
