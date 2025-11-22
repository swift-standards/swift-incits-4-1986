// INCITS_4_1986.Validation.swift
// swift-incits-4-1986
//
// INCITS 4-1986: ASCII Validation
// Validates that bytes conform to the 7-bit ASCII range (0x00-0x7F)

import Standards

extension INCITS_4_1986 {
    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Per INCITS 4-1986 Section 4: The coded character set consists of
    /// 128 characters represented by 7-bit combinations (0/0 to 7/15).
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.isAllASCII([104, 101, 108, 108, 111])  // true
    /// INCITS_4_1986.isAllASCII([104, 255, 108])  // false
    /// ```
    public static func isAllASCII(_ bytes: [UInt8]) -> Bool {
        bytes.allSatisfy { $0 <= .ascii.del }
    }
}
