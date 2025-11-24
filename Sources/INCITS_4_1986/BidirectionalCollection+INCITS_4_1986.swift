// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// BidirectionalCollection+INCITS_4_1986.swift
// swift-incits-4-1986
//
// Stdlib extensions that delegate to authoritative INCITS 4-1986 implementations

extension BidirectionalCollection where Element == UInt8 {
    /// Trims ASCII bytes from both ends of the collection
    ///
    /// Delegates to the authoritative INCITS 4-1986 implementation.
    ///
    /// - Parameter characterSet: The set of ASCII byte values to trim
    /// - Returns: A subsequence with the specified bytes trimmed from both ends
    public func trimming(_ characterSet: Set<UInt8>) -> SubSequence {
        INCITS_4_1986.trimming(self, of: characterSet)
    }
}
