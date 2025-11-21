// Substring.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII substring operations

import Standards

// MARK: - ASCII Namespace

extension Substring {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this substring
    public var ascii: ASCII {
        ASCII(substring: self)
    }

    public struct ASCII {
        public let substring: Substring

        init(substring: Substring) {
            self.substring = substring
        }
    }
}

extension Substring.ASCII {
    // MARK: - Nested Namespaces

    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}

// MARK: - ASCII Line Ending Constants

extension Substring.ASCII {
    /// LINE FEED string (\\n) - 0x0A
    public static let lf: String = String(decoding: [UInt8.ascii.lf], as: UTF8.self)

    /// CARRIAGE RETURN string (\\r) - 0x0D
    public static let cr: String = String(decoding: [UInt8.ascii.cr], as: UTF8.self)

    /// CRLF string (\\r\\n) - 0x0D 0x0A
    public static let crlf: String = String(decoding: INCITS_4_1986.crlf, as: UTF8.self)
}

// MARK: - ASCII Character Classification

extension Substring.ASCII {
    /// Returns true if all characters in the substring are valid ASCII (U+0000 to U+007F)
    @inlinable
    public var isAllASCII: Bool {
        self.substring.utf8.allSatisfy { $0 <= 0x7F }
    }

    /// Returns true if all characters in the substring are ASCII whitespace
    @inlinable
    public var isAllWhitespace: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy { $0.ascii.isWhitespace }
    }

    /// Returns true if all characters in the substring are ASCII digits (0-9)
    @inlinable
    public var isAllDigits: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy { $0.ascii.isDigit }
    }

    /// Returns true if all characters in the substring are ASCII letters (A-Z, a-z)
    @inlinable
    public var isAllLetters: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy { $0.ascii.isLetter }
    }

    /// Returns true if all characters in the substring are ASCII alphanumeric (0-9, A-Z, a-z)
    @inlinable
    public var isAllAlphanumeric: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy { $0.ascii.isAlphanumeric }
    }

    /// Returns true if all characters in the substring are ASCII control characters
    @inlinable
    public var isAllControl: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isControl
        }
    }

    /// Returns true if all characters in the substring are ASCII visible characters (excludes SPACE)
    @inlinable
    public var isAllVisible: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isVisible
        }
    }

    /// Returns true if all characters in the substring are ASCII printable characters (includes SPACE)
    @inlinable
    public var isAllPrintable: Bool {
        !self.substring.isEmpty && self.substring.allSatisfy {
            guard let byte = UInt8.ascii($0) else { return false }
            return byte.ascii.isPrintable
        }
    }

    /// Returns true if the substring contains any non-ASCII characters
    @inlinable
    public var containsNonASCII: Bool {
        self.substring.utf8.contains { $0 > 0x7F }
    }

    /// Returns true if the substring contains any ASCII hexadecimal digit (0-9, A-F, a-f)
    @inlinable
    public var containsHexDigit: Bool {
        self.substring.contains { $0.ascii.isHexDigit }
    }
}

// MARK: - ASCII Case Validation

extension Substring.ASCII {
    /// Returns true if all ASCII letters in the substring are lowercase
    ///
    /// Non-letter characters are ignored in the check.
    @inlinable
    public var isAllLowercase: Bool {
        self.substring.allSatisfy { char in
            char.ascii.isLetter ? char.ascii.isLowercase : true
        }
    }

    /// Returns true if all ASCII letters in the substring are uppercase
    ///
    /// Non-letter characters are ignored in the check.
    @inlinable
    public var isAllUppercase: Bool {
        self.substring.allSatisfy { char in
            char.ascii.isLetter ? char.ascii.isUppercase : true
        }
    }
}

// MARK: - ASCII Case Conversion

extension Substring {
    /// Converts ASCII letters to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) in the substring to the specified case, leaving
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
    /// than Foundation's `uppercased()`/`lowercased()` for ASCII-only or ASCII-heavy substrings.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Basic case conversion
    /// let sub = "Hello World"[...]
    /// sub.ascii(case: .upper)  // "HELLO WORLD"
    /// sub.ascii(case: .lower)  // "hello world"
    ///
    /// // Unicode safety - non-ASCII preserved
    /// "hello🌍"[...].ascii(case: .upper)      // "HELLO🌍"
    /// "café"[...].ascii(case: .upper)         // "CAFé" (only ASCII 'c', 'a', 'f' converted)
    ///
    /// // Digits and symbols unchanged
    /// "Test123!"[...].ascii(case: .upper)     // "TEST123!"
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
        INCITS_4_1986.ascii(String(self), case: `case`)
    }
}

// MARK: - ASCII Case Conversion Convenience

extension Substring.ASCII {
    /// Converts ASCII letters to uppercase
    ///
    /// Convenience method for `ascii(case: .upper)`.
    @inlinable
    public func uppercased() -> String {
        INCITS_4_1986.ascii(String(self.substring), case: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Convenience method for `ascii(case: .lower)`.
    @inlinable
    public func lowercased() -> String {
        INCITS_4_1986.ascii(String(self.substring), case: .lower)
    }
}

// MARK: - ASCII Line Ending Detection

extension Substring.ASCII {
    /// Returns true if the substring contains CRLF (\\r\\n) sequences
    @inlinable
    public var containsCRLF: Bool {
        self.substring.contains(.ascii.crlf)
    }

    /// Returns true if the substring contains mixed line ending styles
    ///
    /// Detects if the substring uses more than one line ending style (LF, CR, CRLF).
    public var containsMixedLineEndings: Bool {
        let hasCRLF = self.substring.contains(.ascii.crlf)

        // Check for standalone CR/LF by removing CRLF first
        let withoutCRLF = self.substring.replacing(String.ascii.crlf, with: "")
        let hasStandaloneCR = withoutCRLF.contains(String.ascii.cr)
        let hasStandaloneLF = withoutCRLF.contains(String.ascii.lf)

        // Count different types (treating CRLF as one unit)
        let types = [hasCRLF, hasStandaloneCR, hasStandaloneLF].filter { $0 }
        return types.count > 1
    }

    /// Detects the line ending style used in the substring
    ///
    /// Returns the first line ending type found, or `nil` if no line endings are present.
    /// Prioritizes CRLF detection since it contains both CR and LF.
    public func detectedLineEnding() -> String.ASCII.LineEnding? {
        if self.substring.contains(.ascii.crlf) {
            return .crlf
        } else if self.substring.contains(.ascii.cr) {
            return .cr
        } else if self.substring.contains(.ascii.lf) {
            return .lf
        }
        return nil
    }
}

// MARK: - Substring Trimming

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
