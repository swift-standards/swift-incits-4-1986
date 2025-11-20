# swift-incits-4-1986

Pure Swift implementation of **INCITS 4-1986 (R2022)**: Coded Character Sets - 7-Bit American Standard Code for Information Interchange (US-ASCII).

## Standard References

- **Current designation**: INCITS 4-1986 (Reaffirmed 2022)
- **Historical names**: ANSI X3.4-1986, ANSI X3.4-1968, ASA X3.4-1963
- **IANA charset**: US-ASCII
- **Character set**: 7-bit ASCII (0x00-0x7F / 0-127)

## Features

- ✅ Pure Swift with no Foundation dependencies
- ✅ Swift Embedded compatible (no existentials, no runtime features)
- ✅ Comprehensive ASCII character classification
- ✅ ASCII string validation and manipulation
- ✅ Optimized byte-level operations

## API Overview

### Byte-Level Operations (`UInt8`)

```swift
// Character classification predicates
byte.ascii.isWhitespace    // space, tab, LF, CR
byte.ascii.isDigit         // '0'...'9'
byte.ascii.isLetter        // 'A'...'Z', 'a'...'z'
byte.ascii.isAlphanumeric  // digits or letters
byte.ascii.isHexDigit      // '0'...'9', 'A'...'F', 'a'...'f'
byte.ascii.isUppercase     // 'A'...'Z'
byte.ascii.isLowercase     // 'a'...'z'

// Case conversion
byte.ascii.ascii(case: .upper)  // Convert to uppercase
byte.ascii.ascii(case: .lower)  // Convert to lowercase

// Access to ASCII constants
UInt8.ascii.sp            // 0x20 (SPACE)
UInt8.ascii.ht            // 0x09 (HORIZONTAL TAB)
```

### Character-Level Operations

```swift
// Character classification
char.ascii.isWhitespace
char.ascii.isDigit
char.ascii.isLetter
char.ascii.isAlphanumeric
char.ascii.isHexDigit
char.ascii.isUppercase
char.ascii.isLowercase
```

### String Operations

```swift
// String to ASCII bytes
let bytes = [UInt8].ascii("hello")  // [104, 101, 108, 108, 111]
let bytes = [UInt8].ascii("hello🌍")  // nil (contains non-ASCII)

// ASCII bytes to String
let string = String.ascii([104, 101, 108, 108, 111])  // "hello"
let string = String.ascii([255])  // nil (not valid ASCII)

// String trimming (with ASCII whitespace optimization)
"  hello  ".trimming(.whitespaces)  // "hello"
"***text***".trimming(["*"])        // "text"

// ASCII whitespace character set
Set<Character>.whitespaces  // {' ', '\t', '\n', '\r'}
```

## Architecture

This package follows a three-tier architecture:

**Tier 0: swift-standards** (Foundation)
- Truly generic, standard-agnostic utilities
- Collection safety, clamping, endianness, etc.

**Tier 1: swift-incits-4-1986** (This package - Standard implementation)
- Implements US-ASCII standard
- Depends on swift-standards

**Tier 2: Integration packages** (e.g., swift-uri-standard)
- Combine multiple standards
- Still pure Swift

**Tier 3: Application packages** (e.g., coenttb/swift-uri)
- Foundation integration
- Production-ready

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-incits-4-1986.git", from: "0.1.0")
]
```

## License

Licensed under Apache 2.0.

## Related Packages

- [swift-standards](../swift-standards) - Foundation utilities
- [swift-rfc-3986](../swift-rfc-3986) - URI parsing (depends on ASCII)
- [swift-rfc-9110](../swift-rfc-9110) - HTTP semantics (depends on ASCII)
