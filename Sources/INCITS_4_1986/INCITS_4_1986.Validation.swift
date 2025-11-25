// INCITS_4_1986.Validation.swift
// swift-incits-4-1986
//
// INCITS 4-1986: ASCII Validation
// Validates that bytes conform to the 7-bit ASCII range (0x00-0x7F)

import Standards

public extension INCITS_4_1986 {
    /// Returns true if the byte is valid ASCII (0x00-0x7F)
    ///
    /// Per INCITS 4-1986 Section 4: The coded character set consists of
    /// 128 characters represented by 7-bit combinations (0/0 to 7/15).
    /// Valid ASCII bytes have values 0-127 (0x00-0x7F).
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.isASCII(0x41)  // true ('A')
    /// INCITS_4_1986.isASCII(0x7F)  // true (DEL - last ASCII)
    /// INCITS_4_1986.isASCII(0x80)  // false (first non-ASCII)
    /// INCITS_4_1986.isASCII(0xFF)  // false
    /// ```
    @_transparent
    static func isASCII(_ byte: UInt8) -> Bool {
        byte <= 0x7F
    }

    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Per INCITS 4-1986 Section 4: The coded character set consists of
    /// 128 characters represented by 7-bit combinations (0/0 to 7/15).
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.isAllASCII([104, 101, 108, 108, 111])  // true
    /// INCITS_4_1986.isAllASCII([104, 255, 108])  // false
    ///
    /// // Works with slices
    /// let slice = bytes[start..<end]
    /// INCITS_4_1986.isAllASCII(slice)
    /// ```
    static func isAllASCII<C: Collection>(
        _ bytes: C
    ) -> Bool where C.Element == UInt8 {
        bytes.allSatisfy(isASCII)
    }
}
