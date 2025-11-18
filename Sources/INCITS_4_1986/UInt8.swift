// UInt8.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII byte-level operations

import Standards

extension UInt8 {
    // MARK: - ASCII Control Character Constants (INCITS 4-1986 Section 4)

    /// NULL character (0x00)
    public static let nul: UInt8 = 0x00

    /// HORIZONTAL TAB (0x09)
    public static let htab: UInt8 = 0x09

    /// LINE FEED (0x0A)
    public static let lf: UInt8 = 0x0A

    /// CARRIAGE RETURN (0x0D)
    public static let cr: UInt8 = 0x0D

    /// SPACE (0x20)
    public static let sp: UInt8 = 0x20
    public static let space: UInt8 = sp

    /// DELETE (0x7F)
    public static let del: UInt8 = 0x7F

    // MARK: - ASCII Punctuation and Symbols

    /// QUOTATION MARK / DOUBLE QUOTE (0x22) - "
    public static let dquote: UInt8 = 0x22
    public static let quotationMark: UInt8 = dquote

    /// LESS-THAN SIGN (0x3C) - <
    public static let lt: UInt8 = 0x3C
    public static let lessThan: UInt8 = lt

    /// GREATER-THAN SIGN (0x3E) - >
    public static let gt: UInt8 = 0x3E
    public static let greaterThan: UInt8 = gt

    /// COLON (0x3A) - :
    public static let colon: UInt8 = 0x3A

    /// COMMERCIAL AT (0x40) - @
    public static let at: UInt8 = 0x40

    // MARK: - ASCII Whitespace

    /// Canonical definition of ASCII whitespace bytes
    ///
    /// Single source of truth for ASCII whitespace per INCITS 4-1986:
    /// - 0x20 (SPACE)
    /// - 0x09 (HORIZONTAL TAB)
    /// - 0x0A (LINE FEED)
    /// - 0x0D (CARRIAGE RETURN)
    ///
    /// These are the only four whitespace characters defined in US-ASCII.
    public static let asciiWhitespaceBytes: Set<UInt8> = [.space, .htab, .lf, .cr]

    /// Tests if byte is ASCII whitespace (0x20, 0x09, 0x0A, 0x0D)
    @inlinable
    public var isASCIIWhitespace: Bool {
        // Inline comparison for performance (4 equality checks < Set lookup)
        self == .space || self == .htab || self == .lf || self == .cr
    }

    /// Tests if byte is ASCII control character (0x00-0x1F or 0x7F)
    ///
    /// Control characters per INCITS 4-1986 Section 4:
    /// - C0 controls: 0x00-0x1F (includes NULL, TAB, LF, CR, etc.)
    /// - DELETE: 0x7F
    @inlinable
    public var isASCIIControl: Bool {
        self <= 0x1F || self == 0x7F
    }

    /// Tests if byte is ASCII visible/printable character (0x21-0x7E)
    ///
    /// Visible characters per INCITS 4-1986 Section 4:
    /// - Printable characters excluding SPACE: 0x21 ('!') through 0x7E ('~')
    /// - Includes digits, letters, and punctuation
    /// - Excludes control characters (0x00-0x1F), SPACE (0x20), and DELETE (0x7F)
    @inlinable
    public var isASCIIVisible: Bool {
        self >= 0x21 && self <= 0x7E
    }

    // MARK: - Character Classification

    /// Tests if byte is ASCII digit ('0'...'9')
    @inlinable
    public var isASCIIDigit: Bool {
        self >= 0x30 && self <= 0x39  // '0'...'9'
    }

    /// Tests if byte is ASCII letter ('A'...'Z' or 'a'...'z')
    @inlinable
    public var isASCIILetter: Bool {
        (self >= 0x41 && self <= 0x5A) || (self >= 0x61 && self <= 0x7A)  // 'A'...'Z' or 'a'...'z'
    }

    /// Tests if byte is ASCII alphanumeric (digit or letter)
    @inlinable
    public var isASCIIAlphanumeric: Bool {
        isASCIIDigit || isASCIILetter
    }

    /// Tests if byte is ASCII hexadecimal digit ('0'...'9', 'A'...'F', 'a'...'f')
    @inlinable
    public var isASCIIHexDigit: Bool {
        isASCIIDigit || (self >= 0x41 && self <= 0x46) || (self >= 0x61 && self <= 0x66)  // 'A'...'F' or 'a'...'f'
    }

    /// Tests if byte is ASCII uppercase letter ('A'...'Z')
    @inlinable
    public var isASCIIUppercase: Bool {
        self >= 0x41 && self <= 0x5A  // 'A'...'Z'
    }

    /// Tests if byte is ASCII lowercase letter ('a'...'z')
    @inlinable
    public var isASCIILowercase: Bool {
        self >= 0x61 && self <= 0x7A  // 'a'...'z'
    }

    /// Converts ASCII letter to specified case, returns unchanged if not an ASCII letter
    /// - Parameter case: The target case (upper or lower)
    /// - Returns: Converted byte if ASCII letter, unchanged otherwise
    ///
    /// Example:
    /// ```swift
    /// UInt8(ascii: "a").ascii(case: .upper)  // 65 ("A")
    /// UInt8(ascii: "Z").ascii(case: .lower)  // 122 ("z")
    /// UInt8(ascii: "1").ascii(case: .upper)  // 49 ("1") - unchanged
    /// ```
    @inlinable
    public func ascii(case: Character.Case) -> UInt8 {
        switch `case` {
        case .upper:
            return isASCIILowercase ? self - 32 : self
        case .lower:
            return isASCIIUppercase ? self + 32 : self
        }
    }
}


