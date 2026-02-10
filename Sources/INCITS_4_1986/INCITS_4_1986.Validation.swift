// INCITS_4_1986.Validation.swift
// swift-incits-4-1986
//
// INCITS 4-1986: ASCII Validation
// Delegates to ASCII.Validation

extension INCITS_4_1986 {
    /// Returns true if the byte is valid ASCII (0x00-0x7F)
    ///
    /// Delegates to ``ASCII/isASCII(_:)``.
    @_transparent
    public static func isASCII(_ byte: UInt8) -> Bool {
        ASCII_Primitives.ASCII.isASCII(byte)
    }

    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Delegates to ``ASCII/isAllASCII(_:)``.
    @inlinable
    public static func isAllASCII<C: Collection>(
        _ bytes: C
    ) -> Bool where C.Element == UInt8 {
        ASCII_Primitives.ASCII.isAllASCII(bytes)
    }
}
