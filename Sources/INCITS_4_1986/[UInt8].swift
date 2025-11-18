//
//  File.swift
//  swift-incits-4-1986
//
//  Created by Coen ten Thije Boonkkamp on 18/11/2025.
//

import Standards

extension [UInt8] {
    // MARK: - Common ASCII Byte Sequences

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// Standard line ending per INCITS 4-1986 and Internet standards (RFCs).
    /// Consists of CARRIAGE RETURN followed by LINE FEED.
    public static let crlf: [UInt8] = [.cr, .lf]

    /// LF line ending (0x0A)
    ///
    /// Unix-style line ending. Single LINE FEED character.
    public static let lf: [UInt8] = [UInt8.lf]

    /// CR line ending (0x0D)
    ///
    /// Classic Mac-style line ending. Single CARRIAGE RETURN character.
    public static let cr: [UInt8] = [UInt8.cr]

    // MARK: - Case Conversion

    /// Converts all ASCII letters in the array to specified case
    /// - Parameter case: The target case (upper or lower)
    /// - Returns: New array with ASCII letters converted
    ///
    /// Example:
    /// ```swift
    /// Array("Hello".utf8).ascii(case: .upper)  // "HELLO"
    /// Array("World".utf8).ascii(case: .lower)  // "world"
    /// ```
    @inlinable
    public func ascii(case: Character.Case) -> [UInt8] {
        map { $0.ascii(case: `case`) }
    }
}
