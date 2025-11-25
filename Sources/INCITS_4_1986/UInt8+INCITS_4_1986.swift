// UInt8+INCITS_4_1986.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII byte-level operations
//
// Character classification and manipulation methods for UInt8.
// For ASCII constants, use UInt8.ascii namespace (see UInt8+ASCII.swift)

import Standards

// MARK: - ASCII Namespace Access

public extension UInt8 {
    // MARK: - Namespace Access

    /// Access to ASCII type-level constants and methods
    ///
    /// Provides static access to all ASCII character constants and static utility methods.
    /// Use this to access ASCII byte values without needing to specify the full namespace.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let letterA = UInt8.ascii.A        // 0x41
    /// let space = UInt8.ascii.sp         // 0x20
    /// let tab = UInt8.ascii.htab         // 0x09
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``ASCII``
    /// - ``INCITS_4_1986``
    static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this byte
    ///
    /// Provides instance-level access to ASCII character classification and manipulation methods.
    /// Use this to query properties of a byte or perform ASCII-specific operations.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let byte: UInt8 = 0x41
    /// byte.ascii.isLetter      // true
    /// byte.ascii.isUppercase   // true
    /// byte.ascii(case: .lower) // 0x61 ('a')
    ///
    /// UInt8.ascii.sp.ascii.isWhitespace  // true
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``ASCII``
    /// - ``INCITS_4_1986``
    var ascii: ASCII {
        ASCII(byte: self)
    }

    /// ASCII operations namespace for UInt8
    ///
    /// Provides all ASCII character classification, manipulation, and constant access methods
    /// for byte-level operations per INCITS 4-1986 (US-ASCII standard).
    ///
    /// ## Overview
    ///
    /// The `ASCII` struct serves as a namespace for ASCII-related operations on bytes, providing:
    /// - **Character classification**: Test if bytes are whitespace, digits, letters, etc.
    /// - **Numeric parsing**: Convert ASCII digits to numeric values
    /// - **Case conversion**: Transform ASCII letters between upper and lower case
    /// - **Direct constant access**: All 128 ASCII character constants (0x00-0x7F)
    ///
    /// ## Performance
    ///
    /// Methods are marked `@_transparent` or `@inlinable` for optimal performance.
    /// Character classification uses direct byte comparisons rather than Set lookups.
    ///
    /// ## Access Patterns
    ///
    /// Access methods in two ways:
    /// - **Static**: `UInt8.ascii.A` - For constants and static methods
    /// - **Instance**: `byte.ascii.isLetter` - For instance classification
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986``
    /// - ``INCITS_4_1986/ControlCharacters``
    /// - ``INCITS_4_1986/GraphicCharacters``
    struct ASCII {
        /// The wrapped byte value
        public let byte: UInt8
    }
}

// MARK: - Character to Byte Conversion

public extension UInt8 {
    /// Creates ASCII byte from a character with validation
    ///
    /// Converts a Swift `Character` to its ASCII byte value, returning `nil` if the character
    /// is outside the ASCII range (U+0000 to U+007F). This initializer validates that the character
    /// fits within the 7-bit US-ASCII encoding before conversion.
    ///
    /// ## Validation
    ///
    /// Only characters in the range U+0000 to U+007F (0-127 decimal) are valid ASCII.
    /// Any character requiring more than 7 bits to encode will return `nil`:
    /// - Accented letters (é, ñ, ü, etc.) → `nil`
    /// - Emoji (🌍, 😀, etc.) → `nil`
    /// - Extended Unicode → `nil`
    ///
    /// ## Performance
    ///
    /// This initializer is marked `@inline(__always)` for optimal performance, delegating to
    /// the Swift standard library's `Character.asciiValue` property.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Valid ASCII characters
    /// UInt8(ascii: "A")     // 65 (0x41)
    /// UInt8(ascii: "0")     // 48 (0x30)
    /// UInt8(ascii: " ")     // 32 (0x20)
    /// UInt8(ascii: "\n")    // 10 (0x0A)
    ///
    /// // Non-ASCII characters
    /// UInt8(ascii: "🌍")    // nil (emoji)
    /// UInt8(ascii: "é")     // nil (accented letter)
    /// UInt8(ascii: "中")    // nil (CJK character)
    /// ```
    ///
    /// - Parameter ascii: The character to convert to ASCII byte
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986``
    /// - ``ASCII``
    @inline(__always)
    init?(ascii character: Character) {
        guard let value = character.asciiValue else { return nil }
        self = value
    }
}

public extension UInt8.ASCII {
    // MARK: - ASCII Validation

    /// Tests if this byte is valid ASCII (0x00-0x7F)
    ///
    /// Per INCITS 4-1986, valid ASCII bytes are in the range 0-127 (0x00-0x7F).
    /// Bytes with the high bit set (>= 0x80) are not valid ASCII.
    ///
    /// Use this predicate before calling other `.ascii` methods when processing
    /// untrusted byte data to ensure correct semantics.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8(0x41).ascii.isASCII  // true ('A')
    /// UInt8(0x7F).ascii.isASCII  // true (DEL - last ASCII character)
    /// UInt8(0x80).ascii.isASCII  // false (first non-ASCII byte)
    /// UInt8(0xFF).ascii.isASCII  // false
    ///
    /// // Validate before using other .ascii methods
    /// if byte.ascii.isASCII && byte.ascii.isWhitespace { ... }
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/isASCII(_:)``
    @_transparent
    var isASCII: Bool {
        INCITS_4_1986.isASCII(byte)
    }

    // MARK: - Character Classification

    /// Tests if byte is ASCII whitespace
    ///
    /// Returns `true` for the four ASCII whitespace characters defined in INCITS 4-1986:
    /// - **SPACE** (0x20): Word separator
    /// - **HORIZONTAL TAB** (0x09): Tabulation
    /// - **LINE FEED** (0x0A): End of line (Unix/macOS)
    /// - **CARRIAGE RETURN** (0x0D): End of line (classic Mac, Internet protocols)
    ///
    /// ## Performance
    ///
    /// This method is marked `@_transparent` for zero-overhead abstraction. It uses four inline
    /// equality comparisons rather than a Set lookup, which is faster for this small, fixed set.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8.ascii.sp.ascii.isWhitespace      // true (SPACE)
    /// UInt8.ascii.htab.ascii.isWhitespace    // true (TAB)
    /// UInt8.ascii.lf.ascii.isWhitespace      // true (LF)
    /// UInt8.ascii.cr.ascii.isWhitespace      // true (CR)
    /// UInt8.ascii.A.ascii.isWhitespace       // false
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/whitespaces``
    /// - ``INCITS_4_1986/CharacterClassification/isWhitespace(_:)``
    @_transparent
    var isWhitespace: Bool {
        INCITS_4_1986.CharacterClassification.isWhitespace(byte)
    }

    /// Tests if byte is ASCII control character
    ///
    /// Returns `true` for all 33 control characters defined in INCITS 4-1986:
    /// - **C0 controls**: 0x00-0x1F (NULL, SOH, STX, ..., US)
    /// - **DELETE**: 0x7F
    ///
    /// Control characters are non-printing characters used for device control, data transmission,
    /// and text formatting. They do not have visual representations.
    ///
    /// ## Control Character Ranges
    ///
    /// - **0x00 (NUL)** through **0x1F (US)**: 32 control characters
    /// - **0x7F (DEL)**: The DELETE character
    ///
    /// ## Performance
    ///
    /// This method uses two range comparisons for optimal performance, marked `@_transparent`
    /// for inline expansion.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8.ascii.nul.ascii.isControl   // true (0x00)
    /// UInt8.ascii.lf.ascii.isControl    // true (0x0A)
    /// UInt8.ascii.del.ascii.isControl   // true (0x7F)
    /// UInt8.ascii.sp.ascii.isControl    // false (SPACE is graphic)
    /// UInt8.ascii.A.ascii.isControl     // false
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/ControlCharacters``
    /// - ``INCITS_4_1986/CharacterClassification/isControl(_:)``
    @_transparent
    var isControl: Bool {
        INCITS_4_1986.CharacterClassification.isControl(byte)
    }

    /// Tests if byte is ASCII visible (non-whitespace printable) character
    ///
    /// Returns `true` for visible graphic characters (0x21-0x7E), which are printable characters
    /// **excluding SPACE**. These are characters with distinct visual glyphs.
    ///
    /// ## Character Range
    ///
    /// - **0x21 ('!')** through **0x7E ('~')**: 94 visible characters
    /// - Includes: digits, letters, punctuation, and symbols
    /// - Excludes: SPACE (0x20), all control characters, and DELETE (0x7F)
    ///
    /// ## Comparison with isPrintable
    ///
    /// - ``isVisible``: Excludes SPACE (94 characters)
    /// - ``isPrintable``: Includes SPACE (95 characters)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8.ascii.A.ascii.isVisible          // true
    /// UInt8.ascii.0.ascii.isVisible          // true
    /// UInt8.ascii.exclamationPoint.ascii.isVisible  // true
    /// UInt8.ascii.sp.ascii.isVisible         // false (SPACE not visible)
    /// UInt8.ascii.lf.ascii.isVisible         // false (control character)
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``isPrintable``
    /// - ``INCITS_4_1986/GraphicCharacters``
    /// - ``INCITS_4_1986/CharacterClassification/isVisible(_:)``
    @_transparent
    var isVisible: Bool {
        INCITS_4_1986.CharacterClassification.isVisible(byte)
    }

    /// Tests if byte is ASCII printable (graphic) character
    ///
    /// Returns `true` for all printable graphic characters (0x20-0x7E), which includes both
    /// visible characters and SPACE. These are the 95 characters that can appear in displayed text.
    ///
    /// ## Character Range
    ///
    /// - **0x20 (SPACE)** through **0x7E ('~')**: 95 printable characters
    /// - Includes: SPACE, digits, letters, punctuation, and symbols
    /// - Excludes: Control characters (0x00-0x1F) and DELETE (0x7F)
    ///
    /// ## Comparison with isVisible
    ///
    /// - ``isPrintable``: Includes SPACE (95 characters)
    /// - ``isVisible``: Excludes SPACE (94 characters)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8.ascii.A.ascii.isPrintable        // true
    /// UInt8.ascii.0.ascii.isPrintable        // true
    /// UInt8.ascii.sp.ascii.isPrintable       // true (SPACE is printable)
    /// UInt8.ascii.lf.ascii.isPrintable       // false (control character)
    /// UInt8.ascii.del.ascii.isPrintable      // false (DELETE)
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``isVisible``
    /// - ``INCITS_4_1986/GraphicCharacters``
    /// - ``INCITS_4_1986/SPACE``
    /// - ``INCITS_4_1986/CharacterClassification/isPrintable(_:)``
    @_transparent
    var isPrintable: Bool {
        INCITS_4_1986.CharacterClassification.isPrintable(byte)
    }

    // MARK: - Character Classification

    /// Tests if byte is ASCII digit ('0'...'9')
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isDigit(_:)``
    @_transparent
    var isDigit: Bool {
        INCITS_4_1986.CharacterClassification.isDigit(byte)
    }

    /// Tests if byte is ASCII letter ('A'...'Z' or 'a'...'z')
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isLetter(_:)``
    @_transparent
    var isLetter: Bool {
        INCITS_4_1986.CharacterClassification.isLetter(byte)
    }

    /// Tests if byte is ASCII alphanumeric (digit or letter)
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isAlphanumeric(_:)``
    @inlinable
    var isAlphanumeric: Bool {
        INCITS_4_1986.CharacterClassification.isAlphanumeric(byte)
    }

    /// Tests if byte is ASCII hexadecimal digit ('0'...'9', 'A'...'F', 'a'...'f')
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isHexDigit(_:)``
    @inlinable
    var isHexDigit: Bool {
        INCITS_4_1986.CharacterClassification.isHexDigit(byte)
    }

    /// Tests if byte is ASCII uppercase letter ('A'...'Z')
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isUppercase(_:)``
    @_transparent
    var isUppercase: Bool {
        INCITS_4_1986.CharacterClassification.isUppercase(byte)
    }

    /// Tests if byte is ASCII lowercase letter ('a'...'z')
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/CharacterClassification/isLowercase(_:)``
    @_transparent
    var isLowercase: Bool {
        INCITS_4_1986.CharacterClassification.isLowercase(byte)
    }

    @inlinable
    func lowercased() -> UInt8 {
        INCITS_4_1986.CaseConversion.convert(byte, to: .lower)
    }

    @inlinable
    func uppercased() -> UInt8 {
        INCITS_4_1986.CaseConversion.convert(byte, to: .upper)
    }
}

public extension UInt8.ASCII {
    // MARK: - Numeric Value Parsing (Static Transformations)

    /// Parses an ASCII digit byte to its numeric value (0-9)
    ///
    /// Pure function transformation from ASCII digit to numeric value.
    /// Inverse operation of the `isDigit` predicate.
    /// Forms a Galois connection between predicates and values.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8(ascii: digit: 0x30)  // 0 (character '0')
    /// UInt8(ascii: digit: 0x35)  // 5 (character '5')
    /// UInt8(ascii: digit: 0x39)  // 9 (character '9')
    /// UInt8(ascii: digit: 0x41)  // nil (character 'A')
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/NumericParsing/digit(_:)``
    @inlinable
    static func ascii(digit byte: UInt8) -> UInt8? {
        INCITS_4_1986.NumericParsing.digit(byte)
    }
}

public extension UInt8.ASCII {
    /// Parses an ASCII hex digit byte to its numeric value (0-15)
    ///
    /// Pure function transformation from ASCII hex digit to numeric value.
    /// Inverse operation of the `isHexDigit` predicate.
    /// Forms a Galois connection between predicates and values.
    ///
    /// Supports both uppercase and lowercase hex digits:
    /// - '0'...'9' → 0...9
    /// - 'A'...'F' → 10...15
    /// - 'a'...'f' → 10...15
    ///
    /// ## Usage
    ///
    /// ```swift
    /// UInt8(ascii: hexDigit: 0x30)  // 0 (character '0')
    /// UInt8(ascii: hexDigit: 0x39)  // 9 (character '9')
    /// UInt8(ascii: hexDigit: 0x41)  // 10 (character 'A')
    /// UInt8(ascii: hexDigit: 0x46)  // 15 (character 'F')
    /// UInt8(ascii: hexDigit: 0x61)  // 10 (character 'a')
    /// UInt8(ascii: hexDigit: 0x66)  // 15 (character 'f')
    /// UInt8(ascii: hexDigit: 0x47)  // nil (character 'G')
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/NumericParsing/hexDigit(_:)``
    @inlinable
    static func ascii(hexDigit byte: UInt8) -> UInt8? {
        INCITS_4_1986.NumericParsing.hexDigit(byte)
    }
}

public extension UInt8.ASCII {
    /// Parses an ASCII digit byte via call syntax
    ///
    /// Enables the convenient syntax: `UInt8(ascii: digit: byte)`
    @inlinable
    static func callAsFunction(digit byte: UInt8) -> UInt8? {
        INCITS_4_1986.NumericParsing.digit(byte)
    }

    /// Parses an ASCII hex digit byte via call syntax
    ///
    /// Enables the convenient syntax: `UInt8(ascii: hexDigit: byte)`
    @inlinable
    static func callAsFunction(hexDigit byte: UInt8) -> UInt8? {
        INCITS_4_1986.NumericParsing.hexDigit(byte)
    }

    /// Returns the byte if it's valid ASCII, nil otherwise
    ///
    /// Validates that the byte is in the ASCII range (0x00-0x7F).
    ///
    /// ```swift
    /// let valid = UInt8(0x41)
    /// valid.ascii()  // Optional(0x41)
    ///
    /// let invalid = UInt8(0xFF)
    /// invalid.ascii()  // nil
    /// ```
    @inlinable
    func callAsFunction() -> UInt8? {
        byte <= .ascii.del ? byte : nil
    }

    /// Converts ASCII letter to specified case via call syntax
    ///
    /// This enables the convenient syntax: `byte.ascii(case: .upper)`
    @inlinable
    func callAsFunction(case: Character.Case) -> UInt8 {
        INCITS_4_1986.CaseConversion.convert(byte, to: `case`)
    }

    /// Creates ASCII byte from a character without validation
    ///
    /// Converts a Swift `Character` to its byte value, assuming it's valid ASCII without validation.
    /// This method provides optimal performance when the caller can guarantee ASCII validity.
    ///
    /// ## Performance
    ///
    /// This method skips validation, making it more efficient than the failable initializer
    /// `UInt8(ascii:)` when you know the character is ASCII. It uses Swift's built-in UTF-8
    /// encoding to extract the first byte.
    ///
    /// ## Safety
    ///
    /// **Important**: This method does not validate the input. If the character is not ASCII,
    /// the result will be the first UTF-8 byte of the character's encoding, which may not be
    /// what you expect.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // When you know the character is ASCII
    /// let byte = UInt8.ascii.unchecked("A")  // 0x41
    /// let digit = UInt8.ascii.unchecked("5")  // 0x35
    /// let space = UInt8.ascii.unchecked(" ")  // 0x20
    /// ```
    ///
    /// - Parameter character: The character to convert to a byte (assumed ASCII, no checking performed)
    /// - Returns: The byte value of the character
    ///
    /// ## See Also
    ///
    /// - ``UInt8/init(ascii:)``
    @inline(__always)
    static func unchecked(_ character: Character) -> UInt8 {
        character.utf8.first!
    }
}

public extension UInt8.ASCII {
    // MARK: - Control Characters (direct access)

    /// NULL character (0x00)
    static var nul: UInt8 { INCITS_4_1986.ControlCharacters.nul }

    /// START OF HEADING (0x01)
    static var soh: UInt8 { INCITS_4_1986.ControlCharacters.soh }

    /// START OF TEXT (0x02)
    static var stx: UInt8 { INCITS_4_1986.ControlCharacters.stx }

    /// END OF TEXT (0x03)
    static var etx: UInt8 { INCITS_4_1986.ControlCharacters.etx }

    /// END OF TRANSMISSION (0x04)
    static var eot: UInt8 { INCITS_4_1986.ControlCharacters.eot }

    /// ENQUIRY (0x05)
    static var enq: UInt8 { INCITS_4_1986.ControlCharacters.enq }

    /// ACKNOWLEDGE (0x06)
    static var ack: UInt8 { INCITS_4_1986.ControlCharacters.ack }

    /// BELL (0x07)
    static var bel: UInt8 { INCITS_4_1986.ControlCharacters.bel }

    /// BACKSPACE (0x08)
    static var bs: UInt8 { INCITS_4_1986.ControlCharacters.bs }

    /// HORIZONTAL TAB (0x09)
    static var htab: UInt8 { INCITS_4_1986.ControlCharacters.htab }

    /// LINE FEED (0x0A)
    static var lf: UInt8 { INCITS_4_1986.ControlCharacters.lf }

    /// VERTICAL TAB (0x0B)
    static var vtab: UInt8 { INCITS_4_1986.ControlCharacters.vtab }

    /// FORM FEED (0x0C)
    static var ff: UInt8 { INCITS_4_1986.ControlCharacters.ff }

    /// CARRIAGE RETURN (0x0D)
    static var cr: UInt8 { INCITS_4_1986.ControlCharacters.cr }

    /// SHIFT OUT (0x0E)
    static var so: UInt8 { INCITS_4_1986.ControlCharacters.so }

    /// SHIFT IN (0x0F)
    static var si: UInt8 { INCITS_4_1986.ControlCharacters.si }

    /// DATA LINK ESCAPE (0x10)
    static var dle: UInt8 { INCITS_4_1986.ControlCharacters.dle }

    /// DEVICE CONTROL ONE (0x11)
    static var dc1: UInt8 { INCITS_4_1986.ControlCharacters.dc1 }

    /// DEVICE CONTROL TWO (0x12)
    static var dc2: UInt8 { INCITS_4_1986.ControlCharacters.dc2 }

    /// DEVICE CONTROL THREE (0x13)
    static var dc3: UInt8 { INCITS_4_1986.ControlCharacters.dc3 }

    /// DEVICE CONTROL FOUR (0x14)
    static var dc4: UInt8 { INCITS_4_1986.ControlCharacters.dc4 }

    /// NEGATIVE ACKNOWLEDGE (0x15)
    static var nak: UInt8 { INCITS_4_1986.ControlCharacters.nak }

    /// SYNCHRONOUS IDLE (0x16)
    static var syn: UInt8 { INCITS_4_1986.ControlCharacters.syn }

    /// END OF TRANSMISSION BLOCK (0x17)
    static var etb: UInt8 { INCITS_4_1986.ControlCharacters.etb }

    /// CANCEL (0x18)
    static var can: UInt8 { INCITS_4_1986.ControlCharacters.can }

    /// END OF MEDIUM (0x19)
    static var em: UInt8 { INCITS_4_1986.ControlCharacters.em }

    /// SUBSTITUTE (0x1A)
    static var sub: UInt8 { INCITS_4_1986.ControlCharacters.sub }

    /// ESCAPE (0x1B)
    static var esc: UInt8 { INCITS_4_1986.ControlCharacters.esc }

    /// FILE SEPARATOR (0x1C)
    static var fs: UInt8 { INCITS_4_1986.ControlCharacters.fs }

    /// GROUP SEPARATOR (0x1D)
    static var gs: UInt8 { INCITS_4_1986.ControlCharacters.gs }

    /// RECORD SEPARATOR (0x1E)
    static var rs: UInt8 { INCITS_4_1986.ControlCharacters.rs }

    /// UNIT SEPARATOR (0x1F)
    static var us: UInt8 { INCITS_4_1986.ControlCharacters.us }

    /// DELETE (0x7F)
    static var del: UInt8 { INCITS_4_1986.ControlCharacters.del }

    // MARK: - SPACE (direct access)

    /// SPACE (0x20)
    static var sp: UInt8 { INCITS_4_1986.SPACE.sp }
    static var space: UInt8 { INCITS_4_1986.SPACE.sp }

    // MARK: - Graphic Characters - Punctuation (direct access)

    /// EXCLAMATION POINT (0x21) - !
    static var exclamationPoint: UInt8 { INCITS_4_1986.GraphicCharacters.exclamationPoint }

    /// QUOTATION MARK (0x22) - "
    static var quotationMark: UInt8 { INCITS_4_1986.GraphicCharacters.quotationMark }
    static var dquote: UInt8 { INCITS_4_1986.GraphicCharacters.quotationMark }

    /// NUMBER SIGN (0x23) - #
    static var numberSign: UInt8 { INCITS_4_1986.GraphicCharacters.numberSign }

    /// DOLLAR SIGN (0x24) - $
    static var dollarSign: UInt8 { INCITS_4_1986.GraphicCharacters.dollarSign }

    /// PERCENT SIGN (0x25) - %
    static var percentSign: UInt8 { INCITS_4_1986.GraphicCharacters.percentSign }

    /// AMPERSAND (0x26) - &
    static var ampersand: UInt8 { INCITS_4_1986.GraphicCharacters.ampersand }

    /// APOSTROPHE (0x27) - '
    static var apostrophe: UInt8 { INCITS_4_1986.GraphicCharacters.apostrophe }

    /// LEFT PARENTHESIS (0x28) - (
    static var leftParenthesis: UInt8 { INCITS_4_1986.GraphicCharacters.leftParenthesis }

    /// RIGHT PARENTHESIS (0x29) - )
    static var rightParenthesis: UInt8 { INCITS_4_1986.GraphicCharacters.rightParenthesis }

    /// ASTERISK (0x2A) - *
    static var asterisk: UInt8 { INCITS_4_1986.GraphicCharacters.asterisk }

    /// PLUS SIGN (0x2B) - +
    static var plusSign: UInt8 { INCITS_4_1986.GraphicCharacters.plusSign }
    static var plus: UInt8 { INCITS_4_1986.GraphicCharacters.plusSign }

    /// COMMA (0x2C) - ,
    static var comma: UInt8 { INCITS_4_1986.GraphicCharacters.comma }

    /// HYPHEN, MINUS SIGN (0x2D) - -
    static var hyphen: UInt8 { INCITS_4_1986.GraphicCharacters.hyphen }

    /// PERIOD, DECIMAL POINT (0x2E) - .
    static var period: UInt8 { INCITS_4_1986.GraphicCharacters.period }

    /// SLANT (SOLIDUS) (0x2F) - /
    static var slant: UInt8 { INCITS_4_1986.GraphicCharacters.slant }
    static var solidus: UInt8 { INCITS_4_1986.GraphicCharacters.solidus }
    static var slash: UInt8 { INCITS_4_1986.GraphicCharacters.slant }

    // MARK: - Graphic Characters - Digits (direct access)

    /// DIGIT ZERO (0x30) - 0
    static var `0`: UInt8 { INCITS_4_1986.GraphicCharacters.`0` }

    /// DIGIT ONE (0x31) - 1
    static var `1`: UInt8 { INCITS_4_1986.GraphicCharacters.`1` }

    /// DIGIT TWO (0x32) - 2
    static var `2`: UInt8 { INCITS_4_1986.GraphicCharacters.`2` }

    /// DIGIT THREE (0x33) - 3
    static var `3`: UInt8 { INCITS_4_1986.GraphicCharacters.`3` }

    /// DIGIT FOUR (0x34) - 4
    static var `4`: UInt8 { INCITS_4_1986.GraphicCharacters.`4` }

    /// DIGIT FIVE (0x35) - 5
    static var `5`: UInt8 { INCITS_4_1986.GraphicCharacters.`5` }

    /// DIGIT SIX (0x36) - 6
    static var `6`: UInt8 { INCITS_4_1986.GraphicCharacters.`6` }

    /// DIGIT SEVEN (0x37) - 7
    static var `7`: UInt8 { INCITS_4_1986.GraphicCharacters.`7` }

    /// DIGIT EIGHT (0x38) - 8
    static var `8`: UInt8 { INCITS_4_1986.GraphicCharacters.`8` }

    /// DIGIT NINE (0x39) - 9
    static var `9`: UInt8 { INCITS_4_1986.GraphicCharacters.`9` }

    // MARK: - Graphic Characters - More Punctuation (direct access)

    /// COLON (0x3A) - :
    static var colon: UInt8 { INCITS_4_1986.GraphicCharacters.colon }

    /// SEMICOLON (0x3B) - ;
    static var semicolon: UInt8 { INCITS_4_1986.GraphicCharacters.semicolon }

    /// LESS-THAN SIGN (0x3C) - <
    static var lessThanSign: UInt8 { INCITS_4_1986.GraphicCharacters.lessThanSign }

    /// EQUALS SIGN (0x3D) - =
    static var equalsSign: UInt8 { INCITS_4_1986.GraphicCharacters.equalsSign }

    /// GREATER-THAN SIGN (0x3E) - >
    static var greaterThanSign: UInt8 { INCITS_4_1986.GraphicCharacters.greaterThanSign }

    /// QUESTION MARK (0x3F) - ?
    static var questionMark: UInt8 { INCITS_4_1986.GraphicCharacters.questionMark }

    /// COMMERCIAL AT (0x40) - @
    static var commercialAt: UInt8 { INCITS_4_1986.GraphicCharacters.commercialAt }

    // MARK: - Graphic Characters - Uppercase Letters (direct access)

    /// CAPITAL LETTER A (0x41)
    static var A: UInt8 { INCITS_4_1986.GraphicCharacters.A }

    /// CAPITAL LETTER B (0x42)
    static var B: UInt8 { INCITS_4_1986.GraphicCharacters.B }

    /// CAPITAL LETTER C (0x43)
    static var C: UInt8 { INCITS_4_1986.GraphicCharacters.C }

    /// CAPITAL LETTER D (0x44)
    static var D: UInt8 { INCITS_4_1986.GraphicCharacters.D }

    /// CAPITAL LETTER E (0x45)
    static var E: UInt8 { INCITS_4_1986.GraphicCharacters.E }

    /// CAPITAL LETTER F (0x46)
    static var F: UInt8 { INCITS_4_1986.GraphicCharacters.F }

    /// CAPITAL LETTER G (0x47)
    static var G: UInt8 { INCITS_4_1986.GraphicCharacters.G }

    /// CAPITAL LETTER H (0x48)
    static var H: UInt8 { INCITS_4_1986.GraphicCharacters.H }

    /// CAPITAL LETTER I (0x49)
    static var I: UInt8 { INCITS_4_1986.GraphicCharacters.I }

    /// CAPITAL LETTER J (0x4A)
    static var J: UInt8 { INCITS_4_1986.GraphicCharacters.J }

    /// CAPITAL LETTER K (0x4B)
    static var K: UInt8 { INCITS_4_1986.GraphicCharacters.K }

    /// CAPITAL LETTER L (0x4C)
    static var L: UInt8 { INCITS_4_1986.GraphicCharacters.L }

    /// CAPITAL LETTER M (0x4D)
    static var M: UInt8 { INCITS_4_1986.GraphicCharacters.M }

    /// CAPITAL LETTER N (0x4E)
    static var N: UInt8 { INCITS_4_1986.GraphicCharacters.N }

    /// CAPITAL LETTER O (0x4F)
    static var O: UInt8 { INCITS_4_1986.GraphicCharacters.O }

    /// CAPITAL LETTER P (0x50)
    static var P: UInt8 { INCITS_4_1986.GraphicCharacters.P }

    /// CAPITAL LETTER Q (0x51)
    static var Q: UInt8 { INCITS_4_1986.GraphicCharacters.Q }

    /// CAPITAL LETTER R (0x52)
    static var R: UInt8 { INCITS_4_1986.GraphicCharacters.R }

    /// CAPITAL LETTER S (0x53)
    static var S: UInt8 { INCITS_4_1986.GraphicCharacters.S }

    /// CAPITAL LETTER T (0x54)
    static var T: UInt8 { INCITS_4_1986.GraphicCharacters.T }

    /// CAPITAL LETTER U (0x55)
    static var U: UInt8 { INCITS_4_1986.GraphicCharacters.U }

    /// CAPITAL LETTER V (0x56)
    static var V: UInt8 { INCITS_4_1986.GraphicCharacters.V }

    /// CAPITAL LETTER W (0x57)
    static var W: UInt8 { INCITS_4_1986.GraphicCharacters.W }

    /// CAPITAL LETTER X (0x58)
    static var X: UInt8 { INCITS_4_1986.GraphicCharacters.X }

    /// CAPITAL LETTER Y (0x59)
    static var Y: UInt8 { INCITS_4_1986.GraphicCharacters.Y }

    /// CAPITAL LETTER Z (0x5A)
    static var Z: UInt8 { INCITS_4_1986.GraphicCharacters.Z }

    // MARK: - Graphic Characters - Brackets and Symbols (direct access)

    /// LEFT BRACKET (0x5B) - [
    static var leftBracket: UInt8 { INCITS_4_1986.GraphicCharacters.leftBracket }
    static var leftSquareBracket: UInt8 { INCITS_4_1986.GraphicCharacters.leftBracket }

    /// REVERSE SLANT (0x5C) - \
    static var reverseSlant: UInt8 { INCITS_4_1986.GraphicCharacters.reverseSlant }
    static var reverseSolidus: UInt8 { INCITS_4_1986.GraphicCharacters.reverseSolidus }
    static var backslash: UInt8 { INCITS_4_1986.GraphicCharacters.reverseSolidus }

    /// RIGHT BRACKET (0x5D) - ]
    static var rightBracket: UInt8 { INCITS_4_1986.GraphicCharacters.rightBracket }
    static var rightSquareBracket: UInt8 { INCITS_4_1986.GraphicCharacters.rightBracket }

    /// CIRCUMFLEX ACCENT (0x5E) - ^
    static var circumflexAccent: UInt8 { INCITS_4_1986.GraphicCharacters.circumflexAccent }

    /// UNDERLINE (LOW LINE) (0x5F) - _
    static var underline: UInt8 { INCITS_4_1986.GraphicCharacters.underline }

    /// LEFT SINGLE QUOTATION MARK, GRAVE ACCENT (0x60) - `
    static var leftSingleQuotationMark: UInt8 { INCITS_4_1986.GraphicCharacters.leftSingleQuotationMark }

    // MARK: - Graphic Characters - Lowercase Letters (direct access)

    /// SMALL LETTER A (0x61)
    static var a: UInt8 { INCITS_4_1986.GraphicCharacters.a }

    /// SMALL LETTER B (0x62)
    static var b: UInt8 { INCITS_4_1986.GraphicCharacters.b }

    /// SMALL LETTER C (0x63)
    static var c: UInt8 { INCITS_4_1986.GraphicCharacters.c }

    /// SMALL LETTER D (0x64)
    static var d: UInt8 { INCITS_4_1986.GraphicCharacters.d }

    /// SMALL LETTER E (0x65)
    static var e: UInt8 { INCITS_4_1986.GraphicCharacters.e }

    /// SMALL LETTER F (0x66)
    static var f: UInt8 { INCITS_4_1986.GraphicCharacters.f }

    /// SMALL LETTER G (0x67)
    static var g: UInt8 { INCITS_4_1986.GraphicCharacters.g }

    /// SMALL LETTER H (0x68)
    static var h: UInt8 { INCITS_4_1986.GraphicCharacters.h }

    /// SMALL LETTER I (0x69)
    static var i: UInt8 { INCITS_4_1986.GraphicCharacters.i }

    /// SMALL LETTER J (0x6A)
    static var j: UInt8 { INCITS_4_1986.GraphicCharacters.j }

    /// SMALL LETTER K (0x6B)
    static var k: UInt8 { INCITS_4_1986.GraphicCharacters.k }

    /// SMALL LETTER L (0x6C)
    static var l: UInt8 { INCITS_4_1986.GraphicCharacters.l }

    /// SMALL LETTER M (0x6D)
    static var m: UInt8 { INCITS_4_1986.GraphicCharacters.m }

    /// SMALL LETTER N (0x6E)
    static var n: UInt8 { INCITS_4_1986.GraphicCharacters.n }

    /// SMALL LETTER O (0x6F)
    static var o: UInt8 { INCITS_4_1986.GraphicCharacters.o }

    /// SMALL LETTER P (0x70)
    static var p: UInt8 { INCITS_4_1986.GraphicCharacters.p }

    /// SMALL LETTER Q (0x71)
    static var q: UInt8 { INCITS_4_1986.GraphicCharacters.q }

    /// SMALL LETTER R (0x72)
    static var r: UInt8 { INCITS_4_1986.GraphicCharacters.r }

    /// SMALL LETTER S (0x73)
    static var s: UInt8 { INCITS_4_1986.GraphicCharacters.s }

    /// SMALL LETTER T (0x74)
    static var t: UInt8 { INCITS_4_1986.GraphicCharacters.t }

    /// SMALL LETTER U (0x75)
    static var u: UInt8 { INCITS_4_1986.GraphicCharacters.u }

    /// SMALL LETTER V (0x76)
    static var v: UInt8 { INCITS_4_1986.GraphicCharacters.v }

    /// SMALL LETTER W (0x77)
    static var w: UInt8 { INCITS_4_1986.GraphicCharacters.w }

    /// SMALL LETTER X (0x78)
    static var x: UInt8 { INCITS_4_1986.GraphicCharacters.x }

    /// SMALL LETTER Y (0x79)
    static var y: UInt8 { INCITS_4_1986.GraphicCharacters.y }

    /// SMALL LETTER Z (0x7A)
    static var z: UInt8 { INCITS_4_1986.GraphicCharacters.z }

    // MARK: - Graphic Characters - Final Symbols (direct access)

    /// LEFT BRACE (0x7B) - {
    static var leftBrace: UInt8 { INCITS_4_1986.GraphicCharacters.leftBrace }

    /// VERTICAL LINE (0x7C) - |
    static var verticalLine: UInt8 { INCITS_4_1986.GraphicCharacters.verticalLine }

    /// RIGHT BRACE (0x7D) - }
    static var rightBrace: UInt8 { INCITS_4_1986.GraphicCharacters.rightBrace }

    /// TILDE (OVERLINE) (0x7E) - ~
    static var tilde: UInt8 { INCITS_4_1986.GraphicCharacters.tilde }
}

// Conveniences for common shorthands
public extension UInt8.ASCII {
    /// LESS-THAN SIGN (0x3C) - <
    static var lt: UInt8 { INCITS_4_1986.GraphicCharacters.lessThanSign }

    /// GREATER-THAN SIGN (0x3E) - >
    static var gt: UInt8 { INCITS_4_1986.GraphicCharacters.greaterThanSign }

    /// COMMERCIAL AT (0x40) - @
    static var at: UInt8 { INCITS_4_1986.GraphicCharacters.commercialAt }
    static var atSign: UInt8 { INCITS_4_1986.GraphicCharacters.commercialAt }
}
