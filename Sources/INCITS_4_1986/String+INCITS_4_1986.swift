// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

// MARK: - ASCII String Creation

extension String {
    /// Creates a string from ASCII bytes with validation
    ///
    /// Constructs a String from a byte array, returning `nil` if any byte is outside the valid
    /// US-ASCII range (0x00-0x7F). This method ensures that only valid 7-bit ASCII data is
    /// converted to a string.
    ///
    /// ## Validation
    ///
    /// The method validates that all bytes fall within the ASCII range before decoding.
    /// Any byte with the high bit set (>= 0x80) will cause validation to fail and return `nil`.
    ///
    /// ## Performance
    ///
    /// This method performs O(n) validation before string construction. For known-valid ASCII data,
    /// use ``ascii(unchecked:)`` to skip validation and improve performance.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Valid ASCII bytes
    /// let hello = String.ascii([104, 101, 108, 108, 111])  // "hello"
    ///
    /// // Using INCITS constants
    /// let bytes: [UInt8] = [
    ///     INCITS_4_1986.GraphicCharacters.H,
    ///     INCITS_4_1986.GraphicCharacters.i
    /// ]
    /// let text = String.ascii(bytes)  // "Hi"
    ///
    /// // Invalid ASCII bytes
    /// String.ascii([255])  // nil (0xFF is not valid 7-bit ASCII)
    /// String.ascii([0x80]) // nil (high bit set)
    /// ```
    ///
    /// - Parameter bytes: Array of bytes to validate and decode as ASCII
    /// - Returns: String if all bytes are valid ASCII (0x00-0x7F), `nil` otherwise
    ///
    /// ## See Also
    ///
    /// - ``ascii(unchecked:)``
    /// - ``INCITS_4_1986``
    public static func ascii(_ bytes: [UInt8]) -> String? {
        guard bytes.ascii.isAllASCII else { return nil }
        return String(decoding: bytes, as: UTF8.self)
    }

    /// Creates a string from bytes without ASCII validation
    ///
    /// Constructs a String from a byte array, assuming all bytes are valid ASCII without validation.
    /// This method provides optimal performance when the caller can guarantee ASCII validity.
    ///
    /// ## Performance
    ///
    /// This method skips the O(n) ASCII validation check, making it more efficient than ``ascii(_:)``
    /// when you know all bytes are valid ASCII. However, using this with non-ASCII bytes may produce
    /// unexpected results.
    ///
    /// ## Safety
    ///
    /// **Important**: This method does not validate the input. Passing non-ASCII bytes (>= 0x80)
    /// will not cause a runtime error, but the resulting string may contain multi-byte UTF-8
    /// sequences that were not intended.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // When you know bytes are ASCII
    /// let bytes: [UInt8] = [104, 101, 108, 108, 111]
    /// let text = String.ascii(unchecked: bytes)  // "hello"
    ///
    /// // Using INCITS constants (known ASCII)
    /// let greeting: [UInt8] = [
    ///     INCITS_4_1986.GraphicCharacters.H,
    ///     INCITS_4_1986.GraphicCharacters.i,
    ///     INCITS_4_1986.SPACE.sp
    /// ]
    /// let text = String.ascii(unchecked: greeting)  // "Hi "
    /// ```
    ///
    /// - Parameter bytes: Array of bytes to decode as ASCII (assumed valid, no checking performed)
    /// - Returns: String decoded from the bytes
    ///
    /// ## See Also
    ///
    /// - ``ascii(_:)``
    /// - ``INCITS_4_1986``
    public static func ascii(unchecked bytes: [UInt8]) -> String {
        String(decoding: bytes, as: UTF8.self)
    }

}

// MARK: - ASCII Case Conversion

extension String {
    /// Converts ASCII letters to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) in the string to the specified case, leaving
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
    /// // Basic case conversion
    /// "Hello World".ascii(case: .upper)  // "HELLO WORLD"
    /// "Hello World".ascii(case: .lower)  // "hello world"
    ///
    /// // Unicode safety - non-ASCII preserved
    /// "hello🌍".ascii(case: .upper)      // "HELLO🌍"
    /// "café".ascii(case: .upper)         // "CAFé" (only ASCII 'c', 'a', 'f' converted)
    ///
    /// // Digits and symbols unchanged
    /// "Test123!".ascii(case: .upper)     // "TEST123!"
    /// ```
    ///
    /// - Parameter case: The target case (`.upper` or `.lower`)
    /// - Returns: New string with ASCII letters converted to the specified case
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/ascii(_:case:)``
    /// - ``INCITS_4_1986/caseConversionOffset``
    /// - ``Character/Case``
    public func ascii(case: Character.Case) -> String {
        INCITS_4_1986.ascii(self, case: `case`)
    }
}

// MARK: - String Trimming

extension String {
    /// Trims characters from both ends of the string (static variant)
    ///
    /// Removes all occurrences of characters in the specified set from both the leading and
    /// trailing edges of the string. Characters in the middle of the string are never removed.
    ///
    /// ## Performance
    ///
    /// This method uses an optimized UTF-8 fast path when trimming ASCII characters (including
    /// ASCII whitespace), providing significantly better performance than Foundation's trimming
    /// methods for ASCII-heavy strings.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Trim ASCII whitespace
    /// let text = "  Hello World  "
    /// String.trimming(text, of: .ascii.whitespaces)  // "Hello World"
    ///
    /// // Trim custom character set
    /// let padded = "***important***"
    /// String.trimming(padded, of: ["*"])  // "important"
    ///
    /// // Only edges are trimmed
    /// let spaced = "  Hello  World  "
    /// String.trimming(spaced, of: .ascii.whitespaces)  // "Hello  World"
    /// ```
    ///
    /// - Parameters:
    ///   - string: The string to trim
    ///   - characterSet: Set of characters to remove from both ends
    /// - Returns: New string with specified characters removed from both edges
    ///
    /// ## See Also
    ///
    /// - ``trimming(_:)``
    /// - ``INCITS_4_1986/trimming(_:of:)``
    /// - ``INCITS_4_1986/whitespaces``
    public static func trimming(_ string: String, of characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(string[...], of: characterSet)
    }

    /// Trims characters from both ends of the string (instance method)
    ///
    /// Removes all occurrences of characters in the specified set from both the leading and
    /// trailing edges of the string. Characters in the middle of the string are never removed.
    ///
    /// ## Performance
    ///
    /// This method uses an optimized UTF-8 fast path when trimming ASCII characters (including
    /// ASCII whitespace), providing significantly better performance than Foundation's trimming
    /// methods for ASCII-heavy strings.
    ///
    /// The `@inlinable` attribute allows the compiler to inline this method at call sites,
    /// eliminating function call overhead for maximum performance.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Trim ASCII whitespace
    /// let text = "  Hello World  "
    /// text.trimming(.ascii.whitespaces)  // "Hello World"
    ///
    /// // Trim with tabs and newlines
    /// let messy = "\t\n  Clean Text  \n\t"
    /// messy.trimming(.ascii.whitespaces)  // "Clean Text"
    ///
    /// // Trim custom characters
    /// let quoted = "\"hello\""
    /// quoted.trimming(["\""])  // "hello"
    /// ```
    ///
    /// - Parameter characterSet: Set of characters to remove from both ends
    /// - Returns: New string with specified characters removed from both edges
    ///
    /// ## See Also
    ///
    /// - ``trimming(_:of:)``
    /// - ``INCITS_4_1986/trimming(_:of:)``
    /// - ``INCITS_4_1986/whitespaces``
    @inlinable
    public func trimming(_ characterSet: Set<Character>) -> String {
        INCITS_4_1986.trimming(self[...], of: characterSet)
    }
}

// MARK: - Line Ending Normalization

extension String {
    /// Normalizes ASCII line endings to the specified style
    ///
    /// Converts all line endings in the string to a consistent format. Recognizes and normalizes
    /// all common ASCII line ending styles: LF (`\n`), CR (`\r`), and CRLF (`\r\n`).
    ///
    /// ## Line Ending Recognition
    ///
    /// The method intelligently handles all three ASCII line ending styles:
    /// - **LF** (0x0A): Unix, Linux, macOS line ending
    /// - **CR** (0x0D): Classic Mac OS line ending
    /// - **CRLF** (0x0D 0x0A): Windows, Internet protocols line ending
    ///
    /// Mixed line endings are supported - the method will normalize them all to the target style.
    ///
    /// ## Internet Protocol Compliance
    ///
    /// Many Internet protocols require CRLF line endings per their RFCs:
    /// - HTTP (RFC 9112)
    /// - SMTP (RFC 5321)
    /// - FTP (RFC 959)
    /// - MIME (RFC 2045)
    ///
    /// Use `.crlf` normalization when preparing text for network transmission.
    ///
    /// ## Performance
    ///
    /// This method uses optimized UTF-8 processing when possible, providing efficient normalization
    /// even for large text files.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Normalize mixed line endings to CRLF
    /// let text = "line1\nline2\r\nline3\rline4"
    /// text.normalized(to: .crlf)  // "line1\r\nline2\r\nline3\r\nline4"
    ///
    /// // Normalize to Unix-style LF
    /// let windows = "Hello\r\nWorld\r\n"
    /// windows.normalized(to: .lf)  // "Hello\nWorld\n"
    ///
    /// // Prepare for HTTP transmission
    /// let httpBody = "Header: Value\nContent"
    /// httpBody.normalized(to: .crlf)  // "Header: Value\r\nContent"
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
    /// - ``LineEnding``
    /// - ``INCITS_4_1986/crlf``
    public func normalized<Encoding>(
        to lineEnding: LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        INCITS_4_1986.normalized(self, to: lineEnding, as: encoding)
    }
}

// MARK: - Line Ending String Creation

extension String {
    /// Creates a string from a line ending constant
    ///
    /// Pure function that transforms a line ending enumeration value into its corresponding
    /// string representation. This is useful when you need the actual line ending characters
    /// as a string rather than as byte arrays.
    ///
    /// ## Line Ending Values
    ///
    /// - **`.lf`**: Returns `"\n"` (Line Feed, 0x0A)
    /// - **`.cr`**: Returns `"\r"` (Carriage Return, 0x0D)
    /// - **`.crlf`**: Returns `"\r\n"` (Carriage Return + Line Feed, 0x0D 0x0A)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Get line ending strings
    /// let unix = String.ascii(lineEnding: .lf)      // "\n"
    /// let mac = String.ascii(lineEnding: .cr)       // "\r"
    /// let windows = String.ascii(lineEnding: .crlf) // "\r\n"
    ///
    /// // Use in string concatenation
    /// let line1 = "First line"
    /// let line2 = "Second line"
    /// let text = line1 + String.ascii(lineEnding: .crlf) + line2
    /// // "First line\r\nSecond line"
    ///
    /// // Build multi-line text with consistent endings
    /// let lines = ["Header", "Content", "Footer"]
    /// let document = lines.joined(separator: String.ascii(lineEnding: .crlf))
    /// ```
    ///
    /// - Parameters:
    ///   - lineEnding: The line ending style to convert to a string
    ///   - encoding: Unicode encoding to use (defaults to UTF-8)
    /// - Returns: String containing the line ending character(s)
    ///
    /// ## See Also
    ///
    /// - ``LineEnding``
    /// - ``INCITS_4_1986/crlf``
    /// - ``normalized(to:as:)``
    public static func ascii<Encoding>(
        lineEnding: LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        String(decoding: [UInt8].ascii(lineEnding: lineEnding), as: encoding)
    }
}
