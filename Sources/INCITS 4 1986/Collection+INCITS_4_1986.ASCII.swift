// Collection+INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// Instance .ascii accessor on byte collections

extension Collection where Element == UInt8 {
    /// Access to ASCII instance methods for this byte collection
    ///
    /// Provides instance-level access to ASCII validation and transformation methods.
    /// Returns a generic `INCITS_4_1986.ASCII` wrapper that works directly with the
    /// collection without copying.
    ///
    /// ```swift
    /// let slice = bytes[start..<end]
    /// let lower = slice.ascii.lowercased()  // No intermediate Array copy
    /// ```
    @inlinable
    public var ascii: INCITS_4_1986.ASCII<Self> {
        INCITS_4_1986.ASCII(self)
    }
}
