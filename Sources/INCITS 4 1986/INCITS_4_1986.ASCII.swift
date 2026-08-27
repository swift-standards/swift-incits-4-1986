public import ASCII_Standard_Library_Integration
import Standard_Library_Extensions

extension INCITS_4_1986 {

    public struct ASCII<Source> {

        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    @inlinable
    public var bytes: Source { source }

    @inlinable
    public var isAllASCII: Bool {
        true
    }

    @inlinable
    public func callAsFunction() -> [ASCII.ASCII.Code]? {
        Array(source)
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    @inlinable
    public func callAsFunction(case: INCITS_4_1986.Case) -> [ASCII.ASCII.Code] {
        INCITS_4_1986.convert(source, to: `case`)
    }

    @inlinable
    public func uppercased() -> [ASCII.ASCII.Code] {
        INCITS_4_1986.convert(source, to: .upper)
    }

    @inlinable
    public func lowercased() -> [ASCII.ASCII.Code] {
        INCITS_4_1986.convert(source, to: .lower)
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    @inlinable
    public func trimming(_ characterSet: Set<ASCII.ASCII.Code>) -> Source.SubSequence {
        source.trimming(characterSet)
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    @inlinable
    public func elementsEqualCaseInsensitive<Other: Swift.Collection>(
        _ other: Other
    ) -> Bool where Other.Element == ASCII.ASCII.Code {
        guard source.count == other.count else { return false }

        var sourceIterator = source.makeIterator()
        var otherIterator = other.makeIterator()

        while let s = sourceIterator.next(), let o = otherIterator.next() {

            guard
                INCITS_4_1986.Case.Conversion.convert(s, to: .lower)
                    == INCITS_4_1986.Case.Conversion.convert(o, to: .lower)
            else {
                return false
            }
        }

        return true
    }

    @inlinable
    public func hasPrefix<Prefix: Swift.Collection>(
        caseInsensitive prefix: Prefix
    ) -> Bool where Prefix.Element == ASCII.ASCII.Code {
        guard source.count >= prefix.count else { return false }

        var sourceIndex = source.startIndex
        for prefixCode in prefix {
            guard
                INCITS_4_1986.Case.Conversion.convert(source[sourceIndex], to: .lower)
                    == INCITS_4_1986.Case.Conversion.convert(prefixCode, to: .lower)
            else {
                return false
            }
            sourceIndex = source.index(after: sourceIndex)
        }

        return true
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    public typealias LineRange = Range<Source.Index>

    @inlinable
    public func lineRanges(estimatedLineCount: Int? = nil) -> [LineRange] {
        var ranges: [LineRange] = []
        if let estimate = estimatedLineCount {
            ranges.reserveCapacity(estimate)
        }

        var lineStart = source.startIndex
        var index = source.startIndex

        while index < source.endIndex {
            let code = source[index]

            if code == ASCII.ASCII.Code.cr {

                ranges.append(lineStart..<index)

                let next = source.index(after: index)
                if next < source.endIndex && source[next] == ASCII.ASCII.Code.lf {

                    index = source.index(after: next)
                } else {

                    index = next
                }
                lineStart = index
            } else if code == ASCII.ASCII.Code.lf {

                ranges.append(lineStart..<index)
                index = source.index(after: index)
                lineStart = index
            } else {
                index = source.index(after: index)
            }
        }

        if lineStart < source.endIndex {
            ranges.append(lineStart..<source.endIndex)
        }

        return ranges
    }

    @inlinable
    public func lines() -> [[ASCII.ASCII.Code]] {
        lineRanges().map { Array(source[$0]) }
    }
}

extension INCITS_4_1986.ASCII
where Source: Swift.Collection, Source.Element == ASCII.ASCII.Code {

    @inlinable
    public var isAllWhitespace: Bool {
        ASCII.Classification.isAllWhitespace(source)
    }

    @inlinable
    public var isAllDigits: Bool {
        ASCII.Classification.isAllDigits(source)
    }

    @inlinable
    public var isAllLetters: Bool {
        ASCII.Classification.isAllLetters(source)
    }

    @inlinable
    public var isAllAlphanumeric: Bool {
        ASCII.Classification.isAllAlphanumeric(source)
    }

    @inlinable
    public var isAllControl: Bool {
        ASCII.Classification.isAllControl(source)
    }

    @inlinable
    public var isAllVisible: Bool {
        ASCII.Classification.isAllVisible(source)
    }

    @inlinable
    public var isAllPrintable: Bool {
        ASCII.Classification.isAllPrintable(source)
    }

    @inlinable
    public var isAllLowercase: Bool {
        ASCII.Classification.isAllLowercase(source)
    }

    @inlinable
    public var isAllUppercase: Bool {
        ASCII.Classification.isAllUppercase(source)
    }

    @inlinable
    public var containsNonASCII: Bool {
        false
    }

    @inlinable
    public var containsHexDigit: Bool {
        ASCII.Classification.containsHexDigit(source)
    }
}

extension INCITS_4_1986.ASCII where Source: StringProtocol {

    @inlinable
    public var value: Source { source }

    @inlinable
    public var isAllASCII: Bool {
        INCITS_4_1986.Text.Classification.isAllASCII(source)
    }

    @inlinable
    public func callAsFunction() -> Source? {
        isAllASCII ? source : nil
    }
}

extension INCITS_4_1986.ASCII where Source: StringProtocol {

    @inlinable
    public func callAsFunction(case: INCITS_4_1986.Case) -> Source {
        INCITS_4_1986.convert(source, to: `case`)
    }

    @inlinable
    public func uppercased() -> Source {
        INCITS_4_1986.convert(source, to: .upper)
    }

    @inlinable
    public func lowercased() -> Source {
        INCITS_4_1986.convert(source, to: .lower)
    }

    @inlinable
    public func detectedLineEnding() -> INCITS_4_1986.FormatEffectors.Line.Ending? {
        INCITS_4_1986.LineEnding.Detection.detect(source)
    }
}

extension INCITS_4_1986.ASCII where Source: StringProtocol {

    @inlinable
    public var isAllWhitespace: Bool {
        ASCII.Classification.isAllWhitespace(source.utf8)
    }

    @inlinable
    public var isAllDigits: Bool {
        ASCII.Classification.isAllDigits(source.utf8)
    }

    @inlinable
    public var isAllLetters: Bool {
        ASCII.Classification.isAllLetters(source.utf8)
    }

    @inlinable
    public var isAllAlphanumeric: Bool {
        ASCII.Classification.isAllAlphanumeric(source.utf8)
    }

    @inlinable
    public var isAllControl: Bool {
        ASCII.Classification.isAllControl(source.utf8)
    }

    @inlinable
    public var isAllVisible: Bool {
        ASCII.Classification.isAllVisible(source.utf8)
    }

    @inlinable
    public var isAllPrintable: Bool {
        ASCII.Classification.isAllPrintable(source.utf8)
    }

    @inlinable
    public var isAllLowercase: Bool {
        ASCII.Classification.isAllLowercase(source.utf8)
    }

    @inlinable
    public var isAllUppercase: Bool {
        ASCII.Classification.isAllUppercase(source.utf8)
    }

    @inlinable
    public var containsNonASCII: Bool {
        ASCII.Classification.containsNonASCII(source.utf8)
    }

    @inlinable
    public var containsHexDigit: Bool {
        ASCII.Classification.containsHexDigit(source.utf8)
    }

    @inlinable
    public var containsMixedLineEndings: Bool {
        INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(source)
    }
}

extension INCITS_4_1986.ASCII where Source: StringProtocol {

    public static var lf: Source {
        Source(decoding: [INCITS_4_1986.Character.Control.lf], as: UTF8.self)
    }

    public static var cr: Source {
        Source(decoding: [INCITS_4_1986.Character.Control.cr], as: UTF8.self)
    }

    public static var crlf: Source {
        Source(decoding: INCITS_4_1986.Character.Control.crlf, as: UTF8.self)
    }
}

extension INCITS_4_1986.ASCII where Source: StringProtocol {

    public static func unchecked(_ bytes: [UInt8]) -> Source {
        Source(decoding: bytes, as: UTF8.self)
    }
}
