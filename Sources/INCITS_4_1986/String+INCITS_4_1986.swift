// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

// MARK: - ASCII Namespace

extension String {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this string
    public var ascii: ASCII {
        ASCII(string: self)
    }

    public struct ASCII {
        public let string: String

        // Internal initializer for StringProtocol (converts to String)
        internal init<S: StringProtocol>(_ value: S) {
            self.string = String(value)
        }

        // Public initializer for String (no conversion needed)
        init(string: String) {
            self.string = string
        }
    }
}

extension String.ASCII {
    // MARK: - Nested Namespaces

    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}

// MARK: - ASCII Line Ending Constants

extension String.ASCII {
    /// LINE FEED string (\\n) - 0x0A
    public static let lf: String = String(decoding: [UInt8.ascii.lf], as: UTF8.self)

    /// CARRIAGE RETURN string (\\r) - 0x0D
    public static let cr: String = String(decoding: [UInt8.ascii.cr], as: UTF8.self)

    /// CRLF string (\\r\\n) - 0x0D 0x0A
    public static let crlf: String = String(decoding: INCITS_4_1986.crlf, as: UTF8.self)
}

// MARK: - ASCII Character Classification

extension String.ASCII {
    /// Returns true if all characters in the string are valid ASCII (U+0000 to U+007F)
    @inlinable
    public var isAllASCII: Bool {
        self.string.utf8.allSatisfy { $0 <= 0x7F }
    }

    /// Returns true if all characters in the string are ASCII whitespace
    @inlinable
    public var isAllWhitespace: Bool {
        !self.string.isEmpty && self.string.allSatisfy { $0.ascii.isWhitespace }
    }

    /// Returns true if all characters in the string are ASCII digits (0-9)
    @inlinable
    public var isAllDigits: Bool {
        !self.string.isEmpty && self.string.allSatisfy { $0.ascii.isDigit }
    }

    /// Returns true if all characters in the string are ASCII letters (A-Z, a-z)
    @inlinable
    public var isAllLetters: Bool {
        !self.string.isEmpty && self.string.allSatisfy { $0.ascii.isLetter }
    }

    /// Returns true if all characters in the string are ASCII alphanumeric (0-9, A-Z, a-z)
    @inlinable
    public var isAllAlphanumeric: Bool {
        !self.string.isEmpty && self.string.allSatisfy { $0.ascii.isAlphanumeric }
    }

    /// Returns true if all characters in the string are ASCII control characters
    @inlinable
    public var isAllControl: Bool {
        !self.string.isEmpty && self.string.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isControl
        }
    }

    /// Returns true if all characters in the string are ASCII visible characters (excludes SPACE)
    @inlinable
    public var isAllVisible: Bool {
        !self.string.isEmpty && self.string.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isVisible
        }
    }

    /// Returns true if all characters in the string are ASCII printable characters (includes SPACE)
    @inlinable
    public var isAllPrintable: Bool {
        !self.string.isEmpty && self.string.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isPrintable
        }
    }

    /// Returns true if the string contains any non-ASCII characters
    @inlinable
    public var containsNonASCII: Bool {
        self.string.utf8.contains { $0 > 0x7F }
    }

    /// Returns true if the string contains any ASCII hexadecimal digit (0-9, A-F, a-f)
    @inlinable
    public var containsHexDigit: Bool {
        self.string.contains { $0.ascii.isHexDigit }
    }
}

// MARK: - ASCII Case Validation

extension String.ASCII {
    /// Returns true if all ASCII letters in the string are lowercase
    ///
    /// Non-letter characters are ignored in the check.
    @inlinable
    public var isAllLowercase: Bool {
        self.string.allSatisfy { char in
            char.ascii.isLetter ? char.ascii.isLowercase : true
        }
    }

    /// Returns true if all ASCII letters in the string are uppercase
    ///
    /// Non-letter characters are ignored in the check.
    @inlinable
    public var isAllUppercase: Bool {
        self.string.allSatisfy { char in
            char.ascii.isLetter ? char.ascii.isUppercase : true
        }
    }
}

// MARK: - ASCII Case Conversion Convenience

extension String.ASCII {
    /// Converts ASCII letters to uppercase
    ///
    /// Convenience method for `ascii(case: .upper)`.
    @inlinable
    public func uppercased() -> String {
        INCITS_4_1986.ascii(self.string, case: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Convenience method for `ascii(case: .lower)`.
    @inlinable
    public func lowercased() -> String {
        INCITS_4_1986.ascii(self.string, case: .lower)
    }
}

// MARK: - ASCII Line Ending Detection

extension String.ASCII {
    /// Returns true if the string contains CRLF (\\r\\n) sequences
    @inlinable
    public var containsCRLF: Bool {
        self.string.contains(.ascii.crlf)
    }

    /// Returns true if the string contains mixed line ending styles
    ///
    /// Detects if the string uses more than one line ending style (LF, CR, CRLF).
    public var containsMixedLineEndings: Bool {
        let hasCRLF = self.string.contains(.ascii.crlf)

        // Check for standalone CR/LF by removing CRLF first
        let withoutCRLF = self.string.replacing(String.ascii.crlf, with: "")
        let hasStandaloneCR = withoutCRLF.contains(String.ascii.cr)
        let hasStandaloneLF = withoutCRLF.contains(String.ascii.lf)

        // Count different types (treating CRLF as one unit)
        let types = [hasCRLF, hasStandaloneCR, hasStandaloneLF].filter { $0 }
        return types.count > 1
    }

    /// Detects the line ending style used in the string
    ///
    /// Returns the first line ending type found, or `nil` if no line endings are present.
    /// Prioritizes CRLF detection since it contains both CR and LF.
    public func detectedLineEnding() -> String.ASCII.LineEnding? {
        if self.string.contains(.ascii.crlf) {
            return .crlf
        } else if self.string.contains(.ascii.cr) {
            return .cr
        } else if self.string.contains(.ascii.lf) {
            return .lf
        }
        return nil
    }
}

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
        lineEnding: String.ASCII.LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        String(decoding: [UInt8].ascii(lineEnding: lineEnding), as: encoding)
    }
}
