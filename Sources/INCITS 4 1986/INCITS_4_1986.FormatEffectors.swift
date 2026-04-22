// INCITS_4_1986.FormatEffectors.swift
// swift-incits-4-1986
//
// INCITS 4-1986 Section 4.1.2: Format Effectors
// Format effectors control the layout and positioning of information

extension INCITS_4_1986 {
    /// Format Effector Operations
    ///
    /// Operations for controlling the layout and positioning of text.
    /// Per INCITS 4-1986 Section 4.1.2, format effectors control physical positioning.
    public enum FormatEffectors {}
}

extension INCITS_4_1986 {
    /// Normalizes ASCII line endings in byte collection to the specified style
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
    ///
    /// // Works with slices
    /// let slice = bytes[start..<end]
    /// INCITS_4_1986.normalized(slice, to: .lf)
    /// ```
    public static func normalized<C: Swift.Collection>(
        _ bytes: C,
        to lineEnding: INCITS_4_1986.FormatEffectors.Line.Ending
    ) -> [UInt8] where C.Element == UInt8 {
        // Fast path: if no line ending characters exist, return as-is
        // Single pass check is faster than two separate contains() calls
        let cr = ASCII_Primitives.ASCII.Character.Control.cr
        let lf = ASCII_Primitives.ASCII.Character.Control.lf
        if !bytes.contains(where: { $0 == cr || $0 == lf }) {
            return Array(bytes)
        }

        // Determine target line ending sequence inline
        let target: [UInt8] = switch lineEnding {
        case .lf: [lf]
        case .cr: [cr]
        case .crlf: [cr, lf]
        }

        var result = [UInt8]()
        result.reserveCapacity(bytes.count + (lineEnding == .crlf ? bytes.count / 10 : 0))

        var iterator = bytes.makeIterator()
        var lookahead: UInt8? = iterator.next()

        while let byte = lookahead {
            lookahead = iterator.next()

            if byte == cr {
                // Check for CRLF sequence
                if lookahead == lf {
                    // CRLF → target
                    result.append(contentsOf: target)
                    lookahead = iterator.next()  // consume the LF
                } else {
                    // CR → target
                    result.append(contentsOf: target)
                }
            } else if byte == lf {
                // LF → target
                result.append(contentsOf: target)
            } else {
                // Regular byte, preserve as-is
                result.append(byte)
            }
        }

        return result
    }
}
