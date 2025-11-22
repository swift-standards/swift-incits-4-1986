// INCITS_4_1986.StringOperations.swift
// swift-incits-4-1986
//
// String operations using INCITS 4-1986 ASCII whitespace definitions

import Standards

// MARK: - String Trimming

extension INCITS_4_1986 {
    /// Trims characters from both ends of a string
    /// - Parameters:
    ///   - string: The string to trim
    ///   - characterSet: The set of characters to trim
    /// - Returns: A substring view with the specified characters trimmed from both ends
    ///
    /// This method returns a zero-copy view (SubSequence) of the original string.
    /// If you need an owned String, explicitly convert the result: `String(trimming(...))`.
    ///
    /// Per INCITS 4-1986:
    /// - SPACE (0x20): Section 4.2
    /// - HORIZONTAL TAB (0x09): Format effector, Section 4.1.2
    /// - LINE FEED (0x0A): Format effector, Section 4.1.2
    /// - CARRIAGE RETURN (0x0D): Format effector, Section 4.1.2
    public static func trimming<S: StringProtocol>(_ string: S, of characterSet: Set<Character>) -> S.SubSequence {
        // Use unicodeScalars to avoid grapheme cluster issues (e.g., \r\n being treated as one Character)
        let scalars = string.unicodeScalars
        var start = scalars.startIndex
        var end = scalars.endIndex

        // Trim from start
        while start < end {
            let char = Character(scalars[start])
            if !characterSet.contains(char) { break }
            start = scalars.index(after: start)
        }

        // Trim from end
        while end > start {
            let char = Character(scalars[scalars.index(before: end)])
            if !characterSet.contains(char) { break }
            end = scalars.index(before: end)
        }

        return string[start..<end]
    }
}
