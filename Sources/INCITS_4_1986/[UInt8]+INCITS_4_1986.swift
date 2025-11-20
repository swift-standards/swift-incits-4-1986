// [UInt8]+ASCII.swift
// swift-incits-4-1986
//
// Convenient namespaced access to INCITS 4-1986 (US-ASCII) constants

import Standards

extension [UInt8] {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this byte array
    public var ascii: ASCII {
        ASCII(bytes: self)
    }

    public struct ASCII {
        public let bytes: [UInt8]

        public init(bytes: [UInt8]) {
            self.bytes = bytes
        }
    }
}

// MARK: - Conversions

extension [UInt8] {
    /// Creates ASCII bytes from a string, nil if string contains non-ASCII characters
    ///
    /// Validates that all characters are ASCII (U+0000 to U+007F) before conversion.
    ///
    /// Example:
    /// ```swift
    /// [UInt8].ascii("hello")  // [104, 101, 108, 108, 111]
    /// [UInt8].ascii("hello🌍")  // nil
    /// ```
    public static func ascii(_ string: String) -> [UInt8]? {
        guard string.allSatisfy({ $0.isASCII }) else { return nil }
        return Array(string.utf8)
    }

    /// Creates ASCII bytes from a string without validation
    ///
    /// Use when you know the string only contains ASCII characters.
    /// If the string contains non-ASCII, the result is undefined.
    ///
    /// Example:
    /// ```swift
    /// [UInt8].ascii(unchecked: "hello")  // [104, 101, 108, 108, 111]
    /// ```
    public static func ascii(unchecked string: String) -> [UInt8] {
        Array(string.utf8)
    }

    /// Creates byte array from a line ending constant
    ///
    /// Pure function transformation from line ending to byte sequence.
    ///
    /// Example:
    /// ```swift
    /// [UInt8].ascii(lineEnding: .lf)    // [0x0A]
    /// [UInt8].ascii(lineEnding: .cr)    // [0x0D]
    /// [UInt8].ascii(lineEnding: .crlf)  // [0x0D, 0x0A]
    /// ```
    public static func ascii(lineEnding: String.LineEnding) -> [UInt8] {
        switch lineEnding {
        case .lf: return [UInt8.ascii.lf]
        case .cr: return [UInt8.ascii.cr]
        case .crlf: return [UInt8].ascii.crlf
        }
    }
}

extension [UInt8].ASCII {
    // MARK: - Value Access

    /// Returns the underlying byte array value
    ///
    /// Provides direct access to the [UInt8] value for this ASCII byte array.
    @inlinable
    public var value: [UInt8] {
        self.bytes
    }
}

extension [UInt8].ASCII {
    // MARK: - Nested Namespaces

    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}

extension [UInt8].ASCII {
    // MARK: - Common Byte Sequences

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// Standard line ending per INCITS 4-1986 and Internet standards (RFCs).
    /// Consists of CARRIAGE RETURN followed by LINE FEED.
    public static var crlf: [UInt8] {
        INCITS_4_1986.crlf
    }

    /// ASCII whitespace bytes
    ///
    /// Set containing the four ASCII whitespace characters:
    /// - 0x20 (SPACE)
    /// - 0x09 (HORIZONTAL TAB)
    /// - 0x0A (LINE FEED)
    /// - 0x0D (CARRIAGE RETURN)
    public static var whitespaces: Set<UInt8> {
        INCITS_4_1986.whitespaces
    }
}

extension [UInt8].ASCII {
    // MARK: - Instance Properties

    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Convenience property that delegates to `INCITS_4_1986.isAllASCII(_:)`.
    ///
    /// Example:
    /// ```swift
    /// [104, 101, 108, 108, 111].ascii.isAllASCII  // true
    /// [104, 255, 108].ascii.isAllASCII  // false
    /// ```
    public var isAllASCII: Bool {
        INCITS_4_1986.isAllASCII(self.value)
    }
}

extension [UInt8].ASCII {
    // MARK: - Instance Methods

    /// Converts all ASCII letters in the array to specified case
    ///
    /// Convenience method that delegates to `INCITS_4_1986.ascii(_:case:)`.
    ///
    /// Example:
    /// ```swift
    /// [UInt8].ascii("Hello")!.ascii.convertingCase(to: .upper)  // "HELLO" bytes
    /// [UInt8].ascii("World")!.ascii.convertingCase(to: .lower)  // "world" bytes
    /// ```
    @inlinable
    public func convertingCase(to case: Character.Case) -> [UInt8] {
        INCITS_4_1986.ascii(self.value, case: `case`)
    }
}

