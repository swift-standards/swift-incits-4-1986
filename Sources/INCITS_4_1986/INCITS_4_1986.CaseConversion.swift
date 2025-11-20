// INCITS_4_1986.CaseConversion.swift
// swift-incits-4-1986
//
// INCITS 4-1986 Section 4.3: Graphic Characters - Case Conversion
// Transforms ASCII letters between uppercase and lowercase

import Standards

// MARK: - Case Conversion

extension INCITS_4_1986 {
    /// Converts ASCII letters in byte array to specified case
    ///
    /// Non-ASCII bytes and non-letter bytes pass through unchanged.
    ///
    /// Per INCITS 4-1986 Table 7 (Graphic Characters):
    /// - Capital letters: A-Z (0x41-0x5A)
    /// - Small letters: a-z (0x61-0x7A)
    /// - Difference between cases: 32 (0x20)
    ///
    /// Mathematical Properties:
    /// - **Idempotence**: `ascii(ascii(b, case: c), case: c) == ascii(b, case: c)`
    /// - **Functoriality**: Preserves array structure (maps over elements)
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.ascii(Array("Hello".utf8), case: .upper)  // "HELLO" bytes
    /// ```
    public static func ascii(_ bytes: [UInt8], case: Character.Case) -> [UInt8] {
        bytes.map { $0.ascii.ascii(case: `case`) }
    }

    /// Converts ASCII letters in string to specified case
    ///
    /// Non-ASCII characters and non-letter characters pass through unchanged.
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.ascii("Hello World", case: .upper)  // "HELLO WORLD"
    /// INCITS_4_1986.ascii("hello🌍", case: .upper)  // "HELLO🌍"
    /// ```
    public static func ascii(_ string: String, case: Character.Case) -> String {
        String(decoding: ascii(Array(string.utf8), case: `case`), as: UTF8.self)
    }
}
