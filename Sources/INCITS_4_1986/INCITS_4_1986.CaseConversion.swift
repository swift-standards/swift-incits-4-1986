// INCITS_4_1986.CaseConversion.swift
// swift-incits-4-1986
//
// INCITS 4-1986 Section 4.3: Graphic Characters - Case Conversion
// Delegates to ASCII.CaseConversion

extension INCITS_4_1986 {
    /// Case Conversion Operations
    ///
    /// Typealias to ``ASCII/CaseConversion``.
    public typealias CaseConversion = ASCII_Primitives.ASCII.CaseConversion
}

extension INCITS_4_1986 {
    /// Converts ASCII letters in byte collection to specified case
    ///
    /// Delegates to ``ASCII/convert(_:to:)-5f76s``.
    @inlinable
    public static func convert<C: Swift.Collection>(
        _ bytes: C,
        to case: INCITS_4_1986.Case
    ) -> [UInt8] where C.Element == UInt8 {
        ASCII_Primitives.ASCII.convert(bytes, to: `case`)
    }

    /// Converts ASCII letters in string to specified case
    ///
    /// Delegates to ``ASCII/convert(_:to:)-3r3n2``.
    @inlinable
    public static func convert<S: StringProtocol>(_ string: S, to case: INCITS_4_1986.Case) -> S {
        ASCII_Primitives.ASCII.convert(string, to: `case`)
    }
}
