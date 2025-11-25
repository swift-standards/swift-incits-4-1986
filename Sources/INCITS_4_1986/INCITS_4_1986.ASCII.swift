// INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// Generic ASCII operations wrapper for bytes and strings

import Standards

public extension INCITS_4_1986 {
    /// Generic ASCII operations wrapper
    ///
    /// Provides ASCII-related operations for byte collections and strings per INCITS 4-1986 (US-ASCII).
    /// This generic wrapper avoids intermediate allocations when working with slices.
    ///
    /// ## Overview
    ///
    /// The `ASCII` struct wraps any source type and provides ASCII operations via conditional conformances:
    /// - For `Collection<UInt8>`: byte-level validation, case conversion, classification
    /// - For `StringProtocol`: string-level validation and case conversion
    ///
    /// ## Performance
    ///
    /// Methods are marked `@inlinable` for optimal performance. The generic design means
    /// no intermediate allocation is needed when working with slices:
    ///
    /// ```swift
    /// let slice = bytes[start..<end]
    /// let lower = slice.ascii.lowercased()  // No intermediate Array copy!
    ///
    /// let substring = string[start..<end]
    /// let upper = substring.ascii.uppercased()  // No intermediate String copy!
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986``
    struct ASCII<Source> {
        /// The wrapped source (bytes or string)
        public let source: Source

        /// Creates an ASCII wrapper for the given source
        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

// MARK: - Byte Collection: Validation

public extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == UInt8 {
    /// The wrapped byte collection (alias for source)
    @inlinable
    var bytes: Source { source }

    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Validates that every byte in the collection falls within the valid US-ASCII range.
    /// Per INCITS 4-1986, valid ASCII bytes are 0x00-0x7F (0-127 decimal).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// [104, 101, 108, 108, 111].ascii.isAllASCII  // true ("hello")
    /// [104, 255, 108].ascii.isAllASCII            // false (0xFF invalid)
    /// ```
    @inlinable
    var isAllASCII: Bool {
        INCITS_4_1986.isAllASCII(source)
    }

    /// Returns the bytes as an array if all are valid ASCII, nil otherwise
    ///
    /// Validates that all bytes are in the ASCII range (0x00-0x7F).
    ///
    /// ```swift
    /// let valid: [UInt8] = [0x48, 0x69]
    /// valid.ascii()  // Optional([0x48, 0x69])
    ///
    /// let invalid: [UInt8] = [0x48, 0xFF]
    /// invalid.ascii()  // nil
    /// ```
    @inlinable
    func callAsFunction() -> [UInt8]? {
        isAllASCII ? Array(source) : nil
    }
}

// MARK: - Byte Collection: Case Conversion

public extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == UInt8 {
    /// Converts ASCII letters to specified case
    ///
    /// Enables call syntax: `bytes.ascii(case: .upper)`
    ///
    /// - Parameter case: Target case (`.upper` or `.lower`)
    /// - Returns: New byte array with ASCII letters converted
    @inlinable
    func callAsFunction(case: Character.Case) -> [UInt8] {
        INCITS_4_1986.convert(source, to: `case`)
    }

    /// Converts ASCII letters to uppercase
    ///
    /// Transforms all ASCII letters (a-z) to uppercase (A-Z),
    /// leaving all other bytes unchanged.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let hello = [UInt8].ascii.unchecked("hello")
    /// let upper = hello.ascii.uppercased()  // [72, 69, 76, 76, 79] ("HELLO")
    ///
    /// // Works efficiently with slices - no intermediate copy
    /// let slice = bytes[start..<end]
    /// let upperSlice = slice.ascii.uppercased()
    /// ```
    ///
    /// - Returns: New byte array with ASCII letters converted to uppercase
    @inlinable
    func uppercased() -> [UInt8] {
        INCITS_4_1986.convert(source, to: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Transforms all ASCII letters (A-Z) to lowercase (a-z),
    /// leaving all other bytes unchanged.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let hello = [UInt8].ascii.unchecked("HELLO")
    /// let lower = hello.ascii.lowercased()  // [104, 101, 108, 108, 111] ("hello")
    ///
    /// // Avoid String allocation for case-insensitive keys
    /// let key = String(decoding: keyBytes.ascii.lowercased(), as: UTF8.self)
    /// ```
    ///
    /// - Returns: New byte array with ASCII letters converted to lowercase
    @inlinable
    func lowercased() -> [UInt8] {
        INCITS_4_1986.convert(source, to: .lower)
    }

    /// Trims ASCII bytes from both ends of the collection
    ///
    /// Removes leading and trailing bytes that match the given character set.
    /// Returns a zero-copy SubSequence view of the original collection.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x20, 0x48, 0x69, 0x20]  // " Hi "
    /// let trimmed = bytes.ascii.trimming([.ascii.space])  // [0x48, 0x69] ("Hi")
    ///
    /// // Trim LWSP (linear whitespace per RFC 822)
    /// let header = headerBytes.ascii.trimming([.ascii.space, .ascii.htab])
    /// ```
    ///
    /// - Parameter characterSet: The set of ASCII byte values to trim
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    @inlinable
    func trimming(_ characterSet: Set<UInt8>) -> Source.SubSequence {
        source.trimming(characterSet)
    }
}

// MARK: - Byte Collection: Predicates

public extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == UInt8 {
    /// Returns true if all bytes are ASCII whitespace characters
    ///
    /// Tests whether every byte is one of: SPACE (0x20), TAB (0x09), LF (0x0A), CR (0x0D).
    @inlinable
    var isAllWhitespace: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllWhitespace(source)
    }

    /// Returns true if all bytes are ASCII digits (0-9)
    @inlinable
    var isAllDigits: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllDigits(source)
    }

    /// Returns true if all bytes are ASCII letters (A-Z, a-z)
    @inlinable
    var isAllLetters: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLetters(source)
    }

    /// Returns true if all bytes are ASCII alphanumeric (A-Z, a-z, 0-9)
    @inlinable
    var isAllAlphanumeric: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllAlphanumeric(source)
    }

    /// Returns true if all bytes are ASCII control characters (0x00-0x1F or 0x7F)
    @inlinable
    var isAllControl: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllControl(source)
    }

    /// Returns true if all bytes are ASCII visible characters (0x21-0x7E)
    @inlinable
    var isAllVisible: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllVisible(source)
    }

    /// Returns true if all bytes are ASCII printable characters (0x20-0x7E)
    @inlinable
    var isAllPrintable: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllPrintable(source)
    }

    /// Returns true if all ASCII letters are lowercase (non-letters ignored)
    @inlinable
    var isAllLowercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLowercase(source)
    }

    /// Returns true if all ASCII letters are uppercase (non-letters ignored)
    @inlinable
    var isAllUppercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllUppercase(source)
    }

    /// Returns true if collection contains any non-ASCII bytes (>= 0x80)
    @inlinable
    var containsNonASCII: Bool {
        INCITS_4_1986.ByteArrayClassification.containsNonASCII(source)
    }

    /// Returns true if collection contains at least one hex digit (0-9, A-F, a-f)
    @inlinable
    var containsHexDigit: Bool {
        INCITS_4_1986.ByteArrayClassification.containsHexDigit(source)
    }
}

// MARK: - StringProtocol: Validation

public extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// The wrapped string (alias for source)
    @inlinable
    var value: Source { source }

    /// Returns true if all characters are valid ASCII
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "hello".ascii.isAllASCII  // true
    /// "hello🌍".ascii.isAllASCII  // false
    /// ```
    @inlinable
    var isAllASCII: Bool {
        INCITS_4_1986.StringClassification.isAllASCII(source)
    }

    /// Returns the string if all characters are ASCII, nil otherwise
    ///
    /// ```swift
    /// "Hello".ascii()  // Optional("Hello")
    /// "Hello🌍".ascii()  // nil
    /// ```
    @inlinable
    func callAsFunction() -> Source? {
        isAllASCII ? source : nil
    }
}

// MARK: - StringProtocol: Case Conversion

public extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Converts ASCII letters to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) to the specified case, leaving
    /// all other characters unchanged. This is a **Unicode-safe** operation: non-ASCII characters
    /// (including emoji and accented letters) are preserved exactly as-is.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "Hello World".ascii(case: .upper)  // "HELLO WORLD"
    /// "hello🌍".ascii(case: .upper)      // "HELLO🌍"
    /// ```
    ///
    /// - Parameter case: The target case (`.upper` or `.lower`)
    /// - Returns: New string with ASCII letters converted to the specified case
    @inlinable
    func callAsFunction(case: Character.Case) -> Source {
        INCITS_4_1986.convert(source, to: `case`)
    }

    /// Converts ASCII letters to uppercase
    ///
    /// Convenience method for `ascii(case: .upper)`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "hello".ascii.uppercased()  // "HELLO"
    /// "hello🌍".ascii.uppercased()  // "HELLO🌍"
    /// ```
    @inlinable
    func uppercased() -> Source {
        INCITS_4_1986.convert(source, to: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Convenience method for `ascii(case: .lower)`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "HELLO".ascii.lowercased()  // "hello"
    /// "HELLO🌍".ascii.lowercased()  // "hello🌍"
    /// ```
    @inlinable
    func lowercased() -> Source {
        INCITS_4_1986.convert(source, to: .lower)
    }

    /// Detects the line ending style used in the string
    ///
    /// Returns the first line ending type found, or `nil` if no line endings are present.
    /// Prioritizes CRLF detection since it contains both CR and LF.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/LineEndingDetection/detect(_:)``
    @inlinable
    func detectedLineEnding() -> INCITS_4_1986.FormatEffectors.LineEnding? {
        INCITS_4_1986.LineEndingDetection.detect(source)
    }
}

// MARK: - StringProtocol: Predicates

public extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Returns true if all characters are ASCII whitespace
    @inlinable
    var isAllWhitespace: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllWhitespace(source.utf8)
    }

    /// Returns true if all characters are ASCII digits (0-9)
    @inlinable
    var isAllDigits: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllDigits(source.utf8)
    }

    /// Returns true if all characters are ASCII letters (A-Z, a-z)
    @inlinable
    var isAllLetters: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLetters(source.utf8)
    }

    /// Returns true if all characters are ASCII alphanumeric (A-Z, a-z, 0-9)
    @inlinable
    var isAllAlphanumeric: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllAlphanumeric(source.utf8)
    }

    /// Returns true if all characters are ASCII control characters (0x00-0x1F or 0x7F)
    @inlinable
    var isAllControl: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllControl(source.utf8)
    }

    /// Returns true if all characters are ASCII visible characters (0x21-0x7E)
    @inlinable
    var isAllVisible: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllVisible(source.utf8)
    }

    /// Returns true if all characters are ASCII printable characters (0x20-0x7E)
    @inlinable
    var isAllPrintable: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllPrintable(source.utf8)
    }

    /// Returns true if all ASCII letters are lowercase (non-letters ignored)
    @inlinable
    var isAllLowercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLowercase(source.utf8)
    }

    /// Returns true if all ASCII letters are uppercase (non-letters ignored)
    @inlinable
    var isAllUppercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllUppercase(source.utf8)
    }

    /// Returns true if string contains any non-ASCII characters (>= 0x80)
    @inlinable
    var containsNonASCII: Bool {
        INCITS_4_1986.ByteArrayClassification.containsNonASCII(source.utf8)
    }

    /// Returns true if string contains at least one hex digit (0-9, A-F, a-f)
    @inlinable
    var containsHexDigit: Bool {
        INCITS_4_1986.ByteArrayClassification.containsHexDigit(source.utf8)
    }

    /// Returns true if string contains mixed line ending styles
    @inlinable
    var containsMixedLineEndings: Bool {
        INCITS_4_1986.LineEndingDetection.hasMixedLineEndings(source)
    }
}

// MARK: - StringProtocol: Static Constants

public extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Line Feed character as a string
    static var lf: Source {
        Source(decoding: [UInt8.ascii.lf], as: UTF8.self)
    }

    /// Carriage Return character as a string
    static var cr: Source {
        Source(decoding: [UInt8.ascii.cr], as: UTF8.self)
    }

    /// CRLF sequence as a string
    static var crlf: Source {
        Source(decoding: INCITS_4_1986.ControlCharacters.crlf, as: UTF8.self)
    }
}

// MARK: - StringProtocol: Static Methods

public extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Creates a string from bytes without ASCII validation
    ///
    /// Constructs a String from a byte array, assuming all bytes are valid ASCII without validation.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes: [UInt8] = [104, 101, 108, 108, 111]
    /// let text = String.ascii.unchecked(bytes)  // "hello"
    /// ```
    ///
    /// - Parameter bytes: Array of bytes to decode as ASCII (assumed valid, no checking performed)
    /// - Returns: String decoded from the bytes
    static func unchecked(_ bytes: [UInt8]) -> Source {
        Source(decoding: bytes, as: UTF8.self)
    }
}
