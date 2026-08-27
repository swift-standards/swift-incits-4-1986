extension INCITS_4_1986 {

    @inlinable
    public static func convert<C: Swift.Collection>(
        _ codes: C,
        to case: INCITS_4_1986.Case
    ) -> [ASCII.ASCII.Code] where C.Element == ASCII.ASCII.Code {
        ASCII.ASCII.convert(codes, to: `case`)
    }

    @inlinable
    public static func convert<S: StringProtocol>(_ string: S, to case: INCITS_4_1986.Case) -> S {
        ASCII.ASCII.convert(string, to: `case`)
    }
}
