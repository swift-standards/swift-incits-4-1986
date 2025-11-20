// INCITS_4_1986.swift
// swift-incits-4-1986
//
// INCITS 4-1986 (R2022): Coded Character Sets - 7-Bit American Standard Code for Information Interchange
//
// This namespace contains the authoritative implementations of the INCITS 4-1986 standard.
// Structure follows the specification's table of contents.

/// INCITS 4-1986: US-ASCII Standard
///
/// Authoritative namespace for all US-ASCII definitions.
/// Extensions on UInt8, String, Character, etc. reference these implementations.
public enum INCITS_4_1986 {}

extension INCITS_4_1986 {
    /// Canonical definition of ASCII whitespace bytes
    ///
    /// Single source of truth for ASCII whitespace per INCITS 4-1986:
    /// - 0x20 (SPACE)
    /// - 0x09 (HORIZONTAL TAB)
    /// - 0x0A (LINE FEED)
    /// - 0x0D (CARRIAGE RETURN)
    ///
    /// These are the only four whitespace characters defined in US-ASCII.
    public static let whitespaces: Set<UInt8> = [
        SPACE.sp,
        ControlCharacters.htab,
        ControlCharacters.lf,
        ControlCharacters.cr
    ]
    
    
    // MARK: - Common ASCII Byte Sequences

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// Standard line ending per INCITS 4-1986 and Internet standards (RFCs).
    /// Consists of CARRIAGE RETURN followed by LINE FEED.
    public static let crlf: [UInt8] = [
        INCITS_4_1986.ControlCharacters.cr,
        INCITS_4_1986.ControlCharacters.lf
    ]
}
