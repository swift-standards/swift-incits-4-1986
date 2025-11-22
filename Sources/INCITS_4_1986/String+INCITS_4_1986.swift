// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

extension INCITS_4_1986 {
    public struct ASCII<S: StringProtocol> {
        public let value: S

        // Internal initializer for StringProtocol (converts to String)
        internal init(_ value: S) {
            self.value = value
        }
    }
}

extension INCITS_4_1986.ASCII {
    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}

extension INCITS_4_1986.ASCII {
    /// LINE FEED string (\\n) - 0x0A
    public static var lf: S { S(decoding: [UInt8.ascii.lf], as: UTF8.self) }

    /// CARRIAGE RETURN string (\\r) - 0x0D
    public static var cr: S { S(decoding: [UInt8.ascii.cr], as: UTF8.self) }

    /// CRLF string (\\r\\n) - 0x0D 0x0A
    public static var crlf: S { S(decoding: INCITS_4_1986.ControlCharacters.crlf, as: UTF8.self) }
}

extension INCITS_4_1986.ASCII {
    /// Returns true if all characters in the string are valid ASCII (U+0000 to U+007F)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllASCII(_:)``
    @inlinable
    public var isAllASCII: Bool {
        INCITS_4_1986.StringClassification.isAllASCII(self.value)
    }

    /// Returns true if all characters in the string are ASCII whitespace
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllWhitespace(_:)``
    @inlinable
    public var isAllWhitespace: Bool {
        INCITS_4_1986.StringClassification.isAllWhitespace(self.value)
    }

    /// Returns true if all characters in the string are ASCII digits (0-9)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllDigits(_:)``
    @inlinable
    public var isAllDigits: Bool {
        INCITS_4_1986.StringClassification.isAllDigits(self.value)
    }

    /// Returns true if all characters in the string are ASCII letters (A-Z, a-z)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllLetters(_:)``
    @inlinable
    public var isAllLetters: Bool {
        INCITS_4_1986.StringClassification.isAllLetters(self.value)
    }

    /// Returns true if all characters in the string are ASCII alphanumeric (0-9, A-Z, a-z)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllAlphanumeric(_:)``
    @inlinable
    public var isAllAlphanumeric: Bool {
        INCITS_4_1986.StringClassification.isAllAlphanumeric(self.value)
    }

    /// Returns true if all characters in the string are ASCII control characters
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllControl(_:)``
    @inlinable
    public var isAllControl: Bool {
        INCITS_4_1986.StringClassification.isAllControl(self.value)
    }

    /// Returns true if all characters in the string are ASCII visible characters (excludes SPACE)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllVisible(_:)``
    @inlinable
    public var isAllVisible: Bool {
        INCITS_4_1986.StringClassification.isAllVisible(self.value)
    }

    /// Returns true if all characters in the string are ASCII printable characters (includes SPACE)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllPrintable(_:)``
    @inlinable
    public var isAllPrintable: Bool {
        INCITS_4_1986.StringClassification.isAllPrintable(self.value)
    }

    /// Returns true if the string contains any non-ASCII characters
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/containsNonASCII(_:)``
    @inlinable
    public var containsNonASCII: Bool {
        INCITS_4_1986.StringClassification.containsNonASCII(self.value)
    }

    /// Returns true if the string contains any ASCII hexadecimal digit (0-9, A-F, a-f)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/containsHexDigit(_:)``
    @inlinable
    public var containsHexDigit: Bool {
        INCITS_4_1986.StringClassification.containsHexDigit(self.value)
    }
}

extension INCITS_4_1986.ASCII {
    /// Returns true if all ASCII letters in the string are lowercase
    ///
    /// Non-letter characters are ignored in the check.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllLowercase(_:)``
    @inlinable
    public var isAllLowercase: Bool {
        INCITS_4_1986.StringClassification.isAllLowercase(self.value)
    }

    /// Returns true if all ASCII letters in the string are uppercase
    ///
    /// Non-letter characters are ignored in the check.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/StringClassification/isAllUppercase(_:)``
    @inlinable
    public var isAllUppercase: Bool {
        INCITS_4_1986.StringClassification.isAllUppercase(self.value)
    }
}

extension INCITS_4_1986.ASCII {
    /// Returns true if the string contains mixed line ending styles
    ///
    /// Detects if the string uses more than one line ending style (LF, CR, CRLF).
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/LineEndingDetection/hasMixedLineEndings(_:)``
    public var containsMixedLineEndings: Bool {
        INCITS_4_1986.LineEndingDetection.hasMixedLineEndings(self.value)
    }
}

