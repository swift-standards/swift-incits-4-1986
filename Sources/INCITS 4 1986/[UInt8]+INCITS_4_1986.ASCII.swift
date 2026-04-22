// [UInt8]+INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// Namespaced access to INCITS 4-1986 (US-ASCII) constants on [UInt8]

import Standard_Library_Extensions

// MARK: - [UInt8] ASCII Namespace

extension [UInt8] {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// ASCII static operations namespace for byte arrays
    public enum ASCII {}
}

// MARK: - [UInt8] Initializers

extension [UInt8] {
    /// Creates ASCII byte array from a string with validation
    ///
    /// Converts a Swift `String` to an array of ASCII bytes, returning `nil` if any character
    /// is outside the ASCII range (U+0000 to U+007F).
    public init?(ascii s: some StringProtocol) {
        guard s.allSatisfy({ $0.isASCII }) else { return nil }
        self = Array(s.utf8)
    }

    /// Creates byte array from a line ending constant
    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.Line.Ending) {
        switch lineEnding {
        case .lf: self = [UInt8.ascii.lf]
        case .cr: self = [UInt8.ascii.cr]
        case .crlf: self = [UInt8].ascii.crlf
        }
    }
}

// MARK: - [UInt8].ASCII Static Methods

extension [UInt8].ASCII {
    /// Creates ASCII byte array from a string without validation
    public static func unchecked(_ s: some StringProtocol) -> [UInt8] {
        Array(s.utf8)
    }

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// The canonical two-byte sequence for line endings in Internet protocols.
    /// Consists of CARRIAGE RETURN (0x0D) followed by LINE FEED (0x0A).
    public static var crlf: [UInt8] {
        INCITS_4_1986.Character.Control.crlf
    }

    /// ASCII whitespace bytes
    ///
    /// Set containing the four ASCII whitespace characters defined in INCITS 4-1986.
    public static var whitespaces: Set<UInt8> {
        INCITS_4_1986.whitespaces
    }
}
