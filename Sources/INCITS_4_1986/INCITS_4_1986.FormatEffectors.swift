// INCITS_4_1986.FormatEffectors.swift
// swift-incits-4-1986
//
// INCITS 4-1986 Section 4.1.2: Format Effectors
// Format effectors control the layout and positioning of information

import Standards

// MARK: - Line Ending Normalization

extension INCITS_4_1986 {
    /// Normalizes ASCII line endings in byte array to the specified style
    ///
    /// Canonical byte-level operation. Converts all line endings to target format.
    ///
    /// Per INCITS 4-1986 Section 7.5 (CR) and Section 7.22 (LF):
    /// - CR (0x0D): CARRIAGE RETURN - moves to first character position
    /// - LF (0x0A): LINE FEED - advances to next line
    /// - CRLF: Combination used by Internet protocols (RFC 9112, RFC 5322)
    ///
    /// Mathematical Properties:
    /// - **Idempotence**: `normalized(normalized(b, to: e), to: e) == normalized(b, to: e)`
    /// - **Preservation**: If `b` contains no line endings, `normalized(b, to: any) == b`
    ///
    /// Example:
    /// ```swift
    /// let bytes: [UInt8] = [0x6C, 0x0A, 0x6D]  // "l\nm"
    /// INCITS_4_1986.normalized(bytes, to: .crlf)  // [0x6C, 0x0D, 0x0A, 0x6D]
    /// ```
    public static func normalized(_ bytes: [UInt8], to lineEnding: String.LineEnding) -> [UInt8] {
        // Fast path: if no line ending characters exist, return as-is
        // Single pass check is faster than two separate contains() calls
        if !bytes.contains(where: { $0 == .ascii.cr || $0 == .ascii.lf }) {
            return bytes
        }

        // Determine target line ending sequence inline
        let cr = UInt8.ascii.cr
        let lf = UInt8.ascii.lf
        let target = [UInt8].ascii(lineEnding: lineEnding)

        var result = [UInt8]()
        result.reserveCapacity(bytes.count + (lineEnding == .crlf ? bytes.count / 10 : 0))

        var i = 0
        while i < bytes.count {
            let byte = bytes[i]

            if byte == cr {
                // Check for CRLF sequence
                if i + 1 < bytes.count && bytes[i + 1] == lf {
                    // CRLF → target
                    result.append(contentsOf: target)
                    i += 2
                } else {
                    // CR → target
                    result.append(contentsOf: target)
                    i += 1
                }
            } else if byte == lf {
                // LF → target
                result.append(contentsOf: target)
                i += 1
            } else {
                // Regular byte, preserve as-is
                result.append(byte)
                i += 1
            }
        }

        return result
    }

    /// Normalizes ASCII line endings in string to the specified style
    ///
    /// Convenience method that delegates to byte-level `normalized(_:to:)`.
    ///
    /// Example:
    /// ```swift
    /// INCITS_4_1986.normalized("line1\nline2\r\nline3", to: .crlf)
    /// // "line1\r\nline2\r\nline3"
    /// ```
    public static func normalized<Encoding>(
        _ string: String,
        to lineEnding: String.LineEnding,
        as encoding: Encoding.Type = UTF8.self
    ) -> String where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 {
        let normalizedBytes = normalized(Array(string.utf8), to: lineEnding)
        return String(decoding: normalizedBytes, as: encoding)
    }
}
