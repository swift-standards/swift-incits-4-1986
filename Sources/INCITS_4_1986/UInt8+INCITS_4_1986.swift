// UInt8.swift
// swift-incits-4-1986
//
// INCITS 4-1986: US-ASCII byte-level operations
//
// Character classification and manipulation methods for UInt8.
// For ASCII constants, use UInt8.ascii namespace (see UInt8+ASCII.swift)

import Standards

// MARK: - ASCII Whitespace (INCITS 4-1986)

extension UInt8 {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// Access to ASCII instance methods for this byte
    public var ascii: ASCII {
        ASCII(uint8: self)
    }

    public struct ASCII {
        public let uint8: UInt8

        public init(uint8: UInt8) {
            self.uint8 = uint8
        }
    }
}

// MARK: - Conversions

extension UInt8 {
    /// Creates ASCII byte from a character, nil if character is non-ASCII
    ///
    /// Validates that the character is ASCII (U+0000 to U+007F) before conversion.
    ///
    /// Example:
    /// ```swift
    /// UInt8.ascii("A")  // 65
    /// UInt8.ascii("🌍")  // nil
    /// ```
    public static func ascii(_ character: Character) -> UInt8? {
        character.asciiValue
    }
}

extension UInt8.ASCII {
    // MARK: - Character Classification

    /// Tests if byte is ASCII whitespace (0x20, 0x09, 0x0A, 0x0D)
    @inlinable
    public var isWhitespace: Bool {
        // Inline comparison for performance (4 equality checks < Set lookup)
        self.uint8 == .ascii.sp || self.uint8 == .ascii.htab || self.uint8 == .ascii.lf || self.uint8 == .ascii.cr
    }

    /// Tests if byte is ASCII control character (0x00-0x1F or 0x7F)
    ///
    /// Control characters per INCITS 4-1986 Section 4:
    /// - C0 controls: 0x00-0x1F (includes NULL, TAB, LF, CR, etc.)
    /// - DELETE: 0x7F
    @inlinable
    public var isControl: Bool {
        self.uint8 <= .ascii.us || self.uint8 == .ascii.del
    }

    /// Tests if byte is ASCII visible character (0x21-0x7E)
    ///
    /// Visible characters per INCITS 4-1986 Section 4:
    /// - Printable characters excluding SPACE: 0x21 ('!') through 0x7E ('~')
    /// - Includes digits, letters, and punctuation
    /// - Excludes control characters (0x00-0x1F), SPACE (0x20), and DELETE (0x7F)
    @inlinable
    public var isVisible: Bool {
        self.uint8 >= .ascii.exclamationPoint && self.uint8 <= .ascii.tilde
    }

    /// Tests if byte is ASCII printable character (0x20-0x7E)
    ///
    /// Printable characters per INCITS 4-1986 Section 4:
    /// - All graphic characters including SPACE: 0x20 (' ') through 0x7E ('~')
    /// - Includes SPACE, digits, letters, and punctuation
    /// - Excludes control characters (0x00-0x1F) and DELETE (0x7F)
    ///
    /// Note: `isPrintable` includes SPACE, while `isVisible` excludes it.
    @inlinable
    public var isPrintable: Bool {
        self.uint8 >= .ascii.sp && self.uint8 <= .ascii.tilde
    }

    // MARK: - Character Classification

    /// Tests if byte is ASCII digit ('0'...'9')
    @inlinable
    public var isDigit: Bool {
        self.uint8 >= .ascii.0 && self.uint8 <= .ascii.9
    }

    /// Tests if byte is ASCII letter ('A'...'Z' or 'a'...'z')
    @inlinable
    public var isLetter: Bool {
        (self.uint8 >= .ascii.A && self.uint8 <= .ascii.Z) || (self.uint8 >= .ascii.a && self.uint8 <= .ascii.z)
    }

    /// Tests if byte is ASCII alphanumeric (digit or letter)
    @inlinable
    public var isAlphanumeric: Bool {
        isDigit || isLetter
    }

    /// Tests if byte is ASCII hexadecimal digit ('0'...'9', 'A'...'F', 'a'...'f')
    @inlinable
    public var isHexDigit: Bool {
        isDigit || (self.uint8 >= .ascii.A && self.uint8 <= .ascii.F) || (self.uint8 >= .ascii.a && self.uint8 <= .ascii.f)
    }

    /// Tests if byte is ASCII uppercase letter ('A'...'Z')
    @inlinable
    public var isUppercase: Bool {
        self.uint8 >= .ascii.A && self.uint8 <= .ascii.Z
    }

    /// Tests if byte is ASCII lowercase letter ('a'...'z')
    @inlinable
    public var isLowercase: Bool {
        self.uint8 >= .ascii.a && self.uint8 <= .ascii.z
    }

    // MARK: - Numeric Value Parsing (Static Transformations)

    /// Parses an ASCII digit byte to its numeric value (0-9)
    ///
    /// Pure function transformation from ASCII digit to numeric value.
    /// Inverse operation of the `isDigit` predicate.
    /// Forms a Galois connection between predicates and values.
    ///
    /// Example:
    /// ```swift
    /// UInt8.ascii(digit: 0x30)  // 0 (character '0')
    /// UInt8.ascii(digit: 0x35)  // 5 (character '5')
    /// UInt8.ascii(digit: 0x39)  // 9 (character '9')
    /// UInt8.ascii(digit: 0x41)  // nil (character 'A')
    /// ```
    @inlinable
    public static func ascii(digit byte: UInt8) -> UInt8? {
        guard byte.ascii.isDigit else { return nil }
        return byte - UInt8.ascii.0
    }

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
    /// Example:
    /// ```swift
    /// UInt8.ascii(hexDigit: 0x30)  // 0 (character '0')
    /// UInt8.ascii(hexDigit: 0x39)  // 9 (character '9')
    /// UInt8.ascii(hexDigit: 0x41)  // 10 (character 'A')
    /// UInt8.ascii(hexDigit: 0x46)  // 15 (character 'F')
    /// UInt8.ascii(hexDigit: 0x61)  // 10 (character 'a')
    /// UInt8.ascii(hexDigit: 0x66)  // 15 (character 'f')
    /// UInt8.ascii(hexDigit: 0x47)  // nil (character 'G')
    /// ```
    @inlinable
    public static func ascii(hexDigit byte: UInt8) -> UInt8? {
        switch byte {
        case UInt8.ascii.0...UInt8.ascii.9:
            return byte - UInt8.ascii.0
        case UInt8.ascii.A...UInt8.ascii.F:
            return byte - UInt8.ascii.A + 10
        case UInt8.ascii.a...UInt8.ascii.f:
            return byte - UInt8.ascii.a + 10
        default:
            return nil
        }
    }

    // MARK: - Case Conversion

    /// Converts ASCII letter to specified case, returns unchanged if not an ASCII letter
    /// - Parameter case: The target case (upper or lower)
    /// - Returns: Converted byte if ASCII letter, unchanged otherwise
    ///
    /// Mathematical Properties:
    /// - **Idempotence**: `b.ascii(case: c).ascii(case: c) == b.ascii(case: c)`
    /// - **Involution** (for letters): `b.ascii(case: .upper).ascii(case: .lower) == b` (if `b.isLetter`)
    ///
    /// Example:
    /// ```swift
    /// UInt8(ascii: "a").ascii(case: .upper)  // 65 ("A")
    /// UInt8(ascii: "Z").ascii(case: .lower)  // 122 ("z")
    /// UInt8(ascii: "1").ascii(case: .upper)  // 49 ("1") - unchanged
    /// ```
    @inlinable
    public func ascii(case: Character.Case) -> UInt8 {
        let offset = INCITS_4_1986.caseConversionOffset
        switch `case` {
        case .upper:
            return isLowercase ? self.uint8 - offset : self.uint8
        case .lower:
            return isUppercase ? self.uint8 + offset : self.uint8
        }
    }
}

extension UInt8.ASCII {
    // MARK: - Nested Namespaces

    /// Access to SPACE constant
    public typealias SPACE = INCITS_4_1986.SPACE

    /// Access to Control Characters constants
    public typealias ControlCharacters = INCITS_4_1986.ControlCharacters

    /// Access to Graphic Characters constants
    public typealias GraphicCharacters = INCITS_4_1986.GraphicCharacters
}

extension UInt8.ASCII {

    // MARK: - Control Characters (direct access)

    /// NULL character (0x00)
    public static var nul: UInt8 { INCITS_4_1986.ControlCharacters.nul }

    /// START OF HEADING (0x01)
    public static var soh: UInt8 { INCITS_4_1986.ControlCharacters.soh }

    /// START OF TEXT (0x02)
    public static var stx: UInt8 { INCITS_4_1986.ControlCharacters.stx }

    /// END OF TEXT (0x03)
    public static var etx: UInt8 { INCITS_4_1986.ControlCharacters.etx }

    /// END OF TRANSMISSION (0x04)
    public static var eot: UInt8 { INCITS_4_1986.ControlCharacters.eot }

    /// ENQUIRY (0x05)
    public static var enq: UInt8 { INCITS_4_1986.ControlCharacters.enq }

    /// ACKNOWLEDGE (0x06)
    public static var ack: UInt8 { INCITS_4_1986.ControlCharacters.ack }

    /// BELL (0x07)
    public static var bel: UInt8 { INCITS_4_1986.ControlCharacters.bel }

    /// BACKSPACE (0x08)
    public static var bs: UInt8 { INCITS_4_1986.ControlCharacters.bs }

    /// HORIZONTAL TAB (0x09)
    public static var htab: UInt8 { INCITS_4_1986.ControlCharacters.htab }

    /// LINE FEED (0x0A)
    public static var lf: UInt8 { INCITS_4_1986.ControlCharacters.lf }

    /// VERTICAL TAB (0x0B)
    public static var vtab: UInt8 { INCITS_4_1986.ControlCharacters.vtab }

    /// FORM FEED (0x0C)
    public static var ff: UInt8 { INCITS_4_1986.ControlCharacters.ff }

    /// CARRIAGE RETURN (0x0D)
    public static var cr: UInt8 { INCITS_4_1986.ControlCharacters.cr }

    /// SHIFT OUT (0x0E)
    public static var so: UInt8 { INCITS_4_1986.ControlCharacters.so }

    /// SHIFT IN (0x0F)
    public static var si: UInt8 { INCITS_4_1986.ControlCharacters.si }

    /// DATA LINK ESCAPE (0x10)
    public static var dle: UInt8 { INCITS_4_1986.ControlCharacters.dle }

    /// DEVICE CONTROL ONE (0x11)
    public static var dc1: UInt8 { INCITS_4_1986.ControlCharacters.dc1 }

    /// DEVICE CONTROL TWO (0x12)
    public static var dc2: UInt8 { INCITS_4_1986.ControlCharacters.dc2 }

    /// DEVICE CONTROL THREE (0x13)
    public static var dc3: UInt8 { INCITS_4_1986.ControlCharacters.dc3 }

    /// DEVICE CONTROL FOUR (0x14)
    public static var dc4: UInt8 { INCITS_4_1986.ControlCharacters.dc4 }

    /// NEGATIVE ACKNOWLEDGE (0x15)
    public static var nak: UInt8 { INCITS_4_1986.ControlCharacters.nak }

    /// SYNCHRONOUS IDLE (0x16)
    public static var syn: UInt8 { INCITS_4_1986.ControlCharacters.syn }

    /// END OF TRANSMISSION BLOCK (0x17)
    public static var etb: UInt8 { INCITS_4_1986.ControlCharacters.etb }

    /// CANCEL (0x18)
    public static var can: UInt8 { INCITS_4_1986.ControlCharacters.can }

    /// END OF MEDIUM (0x19)
    public static var em: UInt8 { INCITS_4_1986.ControlCharacters.em }

    /// SUBSTITUTE (0x1A)
    public static var sub: UInt8 { INCITS_4_1986.ControlCharacters.sub }

    /// ESCAPE (0x1B)
    public static var esc: UInt8 { INCITS_4_1986.ControlCharacters.esc }

    /// FILE SEPARATOR (0x1C)
    public static var fs: UInt8 { INCITS_4_1986.ControlCharacters.fs }

    /// GROUP SEPARATOR (0x1D)
    public static var gs: UInt8 { INCITS_4_1986.ControlCharacters.gs }

    /// RECORD SEPARATOR (0x1E)
    public static var rs: UInt8 { INCITS_4_1986.ControlCharacters.rs }

    /// UNIT SEPARATOR (0x1F)
    public static var us: UInt8 { INCITS_4_1986.ControlCharacters.us }

    /// DELETE (0x7F)
    public static var del: UInt8 { INCITS_4_1986.ControlCharacters.del }

    // MARK: - SPACE (direct access)

    /// SPACE (0x20)
    public static var sp: UInt8 { INCITS_4_1986.SPACE.sp }

    // MARK: - Graphic Characters - Punctuation (direct access)

    /// EXCLAMATION POINT (0x21) - !
    public static var exclamationPoint: UInt8 { INCITS_4_1986.GraphicCharacters.exclamationPoint }

    /// QUOTATION MARK (0x22) - "
    public static var quotationMark: UInt8 { INCITS_4_1986.GraphicCharacters.quotationMark }

    /// NUMBER SIGN (0x23) - #
    public static var numberSign: UInt8 { INCITS_4_1986.GraphicCharacters.numberSign }

    /// DOLLAR SIGN (0x24) - $
    public static var dollarSign: UInt8 { INCITS_4_1986.GraphicCharacters.dollarSign }

    /// PERCENT SIGN (0x25) - %
    public static var percentSign: UInt8 { INCITS_4_1986.GraphicCharacters.percentSign }

    /// AMPERSAND (0x26) - &
    public static var ampersand: UInt8 { INCITS_4_1986.GraphicCharacters.ampersand }

    /// APOSTROPHE (0x27) - '
    public static var apostrophe: UInt8 { INCITS_4_1986.GraphicCharacters.apostrophe }

    /// LEFT PARENTHESIS (0x28) - (
    public static var leftParenthesis: UInt8 { INCITS_4_1986.GraphicCharacters.leftParenthesis }

    /// RIGHT PARENTHESIS (0x29) - )
    public static var rightParenthesis: UInt8 { INCITS_4_1986.GraphicCharacters.rightParenthesis }

    /// ASTERISK (0x2A) - *
    public static var asterisk: UInt8 { INCITS_4_1986.GraphicCharacters.asterisk }

    /// PLUS SIGN (0x2B) - +
    public static var plusSign: UInt8 { INCITS_4_1986.GraphicCharacters.plusSign }

    /// COMMA (0x2C) - ,
    public static var comma: UInt8 { INCITS_4_1986.GraphicCharacters.comma }

    /// HYPHEN, MINUS SIGN (0x2D) - -
    public static var hyphen: UInt8 { INCITS_4_1986.GraphicCharacters.hyphen }

    /// PERIOD, DECIMAL POINT (0x2E) - .
    public static var period: UInt8 { INCITS_4_1986.GraphicCharacters.period }

    /// SLANT (SOLIDUS) (0x2F) - /
    public static var slant: UInt8 { INCITS_4_1986.GraphicCharacters.slant }

    // MARK: - Graphic Characters - Digits (direct access)

    /// DIGIT ZERO (0x30) - 0
    public static var `0`: UInt8 { INCITS_4_1986.GraphicCharacters.`0` }

    /// DIGIT ONE (0x31) - 1
    public static var `1`: UInt8 { INCITS_4_1986.GraphicCharacters.`1` }

    /// DIGIT TWO (0x32) - 2
    public static var `2`: UInt8 { INCITS_4_1986.GraphicCharacters.`2` }

    /// DIGIT THREE (0x33) - 3
    public static var `3`: UInt8 { INCITS_4_1986.GraphicCharacters.`3` }

    /// DIGIT FOUR (0x34) - 4
    public static var `4`: UInt8 { INCITS_4_1986.GraphicCharacters.`4` }

    /// DIGIT FIVE (0x35) - 5
    public static var `5`: UInt8 { INCITS_4_1986.GraphicCharacters.`5` }

    /// DIGIT SIX (0x36) - 6
    public static var `6`: UInt8 { INCITS_4_1986.GraphicCharacters.`6` }

    /// DIGIT SEVEN (0x37) - 7
    public static var `7`: UInt8 { INCITS_4_1986.GraphicCharacters.`7` }

    /// DIGIT EIGHT (0x38) - 8
    public static var `8`: UInt8 { INCITS_4_1986.GraphicCharacters.`8` }

    /// DIGIT NINE (0x39) - 9
    public static var `9`: UInt8 { INCITS_4_1986.GraphicCharacters.`9` }

    // MARK: - Graphic Characters - More Punctuation (direct access)

    /// COLON (0x3A) - :
    public static var colon: UInt8 { INCITS_4_1986.GraphicCharacters.colon }

    /// SEMICOLON (0x3B) - ;
    public static var semicolon: UInt8 { INCITS_4_1986.GraphicCharacters.semicolon }

    /// LESS-THAN SIGN (0x3C) - <
    public static var lessThanSign: UInt8 { INCITS_4_1986.GraphicCharacters.lessThanSign }

    /// EQUALS SIGN (0x3D) - =
    public static var equalsSign: UInt8 { INCITS_4_1986.GraphicCharacters.equalsSign }

    /// GREATER-THAN SIGN (0x3E) - >
    public static var greaterThanSign: UInt8 { INCITS_4_1986.GraphicCharacters.greaterThanSign }

    /// QUESTION MARK (0x3F) - ?
    public static var questionMark: UInt8 { INCITS_4_1986.GraphicCharacters.questionMark }

    /// COMMERCIAL AT (0x40) - @
    public static var commercialAt: UInt8 { INCITS_4_1986.GraphicCharacters.commercialAt }

    // MARK: - Graphic Characters - Uppercase Letters (direct access)

    /// CAPITAL LETTER A (0x41)
    public static var `A`: UInt8 { INCITS_4_1986.GraphicCharacters.`A` }

    /// CAPITAL LETTER B (0x42)
    public static var `B`: UInt8 { INCITS_4_1986.GraphicCharacters.`B` }

    /// CAPITAL LETTER C (0x43)
    public static var `C`: UInt8 { INCITS_4_1986.GraphicCharacters.`C` }

    /// CAPITAL LETTER D (0x44)
    public static var `D`: UInt8 { INCITS_4_1986.GraphicCharacters.`D` }

    /// CAPITAL LETTER E (0x45)
    public static var `E`: UInt8 { INCITS_4_1986.GraphicCharacters.`E` }

    /// CAPITAL LETTER F (0x46)
    public static var `F`: UInt8 { INCITS_4_1986.GraphicCharacters.`F` }

    /// CAPITAL LETTER G (0x47)
    public static var `G`: UInt8 { INCITS_4_1986.GraphicCharacters.`G` }

    /// CAPITAL LETTER H (0x48)
    public static var `H`: UInt8 { INCITS_4_1986.GraphicCharacters.`H` }

    /// CAPITAL LETTER I (0x49)
    public static var `I`: UInt8 { INCITS_4_1986.GraphicCharacters.`I` }

    /// CAPITAL LETTER J (0x4A)
    public static var `J`: UInt8 { INCITS_4_1986.GraphicCharacters.`J` }

    /// CAPITAL LETTER K (0x4B)
    public static var `K`: UInt8 { INCITS_4_1986.GraphicCharacters.`K` }

    /// CAPITAL LETTER L (0x4C)
    public static var `L`: UInt8 { INCITS_4_1986.GraphicCharacters.`L` }

    /// CAPITAL LETTER M (0x4D)
    public static var `M`: UInt8 { INCITS_4_1986.GraphicCharacters.`M` }

    /// CAPITAL LETTER N (0x4E)
    public static var `N`: UInt8 { INCITS_4_1986.GraphicCharacters.`N` }

    /// CAPITAL LETTER O (0x4F)
    public static var `O`: UInt8 { INCITS_4_1986.GraphicCharacters.`O` }

    /// CAPITAL LETTER P (0x50)
    public static var `P`: UInt8 { INCITS_4_1986.GraphicCharacters.`P` }

    /// CAPITAL LETTER Q (0x51)
    public static var `Q`: UInt8 { INCITS_4_1986.GraphicCharacters.`Q` }

    /// CAPITAL LETTER R (0x52)
    public static var `R`: UInt8 { INCITS_4_1986.GraphicCharacters.`R` }

    /// CAPITAL LETTER S (0x53)
    public static var `S`: UInt8 { INCITS_4_1986.GraphicCharacters.`S` }

    /// CAPITAL LETTER T (0x54)
    public static var `T`: UInt8 { INCITS_4_1986.GraphicCharacters.`T` }

    /// CAPITAL LETTER U (0x55)
    public static var `U`: UInt8 { INCITS_4_1986.GraphicCharacters.`U` }

    /// CAPITAL LETTER V (0x56)
    public static var `V`: UInt8 { INCITS_4_1986.GraphicCharacters.`V` }

    /// CAPITAL LETTER W (0x57)
    public static var `W`: UInt8 { INCITS_4_1986.GraphicCharacters.`W` }

    /// CAPITAL LETTER X (0x58)
    public static var `X`: UInt8 { INCITS_4_1986.GraphicCharacters.`X` }

    /// CAPITAL LETTER Y (0x59)
    public static var `Y`: UInt8 { INCITS_4_1986.GraphicCharacters.`Y` }

    /// CAPITAL LETTER Z (0x5A)
    public static var `Z`: UInt8 { INCITS_4_1986.GraphicCharacters.`Z` }

    // MARK: - Graphic Characters - Brackets and Symbols (direct access)

    /// LEFT BRACKET (0x5B) - [
    public static var leftBracket: UInt8 { INCITS_4_1986.GraphicCharacters.leftBracket }

    /// REVERSE SLANT (0x5C) - \
    public static var reverseSlant: UInt8 { INCITS_4_1986.GraphicCharacters.reverseSlant }

    /// RIGHT BRACKET (0x5D) - ]
    public static var rightBracket: UInt8 { INCITS_4_1986.GraphicCharacters.rightBracket }

    /// CIRCUMFLEX ACCENT (0x5E) - ^
    public static var circumflexAccent: UInt8 { INCITS_4_1986.GraphicCharacters.circumflexAccent }

    /// UNDERLINE (LOW LINE) (0x5F) - _
    public static var underline: UInt8 { INCITS_4_1986.GraphicCharacters.underline }

    /// LEFT SINGLE QUOTATION MARK, GRAVE ACCENT (0x60) - `
    public static var leftSingleQuotationMark: UInt8 { INCITS_4_1986.GraphicCharacters.leftSingleQuotationMark }

    // MARK: - Graphic Characters - Lowercase Letters (direct access)

    /// SMALL LETTER A (0x61)
    public static var `a`: UInt8 { INCITS_4_1986.GraphicCharacters.`a` }

    /// SMALL LETTER B (0x62)
    public static var `b`: UInt8 { INCITS_4_1986.GraphicCharacters.`b` }

    /// SMALL LETTER C (0x63)
    public static var `c`: UInt8 { INCITS_4_1986.GraphicCharacters.`c` }

    /// SMALL LETTER D (0x64)
    public static var `d`: UInt8 { INCITS_4_1986.GraphicCharacters.`d` }

    /// SMALL LETTER E (0x65)
    public static var `e`: UInt8 { INCITS_4_1986.GraphicCharacters.`e` }

    /// SMALL LETTER F (0x66)
    public static var `f`: UInt8 { INCITS_4_1986.GraphicCharacters.`f` }

    /// SMALL LETTER G (0x67)
    public static var `g`: UInt8 { INCITS_4_1986.GraphicCharacters.`g` }

    /// SMALL LETTER H (0x68)
    public static var `h`: UInt8 { INCITS_4_1986.GraphicCharacters.`h` }

    /// SMALL LETTER I (0x69)
    public static var `i`: UInt8 { INCITS_4_1986.GraphicCharacters.`i` }

    /// SMALL LETTER J (0x6A)
    public static var `j`: UInt8 { INCITS_4_1986.GraphicCharacters.`j` }

    /// SMALL LETTER K (0x6B)
    public static var `k`: UInt8 { INCITS_4_1986.GraphicCharacters.`k` }

    /// SMALL LETTER L (0x6C)
    public static var `l`: UInt8 { INCITS_4_1986.GraphicCharacters.`l` }

    /// SMALL LETTER M (0x6D)
    public static var `m`: UInt8 { INCITS_4_1986.GraphicCharacters.`m` }

    /// SMALL LETTER N (0x6E)
    public static var `n`: UInt8 { INCITS_4_1986.GraphicCharacters.`n` }

    /// SMALL LETTER O (0x6F)
    public static var `o`: UInt8 { INCITS_4_1986.GraphicCharacters.`o` }

    /// SMALL LETTER P (0x70)
    public static var `p`: UInt8 { INCITS_4_1986.GraphicCharacters.`p` }

    /// SMALL LETTER Q (0x71)
    public static var `q`: UInt8 { INCITS_4_1986.GraphicCharacters.`q` }

    /// SMALL LETTER R (0x72)
    public static var `r`: UInt8 { INCITS_4_1986.GraphicCharacters.`r` }

    /// SMALL LETTER S (0x73)
    public static var `s`: UInt8 { INCITS_4_1986.GraphicCharacters.`s` }

    /// SMALL LETTER T (0x74)
    public static var `t`: UInt8 { INCITS_4_1986.GraphicCharacters.`t` }

    /// SMALL LETTER U (0x75)
    public static var `u`: UInt8 { INCITS_4_1986.GraphicCharacters.`u` }

    /// SMALL LETTER V (0x76)
    public static var `v`: UInt8 { INCITS_4_1986.GraphicCharacters.`v` }

    /// SMALL LETTER W (0x77)
    public static var `w`: UInt8 { INCITS_4_1986.GraphicCharacters.`w` }

    /// SMALL LETTER X (0x78)
    public static var `x`: UInt8 { INCITS_4_1986.GraphicCharacters.`x` }

    /// SMALL LETTER Y (0x79)
    public static var `y`: UInt8 { INCITS_4_1986.GraphicCharacters.`y` }

    /// SMALL LETTER Z (0x7A)
    public static var `z`: UInt8 { INCITS_4_1986.GraphicCharacters.`z` }

    // MARK: - Graphic Characters - Final Symbols (direct access)

    /// LEFT BRACE (0x7B) - {
    public static var leftBrace: UInt8 { INCITS_4_1986.GraphicCharacters.leftBrace }

    /// VERTICAL LINE (0x7C) - |
    public static var verticalLine: UInt8 { INCITS_4_1986.GraphicCharacters.verticalLine }

    /// RIGHT BRACE (0x7D) - }
    public static var rightBrace: UInt8 { INCITS_4_1986.GraphicCharacters.rightBrace }

    /// TILDE (OVERLINE) (0x7E) - ~
    public static var tilde: UInt8 { INCITS_4_1986.GraphicCharacters.tilde }
}
