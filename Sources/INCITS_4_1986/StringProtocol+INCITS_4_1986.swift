//
//  File.swift
//  swift-incits-4-1986
//
//  Created by Coen ten Thije Boonkkamp on 22/11/2025.
//

extension StringProtocol {
    /// Trims characters from both ends of the string
    ///
    /// Returns a zero-copy view (SubSequence) with the specified characters trimmed.
    /// If you need an owned String, explicitly convert: `String(result)`.
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    public static func trimming(_ string: Self, of characterSet: Set<Character>) -> Self.SubSequence {
        INCITS_4_1986.trimming(string, of: characterSet)
    }

    /// Trims characters from both ends of the string
    ///
    /// Returns a zero-copy view (SubSequence) with the specified characters trimmed.
    /// If you need an owned String, explicitly convert: `String(result)`.
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    public func trimming(_ characterSet: Set<Character>) -> Self.SubSequence {
        INCITS_4_1986.trimming(self, of: characterSet)
    }
}
