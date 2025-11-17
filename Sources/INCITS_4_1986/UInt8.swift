// UInt8.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII byte-level operations

import Standards

extension UInt8 {
    /// Canonical definition of ASCII whitespace bytes
    ///
    /// Single source of truth for ASCII whitespace per INCITS 4-1986:
    /// - 0x20 (SPACE)
    /// - 0x09 (HORIZONTAL TAB)
    /// - 0x0A (LINE FEED)
    /// - 0x0D (CARRIAGE RETURN)
    ///
    /// These are the only four whitespace characters defined in US-ASCII.
    public static let asciiWhitespaceBytes: Set<UInt8> = [0x20, 0x09, 0x0A, 0x0D]

    /// Tests if byte is ASCII whitespace (0x20, 0x09, 0x0A, 0x0D)
    @inlinable
    public var isASCIIWhitespace: Bool {
        // Inline comparison for performance (4 equality checks < Set lookup)
        self == 0x20 || self == 0x09 || self == 0x0A || self == 0x0D
    }

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

extension [UInt8] {
    /// Converts all ASCII letters in the array to specified case
    /// - Parameter case: The target case (upper or lower)
    /// - Returns: New array with ASCII letters converted
    ///
    /// Example:
    /// ```swift
    /// Array("Hello".utf8).ascii(case: .upper)  // "HELLO"
    /// Array("World".utf8).ascii(case: .lower)  // "world"
    /// ```
    @inlinable
    public func ascii(case: Character.Case) -> [UInt8] {
        map { $0.ascii(case: `case`) }
    }
}
