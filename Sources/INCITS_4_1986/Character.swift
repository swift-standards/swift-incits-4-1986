// Character.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII character classification

import Standards

extension Character {
    /// Character case style for ASCII case conversion
    ///
    /// Enum for ASCII case transformations per INCITS 4-1986.
    /// Only affects ASCII letters ('A'...'Z', 'a'...'z').
    public enum Case: Sendable {
        /// Convert to uppercase (A-Z)
        case upper
        /// Convert to lowercase (a-z)
        case lower
    }
}

extension Character {
    /// Tests if character is ASCII whitespace (space, tab, LF, CR)
    @inlinable
    public var isASCIIWhitespace: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIIWhitespace
    }

    /// Tests if character is ASCII digit ('0'...'9')
    @inlinable
    public var isASCIIDigit: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIIDigit
    }

    /// Tests if character is ASCII letter ('A'...'Z' or 'a'...'z')
    @inlinable
    public var isASCIILetter: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIILetter
    }

    /// Tests if character is ASCII alphanumeric (digit or letter)
    @inlinable
    public var isASCIIAlphanumeric: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIIAlphanumeric
    }

    /// Tests if character is ASCII hexadecimal digit
    @inlinable
    public var isASCIIHexDigit: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIIHexDigit
    }

    /// Tests if character is ASCII uppercase letter ('A'...'Z')
    @inlinable
    public var isASCIIUppercase: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIIUppercase
    }

    /// Tests if character is ASCII lowercase letter ('a'...'z')
    @inlinable
    public var isASCIILowercase: Bool {
        guard let ascii = self.asciiValue else { return false }
        return ascii.isASCIILowercase
    }
}
