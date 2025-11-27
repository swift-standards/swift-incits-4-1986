//
//  UInt8.ASCII.Serializable Tests.swift
//  swift-incits-4-1986
//
//  Tests demonstrating the UInt8.ASCII.Serializable protocol
//  with both context-free and context-dependent parsing.
//

import Testing

@testable import INCITS_4_1986

// MARK: - Context-Free Type Example

/// A simple token type that requires no parsing context.
/// Demonstrates the standard Serializable conformance pattern.
private struct Token: Sendable, Codable {
    let rawValue: String

    init(__unchecked: Void, rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Token: UInt8.ASCII.Serializable {
    enum Error: Swift.Error, Sendable, Equatable {
        case empty
        case invalidCharacter(UInt8)
    }

    // Context == Void (default), so we implement init(ascii:in:) with Void context
    init<Bytes: Collection>(ascii bytes: Bytes, in context: Void) throws(Error)
    where Bytes.Element == UInt8 {
        guard !bytes.isEmpty else { throw .empty }

        for byte in bytes {
            guard byte.ascii.isAlphanumeric || byte == .ascii.hyphen else {
                throw .invalidCharacter(byte)
            }
        }

        self.init(__unchecked: (), rawValue: String(decoding: bytes, as: UTF8.self))
    }

    static let serialize: @Sendable (Self) -> [UInt8] = { Array($0.rawValue.utf8) }
}

extension Token: Hashable {}
extension Token: CustomStringConvertible {}
extension Token: ExpressibleByStringLiteral {}

// MARK: - Context-Dependent Type Example

/// A message type that requires a delimiter to parse.
/// Demonstrates context-dependent Serializable conformance.
private struct DelimitedMessage: Sendable, Codable {
    let parts: [String]
    let delimiter: UInt8

    init(__unchecked: Void, parts: [String], delimiter: UInt8) {
        self.parts = parts
        self.delimiter = delimiter
    }
}

extension DelimitedMessage: UInt8.ASCII.Serializable {
    /// Context required for parsing - the delimiter byte
    struct Context: Sendable {
        let delimiter: UInt8
    }

    enum Error: Swift.Error, Sendable, Equatable {
        case empty
    }

    init<Bytes: Collection>(ascii bytes: Bytes, in context: Context) throws(Error)
    where Bytes.Element == UInt8 {
        guard !bytes.isEmpty else { throw .empty }

        // Split on delimiter
        var parts: [String] = []
        var current: [UInt8] = []

        for byte in bytes {
            if byte == context.delimiter {
                parts.append(String(decoding: current, as: UTF8.self))
                current = []
            } else {
                current.append(byte)
            }
        }
        // Add final part
        parts.append(String(decoding: current, as: UTF8.self))

        self.init(__unchecked: (), parts: parts, delimiter: context.delimiter)
    }

    static let serialize: @Sendable (Self) -> [UInt8] = { message in
        var result: [UInt8] = []
        for (index, part) in message.parts.enumerated() {
            if index > 0 {
                result.append(message.delimiter)
            }
            result.append(contentsOf: part.utf8)
        }
        return result
    }
}

extension DelimitedMessage: Hashable {}
extension DelimitedMessage: CustomStringConvertible {}

// MARK: - Context-Free Parsing Tests

@Suite("Serializable - Context-Free Types")
struct ContextFreeSerializableTests {
    @Test("Parse from bytes using init(ascii:)")
    func parseFromBytes() throws {
        let bytes: [UInt8] = Array("hello-world".utf8)
        let token = try Token(ascii: bytes)

        #expect(token.rawValue == "hello-world")
    }

    @Test("Parse from bytes using init(ascii:in:) with Void")
    func parseFromBytesWithVoidContext() throws {
        let bytes: [UInt8] = Array("test123".utf8)
        let token = try Token(ascii: bytes, in: ())

        #expect(token.rawValue == "test123")
    }

    @Test("Parse from string using init(_:)")
    func parseFromString() throws {
        let token = try Token("my-token")

        #expect(token.rawValue == "my-token")
    }

    @Test("String literal initialization")
    func stringLiteral() {
        let token: Token = "literal-token"

        #expect(token.rawValue == "literal-token")
    }

    @Test("Serialize to bytes")
    func serializeToBytes() throws {
        let token = try Token("hello")
        let bytes = Token.serialize(token)

        #expect(bytes == Array("hello".utf8))
    }

    @Test("Convert to String")
    func convertToString() throws {
        let token = try Token("world")
        let string = String(token)

        #expect(string == "world")
    }

    @Test("Round-trip: bytes → Token → bytes")
    func roundTripBytes() throws {
        let original: [UInt8] = Array("round-trip".utf8)
        let token = try Token(ascii: original)
        let serialized = Token.serialize(token)

        #expect(serialized == original)
    }

    @Test("Round-trip: string → Token → string")
    func roundTripString() throws {
        let original = "test-value"
        let token = try Token(original)
        let result = String(token)

        #expect(result == original)
    }

    @Test("Invalid input throws error")
    func invalidInput() {
        let bytes: [UInt8] = Array("hello world".utf8)  // space is invalid

        #expect(throws: Token.Error.self) {
            try Token(ascii: bytes)
        }
    }

    @Test("Empty input throws error")
    func emptyInput() {
        let bytes: [UInt8] = []

        #expect(throws: Token.Error.empty) {
            try Token(ascii: bytes)
        }
    }
}

// MARK: - Context-Dependent Parsing Tests

@Suite("Serializable - Context-Dependent Types")
struct ContextDependentSerializableTests {
    @Test("Parse with context using init(ascii:in:)")
    func parseWithContext() throws {
        let bytes: [UInt8] = Array("foo|bar|baz".utf8)
        let context = DelimitedMessage.Context(delimiter: .ascii.verticalLine)

        let message = try DelimitedMessage(ascii: bytes, in: context)

        #expect(message.parts == ["foo", "bar", "baz"])
        #expect(message.delimiter == .ascii.verticalLine)
    }

    @Test("Different delimiters produce different parses")
    func differentDelimiters() throws {
        let bytes: [UInt8] = Array("a,b|c".utf8)

        // Parse with comma delimiter
        let commaContext = DelimitedMessage.Context(delimiter: .ascii.comma)
        let commaMessage = try DelimitedMessage(ascii: bytes, in: commaContext)
        #expect(commaMessage.parts == ["a", "b|c"])

        // Parse with pipe delimiter
        let pipeContext = DelimitedMessage.Context(delimiter: .ascii.verticalLine)
        let pipeMessage = try DelimitedMessage(ascii: bytes, in: pipeContext)
        #expect(pipeMessage.parts == ["a,b", "c"])
    }

    @Test("Serialize to bytes")
    func serializeToBytes() throws {
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["hello", "world"],
            delimiter: .ascii.hyphen
        )

        let bytes = DelimitedMessage.serialize(message)

        #expect(bytes == Array("hello-world".utf8))
    }

    @Test("Round-trip: bytes → Message → bytes")
    func roundTrip() throws {
        let original: [UInt8] = Array("one:two:three".utf8)
        let context = DelimitedMessage.Context(delimiter: .ascii.colon)

        let message = try DelimitedMessage(ascii: original, in: context)
        let serialized = DelimitedMessage.serialize(message)

        #expect(serialized == original)
    }

    @Test("Convert to String via serialize")
    func convertToString() throws {
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["a", "b", "c"],
            delimiter: .ascii.semicolon
        )

        let string = String(message)

        #expect(string == "a;b;c")
    }

    @Test("Empty input throws error")
    func emptyInput() {
        let bytes: [UInt8] = []
        let context = DelimitedMessage.Context(delimiter: .ascii.comma)

        #expect(throws: DelimitedMessage.Error.empty) {
            try DelimitedMessage(ascii: bytes, in: context)
        }
    }

    @Test("Context-dependent type does NOT have init(_: String)")
    func noStringInit() {
        // This test documents that context-dependent types
        // don't get the automatic init(_: StringProtocol) convenience.
        // The following would not compile:
        // let message = try DelimitedMessage("a,b,c")  // Error: no context!

        // Instead, you must provide context:
        let bytes: [UInt8] = Array("a,b,c".utf8)
        let context = DelimitedMessage.Context(delimiter: .ascii.comma)
        let message = try? DelimitedMessage(ascii: bytes, in: context)

        #expect(message != nil)
    }
}

// MARK: - Category Theory Verification

@Suite("Serializable - Category Theory Properties")
struct CategoryTheoryTests {
    @Test("Void context is the unit type (terminal object)")
    func voidIsTerminal() {
        // In category theory, Void is the terminal object.
        // There's exactly one value: ()
        // A function (Void × A) → B is isomorphic to A → B

        // For context-free types, init(ascii:in:()) ≅ init(ascii:)
        let bytes: [UInt8] = Array("test".utf8)

        // Both should produce identical results:
        let viaConvenience = try? Token(ascii: bytes)
        let viaExplicit = try? Token(ascii: bytes, in: ())

        #expect(viaConvenience == viaExplicit)
    }

    @Test("Serialization is context-free (value is self-describing)")
    func serializationIsContextFree() throws {
        // Even for context-dependent types, serialization doesn't need context.
        // The value itself contains all information needed to serialize.

        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["x", "y"],
            delimiter: .ascii.comma
        )

        // Serialize without needing any context:
        let bytes = DelimitedMessage.serialize(message)

        #expect(bytes == Array("x,y".utf8))
    }

    @Test("Parse-serialize round-trip is identity (for well-formed input)")
    func parseSerializeIsIdentity() throws {
        // For well-formed input, parse ∘ serialize = id
        let original: [UInt8] = Array("valid-token".utf8)

        let token = try Token(ascii: original)
        let roundTripped = Token.serialize(token)

        #expect(roundTripped == original)
    }
}

// MARK: - UInt8.Streaming Conformance Tests

/// Example HTML-like element that composes with ASCII.Serializable types.
/// Demonstrates how streaming types can embed RFC/ASCII types seamlessly.
private struct HTMLAnchor: UInt8.Serializable {
    let href: Token
    let text: String

    static let serialize: @Sendable (Self) -> [UInt8] = { anchor in
        var buffer: [UInt8] = []
        buffer.append(contentsOf: "<a href=\"".utf8)
        anchor.href.serialize(into: &buffer)  // Token conforms via ASCII.Serializable
        buffer.append(contentsOf: "\">".utf8)
        buffer.append(contentsOf: anchor.text.utf8)
        buffer.append(contentsOf: "</a>".utf8)
        return buffer
    }
}

@Suite("Serializable - UInt8.Streaming Conformance")
struct StreamingConformanceTests {

    // MARK: - Automatic Conformance

    @Test("ASCII.Serializable types automatically conform to UInt8.Streaming")
    func automaticConformance() throws {
        let token = try Token("my-token")

        // Token conforms to UInt8.Streaming via ASCII.Serializable
        var buffer: [UInt8] = []
        token.serialize(into: &buffer)

        #expect(buffer == Array("my-token".utf8))
    }

    @Test("Context-dependent types also conform to UInt8.Streaming")
    func contextDependentConformance() {
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["a", "b", "c"],
            delimiter: .ascii.comma
        )

        // DelimitedMessage conforms to UInt8.Streaming via ASCII.Serializable
        var buffer: [UInt8] = []
        message.serialize(into: &buffer)

        #expect(buffer == Array("a,b,c".utf8))
    }

    // MARK: - Buffer-Based Serialization

    @Test("Serialize into buffer using serialize(into:)")
    func serializeIntoBuffer() throws {
        let token = try Token("hello-world")

        // Ideal streaming usage pattern
        var buffer: [UInt8] = []
        token.serialize(into: &buffer)

        #expect(buffer == Array("hello-world".utf8))
    }

    @Test("Get bytes using .bytes property")
    func bytesProperty() throws {
        let token = try Token("swift-token")

        // Convenience property from UInt8.Streaming
        let bytes = token.bytes

        #expect(bytes == Array("swift-token".utf8))
    }

    @Test("Append to existing buffer content")
    func appendToExistingBuffer() throws {
        let token = try Token("suffix")

        var buffer: [UInt8] = Array("prefix-".utf8)
        token.serialize(into: &buffer)

        #expect(buffer == Array("prefix-suffix".utf8))
    }

    // MARK: - Composition with Streaming Types

    @Test("ASCII types compose with pure streaming types")
    func composeWithStreaming() throws {
        let anchor = HTMLAnchor(
            href: try Token("example-link"),
            text: "Click here"
        )

        let result = String(anchor)

        #expect(result == "<a href=\"example-link\">Click here</a>")
    }

    @Test("Multiple ASCII types serialize into shared buffer")
    func multipleTypesIntoBuffer() throws {
        let token1 = try Token("first")
        let token2 = try Token("second")
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["a", "b"],
            delimiter: .ascii.colon
        )

        // Accumulate all into one buffer
        var buffer: [UInt8] = []
        token1.serialize(into: &buffer)
        buffer.append(UInt8(ascii: "-"))
        token2.serialize(into: &buffer)
        buffer.append(UInt8(ascii: "|"))
        message.serialize(into: &buffer)

        #expect(buffer == Array("first-second|a:b".utf8))
    }

    @Test("Pre-allocate buffer for efficiency")
    func preAllocatedBuffer() throws {
        let tokens = try (1...10).map { try Token("token-\($0)") }

        var buffer: [UInt8] = []
        buffer.reserveCapacity(200)

        for (index, token) in tokens.enumerated() {
            if index > 0 {
                buffer.append(UInt8(ascii: ","))
            }
            token.serialize(into: &buffer)
        }

        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.hasPrefix("token-1,token-2"))
        #expect(result.hasSuffix("token-10"))
    }

    // MARK: - Round-Trip via Streaming

    @Test("Round-trip through buffer produces same result as static serialize")
    func roundTripEquivalence() throws {
        let token = try Token("roundtrip-test")

        // Via static serialize
        let staticBytes = Token.serialize(token)

        // Via streaming serialize(into:)
        var streamingBuffer: [UInt8] = []
        token.serialize(into: &streamingBuffer)

        // Via .bytes property
        let propertyBytes = token.bytes

        #expect(staticBytes == streamingBuffer)
        #expect(staticBytes == propertyBytes)
    }
}

// MARK: - API Pattern Demonstrations

@Suite("Serializable - Streaming API Patterns")
struct StreamingAPIPatternTests {

    @Test("Pattern: Direct buffer writing for server response")
    func directBufferWriting() throws {
        // Simulating building an HTTP-like response
        var response: [UInt8] = []

        // Add header
        response.append(contentsOf: "X-Token: ".utf8)
        let token = try Token("auth-token-123")
        token.serialize(into: &response)
        response.append(contentsOf: "\r\n".utf8)

        let result = String(decoding: response, as: UTF8.self)
        #expect(result == "X-Token: auth-token-123\r\n")
    }

    @Test("Pattern: Building HTML with embedded RFC types")
    func htmlWithRFCTypes() throws {
        let anchor = HTMLAnchor(
            href: try Token("https-link"),
            text: "Visit site"
        )

        // Get bytes for HTTP response
        let bytes = anchor.bytes

        // Or get String for debugging/logging
        let string = String(anchor)

        #expect(bytes == Array(string.utf8))
        #expect(string == "<a href=\"https-link\">Visit site</a>")
    }

    @Test("Pattern: Reusable buffer for batch processing")
    func reusableBufferPattern() throws {
        var buffer: [UInt8] = []
        var results: [[UInt8]] = []

        let inputs = ["alpha", "beta", "gamma"]

        for input in inputs {
            buffer.removeAll(keepingCapacity: true)
            let token = try Token(input)
            token.serialize(into: &buffer)
            results.append(buffer)
        }

        #expect(results.count == 3)
        #expect(results[0] == Array("alpha".utf8))
        #expect(results[1] == Array("beta".utf8))
        #expect(results[2] == Array("gamma".utf8))
    }

    @Test("Pattern: Streaming type wrapping ASCII type")
    func streamingWrapper() throws {
        // HTMLAnchor is a streaming type that wraps Token (ASCII type)
        struct Document: UInt8.Serializable {
            let title: Token
            let links: [HTMLAnchor]

            static let serialize: @Sendable (Self) -> [UInt8] = { doc in
                var buffer: [UInt8] = []
                buffer.append(contentsOf: "<html><head><title>".utf8)
                doc.title.serialize(into: &buffer)
                buffer.append(contentsOf: "</title></head><body>".utf8)
                for link in doc.links {
                    link.serialize(into: &buffer)
                }
                buffer.append(contentsOf: "</body></html>".utf8)
                return buffer
            }
        }

        let doc = Document(
            title: try Token("My-Page"),
            links: [
                HTMLAnchor(href: try Token("link1"), text: "First"),
                HTMLAnchor(href: try Token("link2"), text: "Second"),
            ]
        )

        let html = String(doc)

        #expect(html.contains("<title>My-Page</title>"))
        #expect(html.contains("<a href=\"link1\">First</a>"))
        #expect(html.contains("<a href=\"link2\">Second</a>"))
    }
}
