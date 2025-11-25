//
//  UInt8.ASCII.Serializing.swift
//  swift-incits-4-1986
//
//  ASCII Serialization Protocol
//
//  This protocol captures the canonical transformation pattern for types
//  that work at the ASCII byte level (INCITS 4-1986 / ASCII standard).
//
//  ## Philosophy
//
//  Types conforming to Serializing treat [UInt8] as the canonical form.
//  String operations are derived through composition:
//
//  ```
//  String → [UInt8] (UTF-8) → Type  (parsing)
//  Type → [UInt8] (ASCII) → String  (serialization)
//  ```
//
//  ## Usage
//
//  Conforming types must provide:
//  1. `init(ascii bytes: [UInt8]) throws(Error)` - byte-level parsing
//  2. `static var serialize` - byte-level serialization function
//
//  The protocol automatically provides:
//  - `init(_: some StringProtocol)` - string parsing
//  - `StringProtocol.init(_:)` - string conversion
//  - `var description: String` - (if type conforms to CustomStringConvertible)
//
//  ## Example
//
//  ```swift
//  struct EmailAddress: UInt8.ASCII.Serializing {
//      init(ascii bytes: [UInt8]) throws(Error) {
//          // Parse bytes...
//      }
//
//      static let serialize: (Self) -> [UInt8] = [UInt8].init
//  }
//
//  // Now you get for free:
//  let addr = try EmailAddress("user@example.com")  // String parsing
//  let str = String(addr)                           // String conversion
//  ```
//
//  Created by Coen ten Thije Boonkkamp on 24/11/2025.
//

public extension UInt8.ASCII {
    /// Protocol for types with canonical ASCII byte-level transformations
    ///
    /// Types conforming to this protocol work at the byte level as the primitive form,
    /// with string operations derived through composition.
    ///
    /// ## Requirements
    ///
    /// Conforming types must provide:
    /// - `init(ascii bytes: [UInt8]) throws(Error)` - Parse from bytes
    /// - `static var serialize` - Serialize to bytes
    ///
    /// ## Automatic Implementations
    ///
    /// The protocol provides:
    /// - String parsing via `init(_: some StringProtocol)`
    /// - String conversion via `StringProtocol.init(_:)`
    /// - CustomStringConvertible (if type conforms)
    protocol Serializing {
        /// The error type for parsing failures
        associatedtype Error: Swift.Error

        /// Parse from canonical ASCII byte representation (CANONICAL PRIMITIVE)
        ///
        /// This is the fundamental parsing transformation at the byte level.
        ///
        /// - Parameter bytes: The ASCII byte representation
        /// - Throws: Self.Error if the bytes are malformed
        init<Bytes: Collection>(ascii bytes: Bytes) throws(Error) where Bytes.Element == UInt8

        /// Serialize to canonical ASCII byte representation (CANONICAL SERIALIZATION)
        ///
        /// This is the fundamental serialization transformation.
        /// Typically implemented as: `static let serialize = [UInt8].init`
        ///
        /// - Returns: A function that converts Self to [UInt8]
        static var serialize: @Sendable (Self) -> [UInt8] { get }
    }

    protocol RawRepresentable:
        UInt8.ASCII.Serializing,
        Swift.RawRepresentable {}
}

public extension UInt8.ASCII.Serializing {
    /// Parse from string representation (STRING CONVENIENCE)
    ///
    /// Automatically provided for all conforming types.
    /// Composes through canonical byte representation.
    ///
    /// ## Category Theory
    ///
    /// Parsing composes as:
    /// ```
    /// String → [UInt8] (UTF-8) → Self
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value = try EmailAddress("user@example.com")
    /// ```
    ///
    /// - Parameter string: The string representation to parse
    /// - Throws: Self.Error if the string is malformed
    init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: Array(string.utf8))
    }
}

public extension UInt8.ASCII.RawRepresentable where Self.RawValue == String {
    /// Default RawRepresentable implementation for string-based raw values
    ///
    /// Automatically provided for types that conform to both
    /// Serializing and RawRepresentable where RawValue is String.
    ///
    /// This provides the failable initializer that attempts to parse
    /// the raw string value through the canonical byte transformation.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// String (rawValue) → [UInt8] (UTF-8) → Self (via init(ascii:))
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let addr = EmailAddress(rawValue: "user@example.com")
    /// // Internally calls: init(ascii: Array("user@example.com".utf8))
    /// ```
    init?(rawValue: String) {
        try? self.init(ascii: Array(rawValue.utf8))
    }

    /// Default RawRepresentable rawValue implementation
    ///
    /// Automatically provided for types that conform to both
    /// Serializing and RawRepresentable where RawValue is String.
    ///
    /// Converts the type to its string representation through
    /// canonical byte serialization.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// Self → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    var rawValue: String {
        String(decoding: Self.serialize(self), as: UTF8.self)
    }
}

public extension UInt8.ASCII.RawRepresentable where Self.RawValue == [UInt8] {
    /// Default RawRepresentable implementation for byte array raw values
    ///
    /// Automatically provided for types that conform to both
    /// Serializing and RawRepresentable where RawValue is [UInt8].
    ///
    /// This provides direct access to the canonical byte representation
    /// without any string conversion overhead.
    ///
    /// ## Category Theory
    ///
    /// Direct identity transformation:
    /// ```
    /// [UInt8] (rawValue) → Self (via init(ascii:))
    /// Self → [UInt8] (via serialize)
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x41, 0x42, 0x43]  // "ABC"
    /// let value = SomeType(rawValue: bytes)
    /// ```
    init?(rawValue: [UInt8]) {
        try? self.init(ascii: rawValue)
    }

    /// Default RawRepresentable rawValue implementation for byte arrays
    ///
    /// Returns the canonical byte representation directly without conversion.
    /// This is the most efficient form since it avoids string encoding/decoding.
    ///
    /// ## Category Theory
    ///
    /// Direct serialization:
    /// ```
    /// Self → [UInt8] (via serialize)
    /// ```
    var rawValue: [UInt8] {
        Self.serialize(self)
    }
}

public extension UInt8.ASCII.RawRepresentable where Self.RawValue: LosslessStringConvertible {
    /// Default RawRepresentable implementation for losslessly string-convertible raw values
    ///
    /// Automatically provided for types that conform to both
    /// Serializing and RawRepresentable where RawValue conforms to LosslessStringConvertible.
    ///
    /// This supports types like Int, Double, UInt, etc. that can be converted
    /// to/from strings without loss of information.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// RawValue → String → [UInt8] (UTF-8) → Self (via init(ascii:))
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// // For a type with RawValue = Int:
    /// let value = SomeType(rawValue: 42)
    /// // Internally: "42" → [0x34, 0x32] → SomeType
    /// ```
    ///
    /// ## Note
    ///
    /// This extension is less specific than the String-specialized version,
    /// so types with RawValue == String will use that extension instead.
    init?(rawValue: RawValue) {
        try? self.init(ascii: Array(String(rawValue).utf8))
    }

    /// Default RawRepresentable rawValue implementation for losslessly string-convertible types
    ///
    /// Converts the serialized bytes to a string, then parses back to RawValue.
    /// Safe because LosslessStringConvertible guarantees round-trip conversion.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// Self → [UInt8] (ASCII) → String → RawValue
    /// ```
    var rawValue: RawValue {
        let string = String(decoding: Self.serialize(self), as: UTF8.self)
        // Safe to force unwrap: LosslessStringConvertible guarantees round-trip
        return RawValue(string)!
    }
}

public extension StringProtocol {
    /// String representation of an ASCII-serializable value
    ///
    /// Composes through canonical byte representation for academic correctness.
    ///
    /// ## Category Theory
    ///
    /// String display composes as:
    /// ```
    /// Serializing → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value: RFC_5322.EmailAddress = ...
    /// let string = String(value)  // Uses this initializer
    /// ```
    ///
    /// - Parameter value: Any type conforming to UInt8.ASCII.Serializing
    init<T: UInt8.ASCII.Serializing>(_ value: T) {
        self = Self(decoding: T.serialize(value), as: UTF8.self)
    }
}

public extension UInt8.ASCII.Serializing where Self: CustomStringConvertible {
    /// Default CustomStringConvertible implementation via byte serialization
    ///
    /// Automatically provided for types that conform to both
    /// Serializing and CustomStringConvertible.
    ///
    /// Composes through canonical byte representation:
    /// ```
    /// Self → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    var description: String {
        String(decoding: Self.serialize(self), as: UTF8.self)
    }
}

public extension UInt8.ASCII.Serializing where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue: CustomStringConvertible {
    /// Optimized CustomStringConvertible for RawRepresentable<String> types
    ///
    /// For types that store a String internally, avoid unnecessary
    /// byte round-tripping and return the raw value directly.
    ///
    /// This extension takes precedence over the general CustomStringConvertible
    /// extension due to its more specific constraint (RawRepresentable<String>).
    var description: String {
        rawValue.description
    }
}

// MARK: - Optional ExpressibleBy*Literal Support

public extension UInt8.ASCII.Serializing where Self: ExpressibleByStringLiteral {
    /// Default ExpressibleByStringLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the literal is invalid.
    ///
    /// Automatically provided when a type conforms to both Serializing and
    /// ExpressibleByStringLiteral. Types can override this for custom behavior
    /// (e.g., using an unchecked initializer).
    ///
    /// ## Category Theory
    ///
    /// Composes through canonical byte representation:
    /// ```
    /// String (literal) → [UInt8] (UTF-8) → Self (via init(ascii:))
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct Token: UInt8.ASCII.Serializing, ExpressibleByStringLiteral {
    ///     // init(stringLiteral:) provided automatically!
    /// }
    ///
    /// let token: Token = "abc123"  // Works!
    /// ```
    ///
    /// ## Override for Custom Behavior
    ///
    /// ```swift
    /// // To bypass validation, override:
    /// public init(stringLiteral value: String) {
    ///     self.init(unchecked: value)
    /// }
    /// ```
    init(stringLiteral value: String) {
        // Uses the Serializing protocol's init(_: StringProtocol)
        // which composes through init(ascii:)
        // swiftlint:disable:next force_try
        try! self.init(value)
    }
}

public extension UInt8.ASCII.Serializing where Self: ExpressibleByIntegerLiteral {
    /// Default ExpressibleByIntegerLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the integer
    /// string representation is invalid for this type.
    ///
    /// Automatically provided when a type conforms to both Serializing and
    /// ExpressibleByIntegerLiteral. Converts integer to string, then parses
    /// through the canonical transformation.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// Int (literal) → String → [UInt8] (UTF-8) → Self (via init(ascii:))
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct Port: UInt8.ASCII.Serializing, ExpressibleByIntegerLiteral {
    ///     // init(integerLiteral:) provided automatically!
    /// }
    ///
    /// let port: Port = 8080  // Converts to "8080" bytes
    /// ```
    ///
    /// ## Use Cases
    ///
    /// Useful for types that can represent numeric values as ASCII strings:
    /// - Port numbers
    /// - Content-Length headers
    /// - Numeric identifiers
    init(integerLiteral value: Int) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}

public extension UInt8.ASCII.Serializing where Self: ExpressibleByFloatLiteral {
    /// Default ExpressibleByFloatLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the float
    /// string representation is invalid for this type.
    ///
    /// Automatically provided when a type conforms to both Serializing and
    /// ExpressibleByFloatLiteral. Converts float to string, then parses
    /// through the canonical transformation.
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// Double (literal) → String → [UInt8] (UTF-8) → Self (via init(ascii:))
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct Quality: UInt8.ASCII.Serializing, ExpressibleByFloatLiteral {
    ///     // init(floatLiteral:) provided automatically!
    /// }
    ///
    /// let quality: Quality = 0.8  // Converts to "0.8" bytes
    /// ```
    ///
    /// ## Use Cases
    ///
    /// Useful for types that can represent decimal values as ASCII strings:
    /// - Quality values (Accept headers)
    /// - Floating-point metrics
    /// - Decimal percentages

    init(floatLiteral value: Double) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}
