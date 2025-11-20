// INCITS_4_1986.StringOperations.swift
// swift-incits-4-1986
//
// String operations using INCITS 4-1986 ASCII whitespace definitions

import Standards

// MARK: - String Trimming

extension INCITS_4_1986 {
    /// Trims characters from both ends of a substring
    /// - Parameters:
    ///   - substring: The substring to trim
    ///   - characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 byte-level processing when trimming ASCII whitespace.
    ///
    /// Per INCITS 4-1986:
    /// - SPACE (0x20): Section 4.2
    /// - HORIZONTAL TAB (0x09): Format effector, Section 4.1.2
    /// - LINE FEED (0x0A): Format effector, Section 4.1.2
    /// - CARRIAGE RETURN (0x0D): Format effector, Section 4.1.2
    public static func trimming(_ substring: Substring, of characterSet: Set<Character>) -> String {
        // Fast path: UTF-8 optimization for ASCII whitespace
        if characterSet == Set<Character>.ascii.whitespaces {
            let utf8 = substring.utf8
            var start = utf8.startIndex
            var end = utf8.endIndex

            while start < end, utf8[start].ascii.isWhitespace {
                utf8.formIndex(after: &start)
            }

            while end > start, utf8[utf8.index(before: end)].ascii.isWhitespace {
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
}
