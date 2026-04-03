// INCITS_4_1986.Text.Classification.swift
// swift-incits-4-1986
//
// INCITS 4-1986: Text Classification Operations
// Authoritative predicates for testing properties of strings

import Standard_Library_Extensions

extension INCITS_4_1986.Text {
    /// Text Classification Operations
    ///
    /// Authoritative implementations of string-level classification tests per INCITS 4-1986.
    /// All string predicates are defined here as the single source of truth.
    ///
    /// These operations test properties of entire strings, delegating to the byte-level
    /// classification operations for individual character tests.
    public enum Classification {}
}

extension INCITS_4_1986.Text.Classification {
    // MARK: - ASCII Validation

    /// Tests if all bytes in the UTF-8 representation are valid ASCII (0x00-0x7F)
    ///
    /// Returns `true` if every byte in the string's UTF-8 encoding has the high bit clear,
    /// indicating valid 7-bit US-ASCII encoding.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllASCII("Hello")     // true
    /// INCITS_4_1986.Text.Classification.isAllASCII("café")      // false (é is U+00E9)
    /// INCITS_4_1986.Text.Classification.isAllASCII("Hello🌍")   // false (emoji)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all bytes are in the ASCII range (0x00-0x7F)
    @inlinable
    public static func isAllASCII<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { $0 <= 0x7F }
    }

    /// Tests if the string contains any non-ASCII characters
    ///
    /// Returns `true` if any byte in the string's UTF-8 encoding has the high bit set,
    /// indicating the presence of characters outside the 7-bit US-ASCII range.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.containsNonASCII("Hello")     // false
    /// INCITS_4_1986.Text.Classification.containsNonASCII("café")      // true
    /// INCITS_4_1986.Text.Classification.containsNonASCII("Hello🌍")   // true
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if any byte is outside the ASCII range (>= 0x80)
    @inlinable
    public static func containsNonASCII<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.contains { $0 > 0x7F }
    }

    // MARK: - Character Class Tests

    /// Tests if all characters in the string are ASCII whitespace
    ///
    /// Returns `true` if every character is one of the four ASCII whitespace characters:
    /// SPACE, TAB, LF, or CR.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllWhitespace("   ")      // true
    /// INCITS_4_1986.Text.Classification.isAllWhitespace("\t\n")     // true
    /// INCITS_4_1986.Text.Classification.isAllWhitespace("")         // true (vacuous truth)
    /// INCITS_4_1986.Text.Classification.isAllWhitespace(" a ")      // false
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII whitespace (vacuous truth for empty strings)
    @inlinable
    public static func isAllWhitespace<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isWhitespace(byte)
        }
    }

    /// Tests if all characters in the string are ASCII digits (0-9)
    ///
    /// Returns `true` if every character is an ASCII digit.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllDigits("12345")    // true
    /// INCITS_4_1986.Text.Classification.isAllDigits("123a45")   // false
    /// INCITS_4_1986.Text.Classification.isAllDigits("")         // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII digits (vacuous truth for empty strings)
    @inlinable
    public static func isAllDigits<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isDigit(byte)
        }
    }

    /// Tests if all characters in the string are ASCII letters (A-Z, a-z)
    ///
    /// Returns `true` if every character is an ASCII letter.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllLetters("Hello")    // true
    /// INCITS_4_1986.Text.Classification.isAllLetters("Hello123") // false
    /// INCITS_4_1986.Text.Classification.isAllLetters("")         // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII letters (vacuous truth for empty strings)
    @inlinable
    public static func isAllLetters<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isLetter(byte)
        }
    }

    /// Tests if all characters in the string are ASCII alphanumeric (0-9, A-Z, a-z)
    ///
    /// Returns `true` if every character is either an ASCII digit or letter.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllAlphanumeric("Hello123")  // true
    /// INCITS_4_1986.Text.Classification.isAllAlphanumeric("Hello-123") // false
    /// INCITS_4_1986.Text.Classification.isAllAlphanumeric("")          // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII alphanumeric (vacuous truth for empty strings)
    @inlinable
    public static func isAllAlphanumeric<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isAlphanumeric(byte)
        }
    }

    /// Tests if all characters in the string are ASCII control characters
    ///
    /// Returns `true` if every character is an ASCII control character (0x00-0x1F or 0x7F).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllControl("\t\n")    // true
    /// INCITS_4_1986.Text.Classification.isAllControl("\tA")     // false
    /// INCITS_4_1986.Text.Classification.isAllControl("")        // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII control characters (vacuous truth for empty strings)
    @inlinable
    public static func isAllControl<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isControl(byte)
        }
    }

    /// Tests if all characters in the string are ASCII visible characters (excludes SPACE)
    ///
    /// Returns `true` if every character is a visible ASCII graphic character (0x21-0x7E).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllVisible("Hello!")   // true
    /// INCITS_4_1986.Text.Classification.isAllVisible("Hello ")   // false (contains SPACE)
    /// INCITS_4_1986.Text.Classification.isAllVisible("")         // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII visible characters (vacuous truth for empty strings)
    @inlinable
    public static func isAllVisible<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isVisible(byte)
        }
    }

    /// Tests if all characters in the string are ASCII printable characters (includes SPACE)
    ///
    /// Returns `true` if every character is a printable ASCII graphic character (0x20-0x7E).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllPrintable("Hello World")  // true
    /// INCITS_4_1986.Text.Classification.isAllPrintable("Hello\n")      // false (contains LF)
    /// INCITS_4_1986.Text.Classification.isAllPrintable("")             // true (vacuous truth)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all characters are ASCII printable characters (vacuous truth for empty strings)
    @inlinable
    public static func isAllPrintable<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isPrintable(byte)
        }
    }

    /// Tests if the string contains any ASCII hexadecimal digit (0-9, A-F, a-f)
    ///
    /// Returns `true` if at least one character is a valid hexadecimal digit.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.containsHexDigit("0x1A")     // true
    /// INCITS_4_1986.Text.Classification.containsHexDigit("Hello")    // false
    /// INCITS_4_1986.Text.Classification.containsHexDigit("")         // false
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if the string contains at least one hex digit
    @inlinable
    public static func containsHexDigit<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.contains { byte in
            INCITS_4_1986.Classification.isHexDigit(byte)
        }
    }

    // MARK: - Case Tests

    /// Tests if all ASCII letters in the string are lowercase
    ///
    /// Non-letter characters are ignored in the check. Returns `true` if there are no
    /// uppercase ASCII letters.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllLowercase("hello")      // true
    /// INCITS_4_1986.Text.Classification.isAllLowercase("hello123")   // true (digits ignored)
    /// INCITS_4_1986.Text.Classification.isAllLowercase("Hello")      // false
    /// INCITS_4_1986.Text.Classification.isAllLowercase("123")        // true (no letters)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all ASCII letters are lowercase (non-letters ignored)
    @inlinable
    public static func isAllLowercase<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            // Non-ASCII bytes (>= 0x80) are ignored (return true)
            guard byte < 0x80 else { return true }
            return INCITS_4_1986.Classification.isLetter(byte)
                ? INCITS_4_1986.Classification.isLowercase(byte)
                : true
        }
    }

    /// Tests if all ASCII letters in the string are uppercase
    ///
    /// Non-letter characters are ignored in the check. Returns `true` if there are no
    /// lowercase ASCII letters.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.Text.Classification.isAllUppercase("HELLO")      // true
    /// INCITS_4_1986.Text.Classification.isAllUppercase("HELLO123")   // true (digits ignored)
    /// INCITS_4_1986.Text.Classification.isAllUppercase("Hello")      // false
    /// INCITS_4_1986.Text.Classification.isAllUppercase("123")        // true (no letters)
    /// ```
    ///
    /// - Parameter string: The string to test
    /// - Returns: `true` if all ASCII letters are uppercase (non-letters ignored)
    @inlinable
    public static func isAllUppercase<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            // Non-ASCII bytes (>= 0x80) are ignored (return true)
            guard byte < 0x80 else { return true }
            return INCITS_4_1986.Classification.isLetter(byte)
                ? INCITS_4_1986.Classification.isUppercase(byte)
                : true
        }
    }
}
