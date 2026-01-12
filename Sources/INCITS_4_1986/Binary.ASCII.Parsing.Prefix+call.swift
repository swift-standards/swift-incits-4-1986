public import Parsing_Primitives
public import Binary_Primitives
public import Serialization_Primitives

extension Binary.ASCII.Parsing.Prefix {
    /// Parse prefix of byte array.
    ///
    /// - Parameter bytes: The bytes to parse.
    /// - Returns: The parsed value and count of bytes consumed.
    @inlinable
    public func call(_ bytes: [UInt8]) throws(P.Failure) -> Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output> {
        var r: Result<Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output>, P.Failure>?
        bytes.withUnsafeBufferPointer { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                r = .success(.init(value: value, count: input.consumedCount))
            } catch {
                r = .failure(error)
            }
        }
        guard let r else { preconditionFailure("unreachable: result not set") }
        return try r.get()
    }

    /// Parse prefix of byte collection.
    ///
    /// - Parameter bytes: The byte collection to parse.
    /// - Returns: The parsed value and count of bytes consumed.
    @inlinable
    public func call<Bytes: Collection>(
        _ bytes: Bytes
    ) throws(P.Failure) -> Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output>
    where Bytes.Element == UInt8 {
        var r: Result<Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output>, P.Failure>?
        _ = bytes.withContiguousStorageIfAvailable { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                r = .success(.init(value: value, count: input.consumedCount))
            } catch {
                r = .failure(error)
            }
        }
        if let r {
            return try r.get()
        }
        return try self.call(Array(bytes))
    }

    /// Parse prefix of string.
    ///
    /// - Parameter string: The string to parse (UTF-8 encoded).
    /// - Returns: The parsed value and count of bytes (UTF-8 code units) consumed.
    @inlinable
    public func call(
        _ string: some StringProtocol
    ) throws(P.Failure) -> Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output> {
        var r: Result<Serialization_Primitives.Serialization.Parsing.Prefix.Result<P.Output>, P.Failure>?
        _ = string.utf8.withContiguousStorageIfAvailable { buffer in
            var input = Binary_Primitives.Binary.Bytes.Input(borrowing: buffer)
            do throws(P.Failure) {
                let value = try parser.parse(&input)
                r = .success(.init(value: value, count: input.consumedCount))
            } catch {
                r = .failure(error)
            }
        }
        if let r {
            return try r.get()
        }
        return try self.call(Array(string.utf8))
    }
}
