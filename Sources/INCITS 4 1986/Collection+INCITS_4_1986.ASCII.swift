extension Collection where Element == ASCII::ASCII.Code {

    @inlinable
    public var ascii: INCITS_4_1986.ASCII<Self> {
        INCITS_4_1986.ASCII(self)
    }
}
