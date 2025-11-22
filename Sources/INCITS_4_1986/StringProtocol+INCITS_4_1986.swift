//
//  File.swift
//  swift-incits-4-1986
//
//  Created by Coen ten Thije Boonkkamp on 22/11/2025.
//

// MARK: - ASCII Namespace Access

extension StringProtocol {
    /// Access to ASCII type-level constants and methods
    public static var ascii: String.ASCII.Type {
        String.ASCII.self
    }

    /// Access to ASCII instance methods for this string
    ///
    /// Note: For Substring, this creates a String.ASCII instance by converting to String.
    /// The conversion is done once when accessing `.ascii`.
    public var ascii: String.ASCII {
        String.ASCII(self)
    }
}

// MARK: - String Trimming

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

// MARK: - ASCII Case Conversion

extension StringProtocol {
    /// Converts ASCII letters to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) to the specified case, leaving
    /// all other characters unchanged. This is a **Unicode-safe** operation: non-ASCII characters
    /// (including emoji and accented letters) are preserved exactly as-is.
    ///
    /// ## Algorithm
    ///
    /// Only the 52 ASCII letters defined in INCITS 4-1986 are affected:
    /// - **Uppercase**: A-Z (0x41-0x5A)
    /// - **Lowercase**: a-z (0x61-0x7A)
    ///
    /// All other characters, including digits, punctuation, whitespace, and non-ASCII Unicode
    /// characters, pass through unchanged.
    ///
    /// ## Performance
    ///
    /// This method uses an optimized UTF-8 fast path when possible, providing better performance
    /// than Foundation's `uppercased()`/`lowercased()` for ASCII-only or ASCII-heavy strings.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Works with String
    /// "Hello World".ascii(case: .upper)  // "HELLO WORLD"
    ///
    /// // Works with Substring
    /// "Hello World"[...].ascii(case: .lower)  // "hello world"
    ///
    /// // Unicode safety - non-ASCII preserved
    /// "hello🌍".ascii(case: .upper)      // "HELLO🌍"
    /// ```
    ///
    /// - Parameter case: The target case (`.upper` or `.lower`)
    /// - Returns: New string with ASCII letters converted to the specified case
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/ascii(_:case:)``
    public func ascii(case: Character.Case) -> String {
        INCITS_4_1986.ascii(String(self), case: `case`)
    }
}

// MARK: - Line Ending Normalization

extension StringProtocol {
    /// Normalizes ASCII line endings to the specified style
    ///
    /// Converts all line endings to a consistent format. Recognizes and normalizes
    /// all common ASCII line ending styles: LF (`\n`), CR (`\r`), and CRLF (`\r\n`).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Works with String
    /// "line1\nline2\r\n".normalized(to: .crlf)
    ///
    /// // Works with Substring
    /// "Hello\r\nWorld"[...].normalized(to: .lf)
    /// ```
    ///
    /// - Parameters:
    ///   - lineEnding: Target line ending style (`.lf`, `.cr`, or `.crlf`)
    ///   - encoding: Unicode encoding to use (defaults to UTF-8)
    /// - Returns: New string with all line endings normalized to the specified style
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/normalized(_:to:as:)``
    public func normalized<Encoding>(
        to lineEnding: String.ASCII.LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        INCITS_4_1986.normalized(String(self), to: lineEnding, as: encoding)
    }
}
