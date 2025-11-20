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
        // Fast path: check if normalization is needed
        let hasLF = bytes.contains(INCITS_4_1986.ControlCharacters.lf)
        let hasCR = bytes.contains(INCITS_4_1986.ControlCharacters.cr)

        if lineEnding == .crlf && !hasLF && !hasCR { return bytes }
        if lineEnding == .lf && !hasCR { return bytes }
        if lineEnding == .cr && !hasLF { return bytes }

        let targetBytes = [UInt8](lineEnding)
        var resultBytes = [UInt8]()
        resultBytes.reserveCapacity(bytes.count)

        var index = 0
        while index < bytes.count {
            let byte = bytes[index]

            if byte == INCITS_4_1986.ControlCharacters.cr {  // CR (CARRIAGE RETURN)
                let next = index + 1
                if next < bytes.count && bytes[next] == INCITS_4_1986.ControlCharacters.lf {  // LF
                    // CRLF sequence
                    resultBytes.append(contentsOf: targetBytes)
                    index = next + 1
                    continue
                } else {
                    // CR alone
                    resultBytes.append(contentsOf: targetBytes)
                    index = next
                    continue
                }
            } else if byte == INCITS_4_1986.ControlCharacters.lf {  // LF (LINE FEED)
                // LF alone
                resultBytes.append(contentsOf: targetBytes)
                index += 1
                continue
            }

            resultBytes.append(byte)
            index += 1
        }

        return resultBytes
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
