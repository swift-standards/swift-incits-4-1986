// Substring.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII substring operations

import Standards

extension Substring {
    /// Trims characters from both ends of the substring
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    ///
    /// Uses optimized UTF-8 byte-level processing when trimming ASCII whitespace.
    public static func trimming(_ substring: Substring, of characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(substring, of: characterSet)
    }

    /// Trims characters from both ends of the substring
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    ///
    /// Uses optimized UTF-8 byte-level processing when trimming ASCII whitespace.
    public func trimming(_ characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(self, of: characterSet)
    }
}
