// INCITS_4_1986.swift
// swift-incits-4-1986
//
// INCITS 4-1986 (R2022): Coded Character Sets - 7-Bit American Standard Code for Information Interchange
//
// This namespace delegates to ASCII Primitives for core definitions.

/// INCITS 4-1986: US-ASCII Standard
///
/// Authoritative namespace for all US-ASCII definitions and operations.
/// This type delegates to ``ASCII`` for core character definitions.
///
/// ## See Also
///
/// - ``ASCII``
public enum INCITS_4_1986 {}

extension INCITS_4_1986 {
    /// ASCII Letter Case
    ///
    /// Typealias to ``ASCII/Case``.
    public typealias Case = ASCII_Primitives.ASCII.Case
}

extension INCITS_4_1986 {
    /// Canonical definition of ASCII whitespace bytes
    ///
    /// Delegates to ``ASCII/whitespaces``.
    public static var whitespaces: Set<UInt8> { ASCII_Primitives.ASCII.whitespaces }
}
