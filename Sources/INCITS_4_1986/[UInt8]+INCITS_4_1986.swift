// [UInt8]+ASCII.swift
// swift-incits-4-1986
//
// Convenient namespaced access to INCITS 4-1986 (US-ASCII) constants

import Standards

// MARK: - [UInt8] ASCII Namespace

extension [UInt8] {
    /// Access to ASCII type-level constants and methods
    ///
    /// Provides static access to ASCII byte array constants and static utility methods.
    /// Use this to create byte arrays from ASCII strings or access common byte sequences.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes = [UInt8](ascii: "Hello")   // [72, 101, 108, 108, 111]
    /// let crlf = [UInt8].ascii.crlf         // [0x0D, 0x0A]
    /// let lf = [UInt8](ascii: .lf)          // [0x0A]
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``ASCII``
    /// - ``INCITS_4_1986``
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this byte array
    ///
    /// Provides instance-level access to ASCII validation and transformation methods for byte arrays.
    /// Use this to validate ASCII content or perform case conversion on byte sequences.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes: [UInt8] = [72, 101, 108, 108, 111]
    /// bytes.ascii.isAllASCII  // true
    ///
    /// let upper = bytes.ascii.convertingCase(to: .upper)  // [72, 69, 76, 76, 79]
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``ASCII``
    /// - ``INCITS_4_1986``
    public var ascii: ASCII {
        ASCII(bytes: self)
    }

    /// ASCII operations namespace for byte arrays
    ///
    /// Provides all ASCII-related operations for byte arrays per INCITS 4-1986 (US-ASCII standard).
    ///
    /// ## Overview
    ///
    /// The `ASCII` struct serves as a namespace for ASCII-related operations on byte arrays, providing:
    /// - **Validation**: Check if all bytes are valid ASCII (0x00-0x7F)
    /// - **Case conversion**: Transform ASCII letters to upper or lower case
    /// - **Common sequences**: Access standard byte sequences like CRLF and whitespace
    /// - **Creation**: Convert strings to ASCII byte arrays with validation
    ///
    /// ## Performance
    ///
    /// Methods are marked `@inlinable` where appropriate for optimal performance.
    /// Validation uses efficient byte-level checks rather than character-level iteration.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986``
    /// - ``String/ascii(_:)``
    public struct ASCII {
        /// The wrapped byte array
        public let bytes: [UInt8]

        // MARK: - Type Aliases

        public typealias SPACE = INCITS_4_1986.SPACE
        public typealias ControlCharacters = INCITS_4_1986.ControlCharacters
        public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
    }
}

// MARK: - Collection<UInt8> Extension

extension Collection where Element == UInt8 {
    /// Access to ASCII instance methods for this byte collection
    ///
    /// Provides instance-level access to ASCII validation and transformation methods.
    /// Converts to [UInt8] internally for processing.
    ///
    /// ## See Also
    ///
    /// - ``[UInt8]/ASCII``
    /// - ``INCITS_4_1986``
    public var ascii: [UInt8].ASCII {
        [UInt8].ASCII(bytes: Array(self))
    }
}

// MARK: - [UInt8] Initializers

extension [UInt8] {
    /// Creates ASCII byte array from a string with validation
    ///
    /// Converts a Swift `String` to an array of ASCII bytes, returning `nil` if any character
    /// is outside the ASCII range (U+0000 to U+007F). This method validates that all characters
    /// fit within the 7-bit US-ASCII encoding before conversion.
    ///
    /// ## Validation
    ///
    /// The method validates that all characters in the string are valid ASCII (0x00-0x7F).
    /// If any character requires more than 7 bits to encode, the method returns `nil`:
    /// - Accented letters → `nil`
    /// - Emoji → `nil`
    /// - Extended Unicode → `nil`
    ///
    /// ## Performance
    ///
    /// This method performs O(n) validation by checking each character before conversion.
    /// For known-ASCII strings, use ``ascii(unchecked:)`` to skip validation.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Valid ASCII strings
    /// [UInt8](ascii: "hello")       // [104, 101, 108, 108, 111]
    /// [UInt8](ascii: "Hello World") // [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]
    /// [UInt8](ascii: "123")         // [49, 50, 51]
    ///
    /// // Non-ASCII strings
    /// [UInt8](ascii: "hello🌍")     // nil (contains emoji)
    /// [UInt8](ascii: "café")        // nil (contains é)
    /// ```
    ///
    /// - Parameter ascii: The string to convert to ASCII bytes
    /// - Returns: Array of ASCII bytes if all characters are valid ASCII, `nil` otherwise
    ///
    /// ## See Also
    ///
    /// - ``ascii(unchecked:)``
    /// - ``String/init(ascii:)``
    public init?(ascii s: some StringProtocol) {
        guard s.allSatisfy({ $0.isASCII }) else { return nil }
        self = Array(s.utf8)
    }

    /// Creates byte array from a line ending constant
    ///
    /// Transforms a line ending enumeration value into its corresponding
    /// byte sequence. This is useful when you need line ending bytes for network protocols
    /// or file formatting.
    ///
    /// ## Line Ending Byte Sequences
    ///
    /// - **`.lf`**: Returns `[0x0A]` (Line Feed) - Unix/Linux/macOS
    /// - **`.cr`**: Returns `[0x0D]` (Carriage Return) - Classic Mac OS
    /// - **`.crlf`**: Returns `[0x0D, 0x0A]` (CR + LF) - Windows, Internet protocols
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Get line ending byte sequences
    /// let unix = [UInt8](ascii: .lf)      // [0x0A]
    /// let mac = [UInt8](ascii: .cr)       // [0x0D]
    /// let windows = [UInt8](ascii: .crlf) // [0x0D, 0x0A]
    ///
    /// // Build byte arrays with line endings
    /// var bytes: [UInt8] = [UInt8](ascii: "Line 1")!
    /// bytes += [UInt8](ascii: .crlf)
    /// bytes += [UInt8](ascii: "Line 2")!
    /// ```
    ///
    /// - Parameter ascii: The line ending style to convert to bytes
    /// - Returns: Byte array containing the line ending sequence
    ///
    /// ## See Also
    ///
    /// - ``String/LineEnding``
    /// - ``INCITS_4_1986/crlf``
    /// - ``ASCII/crlf``
    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.LineEnding) {
        switch lineEnding {
        case .lf: self = [UInt8.ascii.lf]
        case .cr: self = [UInt8.ascii.cr]
        case .crlf: self = [UInt8].ascii.crlf
        }
    }
}

// MARK: - [UInt8].ASCII Static Methods

/// Creates ASCII byte array from a string without validation
///
/// Converts a Swift `String` to an array of bytes, assuming all characters are valid ASCII
/// without validation. This method provides optimal performance when the caller can guarantee
/// ASCII validity.
///
/// ## Safety
///
/// **Important**: This method does not validate the input. If the string contains non-ASCII
/// characters, the resulting byte array will contain multi-byte UTF-8 sequences, which is
/// likely not what you want.
///
/// ## Performance
///
/// This method skips the O(n) ASCII validation check, making it more efficient than ``ascii(_:)``
/// when you know all characters are ASCII.
///
/// ## Usage
///
/// ```swift
/// // When you know the string is ASCII
/// [UInt8].ascii(unchecked: "hello")  // [104, 101, 108, 108, 111]
/// [UInt8].ascii(unchecked: "World")  // [87, 111, 114, 108, 100]
///
/// // Using with string literals (known ASCII)
/// let greeting = [UInt8].ascii(unchecked: "Hi there!")
/// ```
///
/// - Parameter string: The string to convert to bytes (assumed ASCII, no validation)
/// - Returns: Array of bytes representing the string's UTF-8 encoding
///
/// ## See Also
///
/// - ``ascii(_:)``
/// - ``String/ascii(unchecked:)``
extension [UInt8].ASCII {
    public static func unchecked(_ s: some StringProtocol) -> [UInt8] {
        Array(s.utf8)
    }
}

extension [UInt8].ASCII {

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// The canonical two-byte sequence for line endings in Internet protocols.
    /// Consists of CARRIAGE RETURN (0x0D) followed by LINE FEED (0x0A).
    ///
    /// ## Protocol Requirements
    ///
    /// CRLF is **required** by many Internet protocols per their RFCs:
    /// - HTTP (RFC 9112)
    /// - SMTP (RFC 5321)
    /// - FTP (RFC 959)
    /// - MIME (RFC 2045)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let crlf = [UInt8].ascii.crlf  // [0x0D, 0x0A]
    ///
    /// // Build HTTP response
    /// var response: [UInt8] = [UInt8].ascii("HTTP/1.1 200 OK")!
    /// response += [UInt8].ascii.crlf
    /// response += [UInt8].ascii("Content-Type: text/plain")!
    /// response += [UInt8].ascii.crlf
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/crlf``
    /// - ``ascii(lineEnding:)``
    public static var crlf: [UInt8] {
        INCITS_4_1986.ControlCharacters.crlf
    }

    /// ASCII whitespace bytes
    ///
    /// Set containing the four ASCII whitespace characters defined in INCITS 4-1986:
    /// - **0x20** (SPACE): Word separator
    /// - **0x09** (HORIZONTAL TAB): Tabulation
    /// - **0x0A** (LINE FEED): End of line (Unix/macOS)
    /// - **0x0D** (CARRIAGE RETURN): End of line (classic Mac, Internet protocols)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let ws = [UInt8].ascii.whitespaces
    ///
    /// // Check if byte is whitespace
    /// if ws.contains(0x20) {
    ///     print("Is whitespace")  // Executes
    /// }
    ///
    /// // Filter whitespace from byte array
    /// let bytes: [UInt8] = [72, 101, 32, 108, 108, 111]  // "He llo"
    /// let filtered = bytes.filter { !ws.contains($0) }   // [72, 101, 108, 108, 111]
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/whitespaces``
    /// - ``UInt8/ASCII/isWhitespace``
    public static var whitespaces: Set<UInt8> {
        INCITS_4_1986.whitespaces
    }
}

extension [UInt8].ASCII {

    /// Returns true if all bytes are valid ASCII (0x00-0x7F)
    ///
    /// Validates that every byte in the array falls within the valid US-ASCII range.
    /// Per INCITS 4-1986, valid ASCII bytes are 0x00-0x7F (0-127 decimal), using only
    /// 7 bits of the 8-bit byte.
    ///
    /// ## Validation
    ///
    /// Returns `true` only if **all** bytes have the high bit clear (< 0x80):
    /// - All bytes 0x00-0x7F → `true`
    /// - Any byte >= 0x80 → `false`
    ///
    /// ## Performance
    ///
    /// This property delegates to an optimized validation function that uses
    /// efficient byte-level checks.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Valid ASCII byte arrays
    /// [104, 101, 108, 108, 111].ascii.isAllASCII  // true ("hello")
    /// [72, 105, 33].ascii.isAllASCII              // true ("Hi!")
    /// [].ascii.isAllASCII                         // true (empty)
    ///
    /// // Invalid - contains non-ASCII bytes
    /// [104, 255, 108].ascii.isAllASCII            // false (0xFF invalid)
    /// [0x80].ascii.isAllASCII                     // false (high bit set)
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/isAllASCII(_:)``
    /// - ``[UInt8]/ascii(_:)``
    public var isAllASCII: Bool {
        INCITS_4_1986.isAllASCII(self.bytes)
    }
}

extension [UInt8].ASCII {

    /// Converts all ASCII letters in the array to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) in the byte array to the specified case,
    /// leaving all other bytes unchanged. This operates on the raw byte level, converting
    /// only the 52 ASCII letters defined in INCITS 4-1986.
    ///
    /// ## Algorithm
    ///
    /// Only the 52 ASCII letters are affected:
    /// - **Uppercase**: A-Z (0x41-0x5A)
    /// - **Lowercase**: a-z (0x61-0x7A)
    ///
    /// All other bytes, including digits, punctuation, control characters, and non-ASCII
    /// bytes, pass through unchanged.
    ///
    /// ## Performance
    ///
    /// This method is marked `@inlinable` for optimal performance. It uses efficient
    /// byte-level operations to perform the conversion.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Basic case conversion
    /// let hello = [UInt8].ascii("Hello")!
    /// hello.ascii.convertingCase(to: .upper)  // [72, 69, 76, 76, 79] ("HELLO")
    /// hello.ascii.convertingCase(to: .lower)  // [104, 101, 108, 108, 111] ("hello")
    ///
    /// // Non-letters unchanged
    /// let mixed = [UInt8].ascii("Test123!")!
    /// mixed.ascii.convertingCase(to: .upper)  // [84, 69, 83, 84, 49, 50, 51, 33] ("TEST123!")
    /// ```
    ///
    /// - Parameter case: The target case (`.upper` or `.lower`)
    /// - Returns: New byte array with ASCII letters converted to the specified case
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/ascii(_:case:)``
    /// - ``INCITS_4_1986/CaseConversion.offset``
    /// - ``String/ascii(case:)``

    /// Returns the bytes if all are valid ASCII, nil otherwise
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
    public func callAsFunction() -> [UInt8]? {
        self.isAllASCII ? self.bytes : nil
    }

    /// Converts ASCII letters to specified case
    ///
    /// Enables call syntax: `bytes.ascii(case: .upper)`
    @inlinable
    public func callAsFunction(case: Character.Case) -> [UInt8] {
        INCITS_4_1986.convert(self.bytes, to: `case`)
    }
}

extension [UInt8].ASCII {

    // MARK: - Collection Predicates

    /// Returns true if all bytes are ASCII whitespace characters
    ///
    /// Tests whether every byte in the array is one of the four ASCII whitespace characters:
    /// SPACE (0x20), HORIZONTAL TAB (0x09), LINE FEED (0x0A), or CARRIAGE RETURN (0x0D).
    ///
    /// Returns `false` for empty arrays.
    public var isAllWhitespace: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllWhitespace(self.bytes)
    }

    /// Returns true if all bytes are ASCII digits (0-9)
    ///
    /// Tests whether every byte in the array is an ASCII digit (0x30-0x39).
    ///
    /// Returns `false` for empty arrays.
    public var isAllDigits: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllDigits(self.bytes)
    }

    /// Returns true if all bytes are ASCII letters (A-Z, a-z)
    ///
    /// Tests whether every byte in the array is an ASCII letter (uppercase or lowercase).
    ///
    /// Returns `false` for empty arrays.
    public var isAllLetters: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLetters(self.bytes)
    }

    /// Returns true if all bytes are ASCII alphanumeric (A-Z, a-z, 0-9)
    ///
    /// Tests whether every byte in the array is either an ASCII letter or digit.
    ///
    /// Returns `false` for empty arrays.
    public var isAllAlphanumeric: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllAlphanumeric(self.bytes)
    }

    /// Returns true if all bytes are ASCII control characters
    ///
    /// Tests whether every byte in the array is an ASCII control character (0x00-0x1F or 0x7F).
    ///
    /// Returns `false` for empty arrays.
    public var isAllControl: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllControl(self.bytes)
    }

    /// Returns true if all bytes are ASCII visible characters
    ///
    /// Tests whether every byte in the array is a visible ASCII character (0x21-0x7E).
    /// Visible characters exclude SPACE and all control characters.
    ///
    /// Returns `false` for empty arrays.
    public var isAllVisible: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllVisible(self.bytes)
    }

    /// Returns true if all bytes are ASCII printable characters
    ///
    /// Tests whether every byte in the array is a printable ASCII character (0x20-0x7E).
    /// Printable characters include SPACE and all graphic characters.
    ///
    /// Returns `false` for empty arrays.
    public var isAllPrintable: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllPrintable(self.bytes)
    }

    /// Returns true if all letter bytes are lowercase
    ///
    /// Tests whether every ASCII letter in the array is lowercase.
    /// Non-letter bytes are ignored.
    ///
    /// Returns `true` for arrays with no letters.
    public var isAllLowercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllLowercase(self.bytes)
    }

    /// Returns true if all letter bytes are uppercase
    ///
    /// Tests whether every ASCII letter in the array is uppercase.
    /// Non-letter bytes are ignored.
    ///
    /// Returns `true` for arrays with no letters.
    public var isAllUppercase: Bool {
        INCITS_4_1986.ByteArrayClassification.isAllUppercase(self.bytes)
    }

    /// Returns true if array contains any non-ASCII bytes
    ///
    /// Tests whether any byte in the array is outside the valid ASCII range (>= 0x80).
    ///
    /// Returns `false` for empty arrays.
    public var containsNonASCII: Bool {
        INCITS_4_1986.ByteArrayClassification.containsNonASCII(self.bytes)
    }

    /// Returns true if array contains at least one hex digit byte
    ///
    /// Tests whether any byte in the array is an ASCII hex digit (0-9, A-F, a-f).
    ///
    /// Returns `false` for empty arrays.
    public var containsHexDigit: Bool {
        INCITS_4_1986.ByteArrayClassification.containsHexDigit(self.bytes)
    }
}
