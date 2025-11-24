// INCITS_4_1986.StringOperations.swift
// swift-incits-4-1986
//
// String operations using INCITS 4-1986 ASCII whitespace definitions

import Standards

// MARK: - Byte-Level Operations (Authoritative)

extension INCITS_4_1986 {
    /// Trims ASCII bytes from both ends of a bidirectional collection (authoritative primitive)
    ///
    /// This is the authoritative implementation for trimming operations.
    /// All other trimming operations delegate to this primitive.
    ///
    /// Works on any bidirectional collection of bytes, including:
    /// - Array<UInt8>
    /// - ArraySlice<UInt8>
    /// - ContiguousArray<UInt8>
    /// - String.UTF8View
    /// - Data
    ///
    /// - Parameters:
    ///   - bytes: The bidirectional collection of bytes to trim
    ///   - characterSet: The set of ASCII byte values to trim
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    ///
    /// Per INCITS 4-1986:
    /// - SPACE (0x20): Section 4.2
    /// - HORIZONTAL TAB (0x09): Format effector, Section 4.1.2
    /// - LINE FEED (0x0A): Format effector, Section 4.1.2
    /// - CARRIAGE RETURN (0x0D): Format effector, Section 4.1.2
    public static func trimming<C: BidirectionalCollection>(
        _ bytes: C,
        of characterSet: Set<UInt8>
    ) -> C.SubSequence where C.Element == UInt8 {
        var start = bytes.startIndex
        var end = bytes.endIndex

        // Trim from start
        while start < end && characterSet.contains(bytes[start]) {
            bytes.formIndex(after: &start)
        }

        // Trim from end
        while start < end {
            let beforeEnd = bytes.index(before: end)
            guard characterSet.contains(bytes[beforeEnd]) else { break }
            end = beforeEnd
        }

        return bytes[start..<end]
    }
}

// MARK: - String-Level Operations

extension INCITS_4_1986 {
    /// Trims characters from both ends of a string
    ///
    /// Composes through the byte-level primitive for academic correctness.
    ///
    /// ## Category Theory
    ///
    /// String trimming composes as:
    /// ```
    /// String → [UInt8] (UTF-8) → trim bytes → String
    /// ```
    ///
    /// - Parameters:
    ///   - string: The string to trim
    ///   - characterSet: The set of characters to trim (must be ASCII)
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
        // Convert Character set to byte set (only valid for ASCII!)
        let asciiBytes = Set(characterSet.compactMap { char -> UInt8? in
            guard char.isASCII, let scalar = char.unicodeScalars.first else { return nil }
            return UInt8(scalar.value)
        })

        // Convert string to UTF-8 bytes
        let bytes = Array(string.utf8)

        // Delegate to authoritative byte-level primitive
        let trimmedBytes = trimming(bytes, of: asciiBytes)

        // Convert back to string
        return S.SubSequence(decoding: trimmedBytes, as: UTF8.self)
    }
}
