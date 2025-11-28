//
//  UInt8.ASCII.Serializable.swift
//  swift-incits-4-1986
//
//  ASCII Serialization Protocol
//
//  This protocol captures the canonical transformation pattern for types
//  that work at the ASCII byte level (INCITS 4-1986 / ASCII standard).
//
//  ## Philosophy
//
//  Types conforming to Serializable treat [UInt8] as the canonical form.
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
//  1. `init(ascii:in:)` - byte-level parsing with context
//  2. `static var serialize` - byte-level serialization (inherited from UInt8.Serializable)
//
//  For context-free types, use `Context = Void` (the default) and
//  implement `init(ascii bytes: Bytes, in context: Void)`.
//
//  The protocol automatically provides:
//  - `init(_: some StringProtocol)` - string parsing
//  - `StringProtocol.init(_:)` - string conversion
//  - `var description: String` - (if type conforms to CustomStringConvertible)
//
//  ## Example
//
//  ```swift
//  struct EmailAddress: UInt8.ASCII.Serializable {
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

extension UInt8.ASCII {
    /// Protocol for types with canonical ASCII byte-level transformations
    ///
    /// Types conforming to this protocol work at the byte level as the primitive form,
    /// with string operations derived through composition.
    ///
    /// ## Category Theory
    ///
    /// This protocol models the relationship between structured types and byte sequences:
    /// - **Serialize**: `T → [UInt8]` (always context-free - the value is self-describing)
    /// - **Parse**: `(Context, [UInt8]) → T` (may require context to interpret bytes)
    ///
    /// The asymmetry is natural: structured values contain complete information,
    /// while raw bytes may need external context to interpret.
    ///
    /// ## Requirements
    ///
    /// Conforming types must provide:
    /// - `init(ascii:in:)` - Parse from bytes with context
    /// - `static var serialize` - Serialize to bytes (inherited from UInt8.Serializable)
    ///
    /// ## Context-Free Types (Context == Void)
    ///
    /// Most types are context-free and use `Context = Void` (the default):
    ///
    /// ```swift
    /// struct Token: UInt8.ASCII.Serializable {
    ///     init<Bytes>(ascii bytes: Bytes, in context: Void) throws(Error) { ... }
    ///     // Or use the convenience: init<Bytes>(ascii bytes: Bytes) throws(Error)
    /// }
    ///
    /// let token = try Token(ascii: bytes)  // Context-free
    /// let token = try Token("example")     // String convenience
    /// ```
    ///
    /// ## Context-Dependent Types (Context != Void)
    ///
    /// Types that require external information to parse define a custom `Context`:
    ///
    /// ```swift
    /// struct Multipart: UInt8.ASCII.Serializable {
    ///     struct Context: Sendable {
    ///         let boundary: Boundary
    ///     }
    ///
    ///     init<Bytes>(ascii bytes: Bytes, in context: Context) throws(Error) { ... }
    /// }
    ///
    /// let multipart = try Multipart(ascii: bytes, in: .init(boundary: boundary))
    /// ```
    ///
    /// ## Automatic Implementations
    ///
    /// The protocol provides:
    /// - `init(ascii:)` convenience when `Context == Void`
    /// - String parsing via `init(_: some StringProtocol)` when `Context == Void`
    /// - String conversion via `StringProtocol.init(_:)`
    /// - CustomStringConvertible (if type conforms)
    /// - `UInt8.Serializable` conformance (buffer-based serialization)
    public protocol Serializable: UInt8.Serializable {
        static func serialize(ascii serializable: Self) -> [UInt8]
        
        /// The error type for parsing failures
        associatedtype Error: Swift.Error

        /// The context type required for parsing
        ///
        /// Use `Void` (the default) for context-free types.
        /// Define a custom type for context-dependent parsing.
        ///
        /// ## Category Theory
        ///
        /// - `Void` is the terminal object (unit type) - there's exactly one value `()`.
        /// - A function `(Void, A) → B` is isomorphic to `A → B`.
        /// - Context-free parsing is the special case where Context = Void.
        associatedtype Context: Sendable = Void

        /// Parse from canonical ASCII byte representation with context
        ///
        /// This is the primary protocol requirement. Implement this method
        /// for all conforming types.
        ///
        /// - For context-free types: use `in context: Void` (or just `in _: Void`)
        /// - For context-dependent types: use your custom context type
        ///
        /// ## Category Theory
        ///
        /// Parsing transformation:
        /// - **Domain**: (Context, [UInt8])
        /// - **Codomain**: Self
        ///
        /// When Context = Void, this simplifies to `[UInt8] → Self`.
        ///
        /// - Parameters:
        ///   - bytes: The ASCII byte representation
        ///   - context: Parsing context (use `()` for context-free types)
        /// - Throws: Self.Error if the bytes are malformed
        init<Bytes: Collection>(
            ascii bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        // Note: `static var serialize` is inherited from UInt8.Serializable
    }
}

extension UInt8.ASCII.Serializable where Self: UInt8.ASCII.RawRepresentable, Self.RawValue == String {
    @_transparent
    public static func serialize(ascii serializable: Self) -> [UInt8] {
        Array(serializable.rawValue.utf8)
    }
}

extension UInt8.ASCII.Serializable {
    @_transparent
    public static var serialize: @Sendable (Self) -> [UInt8] { Self.serialize(ascii:) }
}

// String-like types → UTF-8 bytes
extension UInt8.Serializable where Self: RawRepresentable, Self.RawValue: StringProtocol {
    @_transparent
    static var serialize: @Sendable (Self) -> [UInt8] {
        { Array($0.rawValue.utf8) }
    }
}

// Byte array types → direct passthrough
extension UInt8.Serializable where Self: RawRepresentable, Self.RawValue == [UInt8] {
    @_transparent
    static var serialize: @Sendable (Self) -> [UInt8] {
        { $0.rawValue }
    }
}

extension UInt8.ASCII {
    public protocol RawRepresentable: UInt8.ASCII.Serializable, Swift.RawRepresentable {}
}

extension [UInt8] {
    @_transparent
    public init<Serializable: UInt8.ASCII.Serializable>(
        ascii serializable: Serializable
    ) {
        self = Serializable.serialize(ascii: serializable)
    }
}

// MARK: - UInt8.Serializable Default Implementation

extension UInt8.ASCII.Serializable {
    /// Default `UInt8.Serializable` implementation via `static var serialize`
    ///
    /// Automatically provided for all `UInt8.ASCII.Serializable` types.
    /// Bridges the static serialization function to the streaming protocol.
    ///
    /// ## Category Theory
    ///
    /// This bridges two equivalent representations:
    /// - `static var serialize: (Self) -> [UInt8]` (functional style)
    /// - `func serialize(into:)` (streaming/imperative style)
    ///
    /// Both represent the same transformation `Self → [UInt8]`,
    /// just with different calling conventions.
    ///
    /// ## Usage
    ///
    /// This enables ASCII types to be used in streaming contexts:
    ///
    /// ```swift
    /// struct HTMLEmail: UInt8.Serializable {
    ///     let email: RFC_5322.EmailAddress  // conforms to ASCII.Serializable
    ///
    ///     func serialize<Buffer: RangeReplaceableCollection>(
    ///         into buffer: inout Buffer
    ///     ) where Buffer.Element == UInt8 {
    ///         buffer.append(contentsOf: "<a href=\"mailto:".utf8)
    ///         email.serialize(into: &buffer)  // Uses this default impl
    ///         buffer.append(contentsOf: "\">".utf8)
    ///     }
    /// }
    /// ```
    @_transparent
    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: Self.serialize(ascii: self))
    }
}

// MARK: - Context-Free Convenience

extension UInt8.ASCII.Serializable where Context == Void {
    /// Parse from canonical ASCII byte representation (context-free convenience)
    ///
    /// This convenience initializer is available for context-free types
    /// where `Context == Void`. It simply calls `init(ascii:in:)` with `()`.
    ///
    /// ## Category Theory
    ///
    /// For context-free types, parsing simplifies to:
    /// - **Domain**: [UInt8]
    /// - **Codomain**: Self
    ///
    /// ## Example
    ///
    /// ```swift
    /// let token = try Token(ascii: bytes)
    /// ```
    ///
    /// - Parameter bytes: The ASCII byte representation
    /// - Throws: Self.Error if the bytes are malformed
    @_transparent
    public init<Bytes: Collection>(ascii bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(ascii: bytes, in: ())
    }
}

extension UInt8.ASCII.Serializable where Context == Void {
    /// Parse from string representation (STRING CONVENIENCE)
    ///
    /// Automatically provided for context-free types (`Context == Void`).
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
    @_transparent
    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: Array(string.utf8))
    }
}

extension UInt8.ASCII.RawRepresentable where Self.RawValue == String, Context == Void {
    /// Default RawRepresentable implementation for string-based raw values
    ///
    /// Automatically provided for context-free types that conform to both
    /// Serializable and RawRepresentable where RawValue is String.
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
    @_transparent
    public init?(rawValue: String) {
        try? self.init(ascii: Array(rawValue.utf8))
    }

    /// Default RawRepresentable rawValue implementation
    ///
    /// Automatically provided for types that conform to both
    /// Serializable and RawRepresentable where RawValue is String.
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
    @_transparent
    public var rawValue: String {
        String(decoding: Self.serialize(ascii: self), as: UTF8.self)
    }
}

extension UInt8.ASCII.RawRepresentable where Self.RawValue == [UInt8], Context == Void {
    /// Default RawRepresentable implementation for byte array raw values
    ///
    /// Automatically provided for context-free types that conform to both
    /// Serializable and RawRepresentable where RawValue is [UInt8].
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
    @_transparent
    public init?(rawValue: [UInt8]) {
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
    @_transparent
    public var rawValue: [UInt8] {
        Self.serialize(ascii: self)
    }
}

extension UInt8.ASCII.RawRepresentable where Self.RawValue: LosslessStringConvertible, Context == Void {
    /// Default RawRepresentable implementation for losslessly string-convertible raw values
    ///
    /// Automatically provided for context-free types that conform to both
    /// Serializable and RawRepresentable where RawValue conforms to LosslessStringConvertible.
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
    @_transparent
    public init?(rawValue: RawValue) {
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
    @inlinable
    public var rawValue: RawValue {
        let string = String(decoding: Self.serialize(ascii: self), as: UTF8.self)
        // Safe to force unwrap: LosslessStringConvertible guarantees round-trip
        return RawValue(string)!
    }
}

extension StringProtocol {
    /// String representation of an ASCII-serializable value
    ///
    /// Composes through canonical byte representation for academic correctness.
    ///
    /// ## Category Theory
    ///
    /// String display composes as:
    /// ```
    /// Serializable → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value: RFC_5322.EmailAddress = ...
    /// let string = String(value)  // Uses this initializer
    /// ```
    ///
    /// - Parameter value: Any type conforming to UInt8.ASCII.Serializable
    @_transparent
    public init<T: UInt8.ASCII.Serializable>(_ value: T) {
        self = Self(decoding: T.serialize(value), as: UTF8.self)
    }
}

extension UInt8.ASCII.Serializable where Self: CustomStringConvertible {
    /// Default CustomStringConvertible implementation via byte serialization
    ///
    /// Automatically provided for types that conform to both
    /// Serializable and CustomStringConvertible.
    ///
    /// Composes through canonical byte representation:
    /// ```
    /// Self → [UInt8] (ASCII) → String (UTF-8 interpretation)
    /// ```
    @_transparent
    public var description: String {
        String(decoding: Self.serialize(ascii: self), as: UTF8.self)
    }
}

extension UInt8.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue: CustomStringConvertible {
    /// Optimized CustomStringConvertible for RawRepresentable types with CustomStringConvertible raw values
    ///
    /// For types that store a CustomStringConvertible value internally,
    /// return the raw value's description directly.
    ///
    /// This extension takes precedence over the general CustomStringConvertible
    /// extension due to its more specific constraint (RawRepresentable with CustomStringConvertible RawValue).
    @_transparent
    public var description: String {
        rawValue.description
    }
}

extension UInt8.ASCII.Serializable
where Self: RawRepresentable, Self: CustomStringConvertible, Self.RawValue == [UInt8] {
    /// UTF-8 decoded description for byte-array backed types
    ///
    /// For types where `rawValue` is `[UInt8]`, decode the bytes as UTF-8
    /// rather than returning the array's default description (e.g., "[72, 101, 108, 108, 111]").
    ///
    /// This extension takes precedence over the general CustomStringConvertible
    /// extension due to its more specific constraint (`RawValue == [UInt8]`).
    ///
    /// ## Category Theory
    ///
    /// Composes as:
    /// ```
    /// Self → [UInt8] (rawValue) → String (UTF-8 interpretation)
    /// ```
    @_transparent
    public var description: String {
        String(decoding: rawValue, as: UTF8.self)
    }
}

// MARK: - Optional ExpressibleBy*Literal Support

extension UInt8.ASCII.Serializable
where Self: ExpressibleByStringLiteral, Context == Void {
    /// Default ExpressibleByStringLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the literal is invalid.
    ///
    /// Automatically provided when a context-free type conforms to both Serializable and
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
    /// struct Token: UInt8.ASCII.Serializable, ExpressibleByStringLiteral {
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
    @_transparent
    public init(stringLiteral value: String) {
        // Uses the Serializable protocol's init(_: StringProtocol)
        // which composes through init(ascii:)
        // swiftlint:disable:next force_try
        try! self.init(value)
    }
}

extension UInt8.ASCII.Serializable where Self: ExpressibleByIntegerLiteral, Context == Void {
    /// Default ExpressibleByIntegerLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the integer
    /// string representation is invalid for this type.
    ///
    /// Automatically provided when a context-free type conforms to both Serializable and
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
    /// struct Port: UInt8.ASCII.Serializable, ExpressibleByIntegerLiteral {
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
    @_transparent
    public init(integerLiteral value: Int) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}

extension UInt8.ASCII.Serializable where Self: ExpressibleByFloatLiteral, Context == Void {
    /// Default ExpressibleByFloatLiteral implementation
    ///
    /// **Warning**: Uses force-try. Will crash at runtime if the float
    /// string representation is invalid for this type.
    ///
    /// Automatically provided when a context-free type conforms to both Serializable and
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
    /// struct Quality: UInt8.ASCII.Serializable, ExpressibleByFloatLiteral {
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
    @_transparent
    public init(floatLiteral value: Double) {
        // swiftlint:disable:next force_try
        try! self.init(String(value))
    }
}

