// String.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII string operations

import Standards

extension String {
    /// Returns ASCII bytes if all characters are ASCII, nil otherwise
    ///
    /// Example:
    /// ```swift
    /// "hello".asciiBytes  // [104, 101, 108, 108, 111]
    /// "hello🌍".asciiBytes  // nil
    /// ```
    public var asciiBytes: [UInt8]? {
        guard allSatisfy({ $0.isASCII }) else { return nil }
        return Array(utf8)
    }

    /// Creates a string from ASCII bytes, nil if any byte is non-ASCII
    ///
    /// Example:
    /// ```swift
    /// String(ascii: [104, 101, 108, 108, 111])  // "hello"
    /// String(ascii: [255])  // nil (not valid ASCII)
    /// ```
    public init?(ascii bytes: [UInt8]) {
        guard bytes.allSatisfy({ $0 <= 127 }) else { return nil }
        self.init(decoding: bytes, as: UTF8.self)
    }
}

extension String {
    /// Trims characters from both ends of the string
    /// - Parameters:
    ///   - string: The string to trim
    ///   - characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    public static func trimming(_ string: String, of characterSet: Set<Character>) -> String {
        Substring.trimming(string[...], of: characterSet)
    }

    /// Trims characters from both ends of the string
    /// - Parameter characterSet: The set of characters to trim
    /// - Returns: A new string with the specified characters trimmed from both ends
    ///
    /// Uses optimized UTF-8 fast path when trimming ASCII whitespace.
    @inlinable
    public func trimming(_ characterSet: Set<Character>) -> String {
        Self.trimming(self, of: characterSet)
    }
}

// MARK: - Line Endings

extension String {
    /// Line ending style for ASCII text normalization
    ///
    /// Values derive from INCITS 4-1986 ASCII character definitions:
    /// - CR: CARRIAGE RETURN (0x0D)
    /// - LF: LINE FEED (0x0A)
    ///
    /// All byte values flow from `UInt8.cr` and `UInt8.lf` constants - single source of truth.
    public enum LineEnding: Sendable {
        /// Unix style: LINE FEED (0x0A)
        case lf
        /// Old Mac style: CARRIAGE RETURN (0x0D)
        case cr
        /// Windows/Network protocol style: CARRIAGE RETURN + LINE FEED (0x0D 0x0A)
        ///
        /// Required by Internet protocols including HTTP (RFC 9112) and Email (RFC 5322).
        case crlf
    }
}

extension String.LineEnding {
    /// ASCII byte sequence for this line ending
    ///
    /// Single source of truth: all values reference INCITS 4-1986 ASCII constants.
    public var bytes: [UInt8] {
        switch self {
        case .lf: [UInt8].lf      // References UInt8.lf = 0x0A
        case .cr: [UInt8].cr      // References UInt8.cr = 0x0D
        case .crlf: [UInt8].crlf  // References [.cr, .lf]
        }
    }

    /// String representation of this line ending
    ///
    /// Computed from byte sequence - no duplication of ASCII values.
    public var string: String {
        String(decoding: bytes, as: UTF8.self)
    }

    // Convenience static properties
    public static let lineFeed: Self = .lf
    public static let carriageReturn: Self = .cr
    public static let carriageReturnLineFeed: Self = .crlf
}

extension String {
    /// Normalizes ASCII line endings to the specified style
    ///
    /// Converts all line endings (\n, \r, \r\n) to the target format.
    /// Useful for protocols like HTTP and Email that require CRLF.
    ///
    /// Example:
    /// ```swift
    /// let text = "line1\nline2\r\nline3"
    /// text.normalized(to: .crlf)  // "line1\r\nline2\r\nline3"
    /// ```
    public func normalized(to lineEnding: LineEnding) -> String {
        // Fast path: check if normalization is needed
        let hasLF = utf8.contains(UInt8.lf)
        let hasCR = utf8.contains(UInt8.cr)

        if lineEnding == .crlf && !hasLF && !hasCR { return self }
        if lineEnding == .lf && !hasCR { return self }
        if lineEnding == .cr && !hasLF { return self }

        let targetBytes = lineEnding.bytes
        var resultBytes = [UInt8]()
        resultBytes.reserveCapacity(utf8.count)

        var index = utf8.startIndex
        while index < utf8.endIndex {
            let byte = utf8[index]

            if byte == UInt8.cr {  // Single source of truth
                let next = utf8.index(after: index)
                if next < utf8.endIndex && utf8[next] == UInt8.lf {
                    // CRLF sequence
                    resultBytes.append(contentsOf: targetBytes)
                    index = utf8.index(after: next)
                    continue
                } else {
                    // CR alone
                    resultBytes.append(contentsOf: targetBytes)
                    index = next
                    continue
                }
            } else if byte == UInt8.lf {  // Single source of truth
                // LF alone
                resultBytes.append(contentsOf: targetBytes)
                index = utf8.index(after: index)
                continue
            }

            resultBytes.append(byte)
            index = utf8.index(after: index)
        }

        return String(decoding: resultBytes, as: UTF8.self)
    }
}

