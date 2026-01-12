public import Parsing_Primitives
public import Binary_Primitives

extension Binary.ASCII.Parsing.Whole {
    /// Parse entire byte array.
    ///
    /// - Parameter bytes: The bytes to parse.
    /// - Returns: The parsed value.
    /// - Throws: Parser failure or `.end(remaining:)` if bytes remain (remaining = bytes, not characters).
    @inlinable
    public func call(_ bytes: [UInt8]) throws(Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>) -> P.Output {
        // Use borrowed fast path via non-throwing closure pattern
        var r: Result<P.Output, Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>>?
        bytes.withUnsafeBufferPointer { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                if input.isEmpty {
                    r = .success(value)
                } else {
                    r = .failure(.right(.end(remaining: input.count)))
                }
            } catch {
                r = .failure(.left(error))
            }
        }
        guard let r else { preconditionFailure("unreachable: result not set") }
        return try r.get()
    }

    /// Parse entire byte collection.
    ///
    /// - Parameter bytes: The byte collection to parse.
    /// - Returns: The parsed value.
    /// - Throws: Parser failure or `.end(remaining:)` if bytes remain (remaining = bytes, not characters).
    @inlinable
    public func call<Bytes: Collection>(
        _ bytes: Bytes
    ) throws(Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>) -> P.Output
    where Bytes.Element == UInt8 {
        // Try borrowed fast path
        var r: Result<P.Output, Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>>?
        _ = bytes.withContiguousStorageIfAvailable { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                if input.isEmpty {
                    r = .success(value)
                } else {
                    r = .failure(.right(.end(remaining: input.count)))
                }
            } catch {
                r = .failure(.left(error))
            }
        }
        if let r {
            return try r.get()
        }
        // Fallback: materialize
        return try self.call(Array(bytes))
    }

    /// Parse entire string.
    ///
    /// - Parameter string: The string to parse (UTF-8 encoded).
    /// - Returns: The parsed value.
    /// - Throws: Parser failure or `.end(remaining:)` if bytes remain (remaining = UTF-8 code units, not characters).
    @inlinable
    public func call(
        _ string: some StringProtocol
    ) throws(Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>) -> P.Output {
        // Try borrowed fast path on UTF-8 view
        var r: Result<P.Output, Parsing_Primitives.Parsing.Either<P.Failure, Binary.ASCII.Parsing.Error>>?
        _ = string.utf8.withContiguousStorageIfAvailable { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                if input.isEmpty {
                    r = .success(value)
                } else {
                    r = .failure(.right(.end(remaining: input.count)))
                }
            } catch {
                r = .failure(.left(error))
            }
        }
        if let r {
            return try r.get()
        }
        // Fallback: materialize
        return try self.call(Array(string.utf8))
    }
}
