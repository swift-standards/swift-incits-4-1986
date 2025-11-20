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
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this character
    public var ascii: ASCII {
        ASCII(character: self)
    }

    public struct ASCII {
        public let character: Character

        public init(character: Character) {
            self.character = character
        }
    }
}

extension Character.ASCII {
    // MARK: - Nested Namespaces

    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}



extension Character.ASCII {
    // MARK: - Character Classification

    /// Tests if character is ASCII whitespace (space, tab, LF, CR)
    @_transparent
    public var isWhitespace: Bool {
        guard let value = UInt8.ascii(self.character)  else { return false }
        return value.ascii.isWhitespace
    }

    /// Tests if character is ASCII digit ('0'...'9')
    @_transparent
    public var isDigit: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isDigit
    }

    /// Tests if character is ASCII letter ('A'...'Z' or 'a'...'z')
    @_transparent
    public var isLetter: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isLetter
    }

    /// Tests if character is ASCII alphanumeric (digit or letter)
    @inlinable
    public var isAlphanumeric: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isAlphanumeric
    }

    /// Tests if character is ASCII hexadecimal digit
    @inlinable
    public var isHexDigit: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isHexDigit
    }

    /// Tests if character is ASCII uppercase letter ('A'...'Z')
    @_transparent
    public var isUppercase: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isUppercase
    }

    /// Tests if character is ASCII lowercase letter ('a'...'z')
    @_transparent
    public var isLowercase: Bool {
        guard let value = UInt8.ascii(self.character) else { return false }
        return value.ascii.isLowercase
    }
}
