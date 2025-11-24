// Set+Character.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII character sets

import Standards

extension Set {
    /// Convenient access to INCITS 4-1986 (US-ASCII) character constants
    ///
    /// Returns the INCITS_4_1986 namespace for accessing ASCII constants without conflicts.
    ///
    /// Example:
    /// ```swift
    /// let whitespaces: Set<Character> = .ascii.whitespaceCharacters
    /// let trimmed = " hello ".trimming(.ascii.whitespaceCharacters)
    /// ```
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public enum ASCII {}
}

extension Set<Character>.ASCII {

    /// ASCII whitespace characters as Set<Character>
    ///
    /// Derived from the canonical byte-level definition in `INCITS_4_1986.whitespaces`.
    /// Per INCITS 4-1986, these are the only four whitespace characters in US-ASCII:
    /// - U+0020 (SPACE)
    /// - U+0009 (HORIZONTAL TAB)
    /// - U+000A (LINE FEED)
    /// - U+000D (CARRIAGE RETURN)
    ///
    /// This is explicitly ASCII-only and does not include Unicode whitespace
    /// characters (e.g., U+00A0 NO-BREAK SPACE, U+2003 EM SPACE).
    ///
    /// The ASCII-only definition enables optimized byte-level processing
    /// in string trimming operations without Unicode normalization overhead.
    public static let whitespaces: Set<Character> = Set(
        INCITS_4_1986.whitespaces.map { Character(UnicodeScalar($0)) }
    )
}
