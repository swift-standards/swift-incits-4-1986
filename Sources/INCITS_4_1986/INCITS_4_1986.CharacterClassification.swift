// INCITS_4_1986.CharacterClassification.swift
// swift-incits-4-1986
//
// INCITS 4-1986 Section 4: Character Classification
// Authoritative predicates for testing ASCII byte properties

import Standards

extension INCITS_4_1986 {
    /// Character Classification Operations
    ///
    /// Authoritative implementations of character class tests per INCITS 4-1986.
    /// All classification predicates are defined here as the single source of truth.
    ///
    /// Per the standard:
    /// - Control Characters: 0x00-0x1F, 0x7F (33 total)
    /// - Graphic Characters: 0x20-0x7E (95 total)
    /// - Whitespace: 0x20, 0x09, 0x0A, 0x0D (4 total)
    /// - Digits: 0x30-0x39 ('0'-'9')
    /// - Letters: 0x41-0x5A ('A'-'Z') and 0x61-0x7A ('a'-'z')
    public enum CharacterClassification {}
}

extension INCITS_4_1986.CharacterClassification {
    // MARK: - Whitespace Classification

    /// Tests if byte is ASCII whitespace
    ///
    /// Returns `true` for the four ASCII whitespace characters defined in INCITS 4-1986:
    /// - **SPACE** (0x20): Word separator
    /// - **HORIZONTAL TAB** (0x09): Tabulation
    /// - **LINE FEED** (0x0A): End of line (Unix/macOS)
    /// - **CARRIAGE RETURN** (0x0D): End of line (classic Mac, Internet protocols)
    ///
    /// ## Performance
    ///
    /// Uses four inline equality comparisons rather than a Set lookup for optimal performance.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isWhitespace(0x20)    // true (SPACE)
    /// INCITS_4_1986.CharacterClassification.isWhitespace(0x09)    // true (TAB)
    /// INCITS_4_1986.CharacterClassification.isWhitespace(0x41)    // false ('A')
    /// ```
    @_transparent
    public static func isWhitespace(_ byte: UInt8) -> Bool {
        byte == INCITS_4_1986.SPACE.sp
            || byte == INCITS_4_1986.ControlCharacters.htab
            || byte == INCITS_4_1986.ControlCharacters.lf
            || byte == INCITS_4_1986.ControlCharacters.cr
    }

    // MARK: - Control Character Classification

    /// Tests if byte is ASCII control character
    ///
    /// Returns `true` for all 33 control characters defined in INCITS 4-1986:
    /// - **C0 controls**: 0x00-0x1F (NULL, SOH, STX, ..., US)
    /// - **DELETE**: 0x7F
    ///
    /// ## Control Character Ranges
    ///
    /// - **0x00 (NUL)** through **0x1F (US)**: 32 control characters
    /// - **0x7F (DEL)**: The DELETE character
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isControl(0x00)    // true (NUL)
    /// INCITS_4_1986.CharacterClassification.isControl(0x0A)    // true (LF)
    /// INCITS_4_1986.CharacterClassification.isControl(0x7F)    // true (DEL)
    /// INCITS_4_1986.CharacterClassification.isControl(0x41)    // false ('A')
    /// ```
    @_transparent
    public static func isControl(_ byte: UInt8) -> Bool {
        byte <= INCITS_4_1986.ControlCharacters.us || byte == INCITS_4_1986.ControlCharacters.del
    }

    // MARK: - Graphic Character Classification

    /// Tests if byte is ASCII visible (non-whitespace printable) character
    ///
    /// Returns `true` for visible graphic characters (0x21-0x7E), which are printable characters
    /// **excluding SPACE**. These are characters with distinct visual glyphs.
    ///
    /// ## Character Range
    ///
    /// - **0x21 ('!')** through **0x7E ('~')**: 94 visible characters
    /// - Includes: digits, letters, punctuation, and symbols
    /// - Excludes: SPACE (0x20), all control characters, and DELETE (0x7F)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isVisible(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isVisible(0x30)    // true ('0')
    /// INCITS_4_1986.CharacterClassification.isVisible(0x20)    // false (SPACE)
    /// ```
    @_transparent
    public static func isVisible(_ byte: UInt8) -> Bool {
        byte >= INCITS_4_1986.GraphicCharacters.exclamationPoint
            && byte <= INCITS_4_1986.GraphicCharacters.tilde
    }

    /// Tests if byte is ASCII printable (graphic) character
    ///
    /// Returns `true` for all printable graphic characters (0x20-0x7E), which includes both
    /// visible characters and SPACE. These are the 95 characters that can appear in displayed text.
    ///
    /// ## Character Range
    ///
    /// - **0x20 (SPACE)** through **0x7E ('~')**: 95 printable characters
    /// - Includes: SPACE, digits, letters, punctuation, and symbols
    /// - Excludes: Control characters (0x00-0x1F) and DELETE (0x7F)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isPrintable(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isPrintable(0x20)    // true (SPACE)
    /// INCITS_4_1986.CharacterClassification.isPrintable(0x0A)    // false (LF)
    /// ```
    @_transparent
    public static func isPrintable(_ byte: UInt8) -> Bool {
        byte >= INCITS_4_1986.SPACE.sp && byte <= INCITS_4_1986.GraphicCharacters.tilde
    }

    // MARK: - Digit Classification

    /// Tests if byte is ASCII digit ('0'...'9')
    ///
    /// Returns `true` for bytes in the range 0x30-0x39.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isDigit(0x30)    // true ('0')
    /// INCITS_4_1986.CharacterClassification.isDigit(0x39)    // true ('9')
    /// INCITS_4_1986.CharacterClassification.isDigit(0x41)    // false ('A')
    /// ```
    @_transparent
    public static func isDigit(_ byte: UInt8) -> Bool {
        byte >= INCITS_4_1986.GraphicCharacters.`0` && byte <= INCITS_4_1986.GraphicCharacters.`9`
    }

    /// Tests if byte is ASCII hexadecimal digit ('0'...'9', 'A'...'F', 'a'...'f')
    ///
    /// Returns `true` for bytes that represent valid hexadecimal digits in either case.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isHexDigit(0x30)    // true ('0')
    /// INCITS_4_1986.CharacterClassification.isHexDigit(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isHexDigit(0x61)    // true ('a')
    /// INCITS_4_1986.CharacterClassification.isHexDigit(0x47)    // false ('G')
    /// ```
    @inlinable
    public static func isHexDigit(_ byte: UInt8) -> Bool {
        isDigit(byte)
            || (byte >= INCITS_4_1986.GraphicCharacters.A && byte <= INCITS_4_1986.GraphicCharacters.F)
            || (byte >= INCITS_4_1986.GraphicCharacters.a && byte <= INCITS_4_1986.GraphicCharacters.f)
    }

    // MARK: - Letter Classification

    /// Tests if byte is ASCII letter ('A'...'Z' or 'a'...'z')
    ///
    /// Returns `true` for uppercase letters (0x41-0x5A) or lowercase letters (0x61-0x7A).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isLetter(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isLetter(0x61)    // true ('a')
    /// INCITS_4_1986.CharacterClassification.isLetter(0x30)    // false ('0')
    /// ```
    @_transparent
    public static func isLetter(_ byte: UInt8) -> Bool {
        (byte >= INCITS_4_1986.GraphicCharacters.A && byte <= INCITS_4_1986.GraphicCharacters.Z)
            || (byte >= INCITS_4_1986.GraphicCharacters.a && byte <= INCITS_4_1986.GraphicCharacters.z)
    }

    /// Tests if byte is ASCII uppercase letter ('A'...'Z')
    ///
    /// Returns `true` for bytes in the range 0x41-0x5A.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isUppercase(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isUppercase(0x5A)    // true ('Z')
    /// INCITS_4_1986.CharacterClassification.isUppercase(0x61)    // false ('a')
    /// ```
    @_transparent
    public static func isUppercase(_ byte: UInt8) -> Bool {
        byte >= INCITS_4_1986.GraphicCharacters.A && byte <= INCITS_4_1986.GraphicCharacters.Z
    }

    /// Tests if byte is ASCII lowercase letter ('a'...'z')
    ///
    /// Returns `true` for bytes in the range 0x61-0x7A.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isLowercase(0x61)    // true ('a')
    /// INCITS_4_1986.CharacterClassification.isLowercase(0x7A)    // true ('z')
    /// INCITS_4_1986.CharacterClassification.isLowercase(0x41)    // false ('A')
    /// ```
    @_transparent
    public static func isLowercase(_ byte: UInt8) -> Bool {
        byte >= INCITS_4_1986.GraphicCharacters.a && byte <= INCITS_4_1986.GraphicCharacters.z
    }

    /// Tests if byte is ASCII alphanumeric (digit or letter)
    ///
    /// Returns `true` if the byte is either a digit or a letter (uppercase or lowercase).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// INCITS_4_1986.CharacterClassification.isAlphanumeric(0x41)    // true ('A')
    /// INCITS_4_1986.CharacterClassification.isAlphanumeric(0x30)    // true ('0')
    /// INCITS_4_1986.CharacterClassification.isAlphanumeric(0x21)    // false ('!')
    /// ```
    @inlinable
    public static func isAlphanumeric(_ byte: UInt8) -> Bool {
        isDigit(byte) || isLetter(byte)
    }
}
