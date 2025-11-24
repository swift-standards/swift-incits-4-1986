//
//  File.swift
//  swift-incits-4-1986
//
//  Created by Coen ten Thije Boonkkamp on 22/11/2025.
//

extension StringProtocol {
    /// Access to ASCII type-level constants and methods
    public static var ascii: INCITS_4_1986.ASCII<Self>.Type {
        INCITS_4_1986.ASCII<Self>.self
    }

    /// Access to ASCII instance methods for this string
    public var ascii: INCITS_4_1986.ASCII<Self> {
        INCITS_4_1986.ASCII(self)
    }
}

extension INCITS_4_1986.ASCII {
    /// Returns the string if all characters are ASCII, nil otherwise
    ///
    /// Validates that all characters are in the ASCII range.
    ///
    /// ```swift
    /// let valid = "Hello"
    /// valid.ascii()  // Optional("Hello")
    ///
    /// let invalid = "Hello🌍"
    /// invalid.ascii()  // nil
    /// ```
    @inlinable
    public func callAsFunction() -> S? {
        INCITS_4_1986.StringClassification.isAllASCII(self.value) ? self.value : nil
    }

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
    @inlinable
    public func callAsFunction(case: Character.Case) -> S {
        INCITS_4_1986.convert(self.value, to: `case`)
    }

    /// Converts ASCII letters to uppercase
    ///
    /// Convenience method for `ascii(case: .upper)`.
    @inlinable
    public func uppercased() -> S {
        INCITS_4_1986.convert(self.value, to: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Convenience method for `ascii(case: .lower)`.
    @inlinable
    public func lowercased() -> S {
        INCITS_4_1986.convert(self.value, to: .lower)
    }
}

extension StringProtocol {
    /// Trims characters from both ends of the string
    ///
    /// Returns a zero-copy view (SubSequence) with the specified characters trimmed.
    /// If you need an owned String, explicitly convert: `String(result)`.
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    public static func trimming(_ string: Self, of characterSet: Set<Character>) -> String {
        String(INCITS_4_1986.trimming(string, of: characterSet))
    }

    /// Trims characters from both ends of the string
    ///
    /// Returns a zero-copy view (SubSequence) with the specified characters trimmed.
    /// If you need an owned String, explicitly convert: `String(result)`.
    ///
    /// Convenience method that delegates to `INCITS_4_1986.trimming(_:of:)`.
    public func trimming(_ characterSet: Set<Character>) -> String {
        String(INCITS_4_1986.trimming(self, of: characterSet))
    }
}

extension StringProtocol {

    /// Normalizes ASCII line endings in string to the specified style
    ///
    /// Convenience method that delegates to byte-level `normalized(_:to:)`.
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.normalized("line1\nline2\r\nline3", to: .crlf)
    /// // "line1\r\nline2\r\nline3"
    /// ```
    public static func normalized<S: StringProtocol>(
        _ s: S,
        to lineEnding: INCITS_4_1986.FormatEffectors.LineEnding
    ) -> S {
        return .init(decoding: INCITS_4_1986.normalized([UInt8](s.utf8), to: lineEnding), as: UTF8.self)
    }

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
    public func normalized(
        to lineEnding: INCITS_4_1986.FormatEffectors.LineEnding
    ) -> Self {
        Self.normalized(self, to: lineEnding)
    }
}

extension StringProtocol {
    /// Creates some StringProtocol from a line ending constant
    ///
    /// Transforms a line ending enumeration value into its corresponding
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
    /// let unix = String(ascii: .lf)      // "\n"
    /// let mac = String(ascii: .cr)       // "\r"
    /// let windows = String(ascii: .crlf) // "\r\n"
    ///
    /// // Use in string concatenation
    /// let line1 = "First line"
    /// let line2 = "Second line"
    /// let text = line1 + String(ascii: .crlf) + line2
    /// // "First line\r\nSecond line"
    ///
    /// // Build multi-line text with consistent endings
    /// let lines = ["Header", "Content", "Footer"]
    /// let document = lines.joined(separator: String(ascii: .crlf))
    /// ```
    ///
    /// - Parameter ascii: The line ending style to convert to some StringProtocol
    /// - Returns: String containing the line ending character(s)
    ///
    /// ## See Also
    ///
    /// - ``LineEnding``
    /// - ``INCITS_4_1986/crlf``
    /// - ``normalized(to:as:)``
    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.LineEnding) {
        self.init(decoding: [UInt8](ascii: lineEnding), as: UTF8.self)
    }
}

extension StringProtocol {
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
    /// use ``String/ascii/unchecked(_:)`` to skip validation and improve performance.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Valid ASCII bytes
    /// let hello = String(ascii: [104, 101, 108, 108, 111])  // "hello"
    ///
    /// // Using INCITS constants
    /// let bytes: [UInt8] = [
    ///     INCITS_4_1986.GraphicCharacters.H,
    ///     INCITS_4_1986.GraphicCharacters.i
    /// ]
    /// let text = String(ascii: bytes)  // "Hi"
    ///
    /// // Invalid ASCII bytes
    /// String(ascii: [255])  // nil (0xFF is not valid 7-bit ASCII)
    /// String(ascii: [0x80]) // nil (high bit set)
    /// ```
    ///
    /// - Parameter ascii: Array of bytes to validate and decode as ASCII
    /// - Returns: String if all bytes are valid ASCII (0x00-0x7F), `nil` otherwise
    ///
    /// ## See Also
    ///
    /// - ``String/ascii/unchecked(_:)``
    /// - ``INCITS_4_1986``
    public init?(ascii bytes: [UInt8]) {
        guard bytes.ascii.isAllASCII else { return nil }
        self.init(decoding: bytes, as: UTF8.self)
    }
}

extension INCITS_4_1986.ASCII {
    /// Creates a string from bytes without ASCII validation
    ///
    /// Constructs a String from a byte array, assuming all bytes are valid ASCII without validation.
    /// This method provides optimal performance when the caller can guarantee ASCII validity.
    ///
    /// ## Performance
    ///
    /// This method skips the O(n) ASCII validation check, making it more efficient than the
    /// failable initializer `String(ascii:)` when you know all bytes are valid ASCII.
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
    /// let text = String.ascii.unchecked(bytes)  // "hello"
    ///
    /// // Using INCITS constants (known ASCII)
    /// let greeting: [UInt8] = [
    ///     INCITS_4_1986.GraphicCharacters.H,
    ///     INCITS_4_1986.GraphicCharacters.i,
    ///     INCITS_4_1986.SPACE.sp
    /// ]
    /// let text = String.ascii.unchecked(greeting)  // "Hi "
    /// ```
    ///
    /// - Parameter bytes: Array of bytes to decode as ASCII (assumed valid, no checking performed)
    /// - Returns: String decoded from the bytes
    ///
    /// ## See Also
    ///
    /// - ``StringProtocol/init(ascii:)``
    /// - ``INCITS_4_1986``
    public static func unchecked(_ bytes: [UInt8]) -> S {
        S(decoding: bytes, as: UTF8.self)
    }

    /// Detects the line ending style used in the string
    ///
    /// Returns the first line ending type found, or `nil` if no line endings are present.
    /// Prioritizes CRLF detection since it contains both CR and LF.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/LineEndingDetection/detect(_:)``
    public func detectedLineEnding() -> INCITS_4_1986.FormatEffectors.LineEnding? {
        INCITS_4_1986.LineEndingDetection.detect(self.value)
    }
}
