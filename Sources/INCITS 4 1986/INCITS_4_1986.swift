public enum INCITS_4_1986 {}

extension INCITS_4_1986 {

    public typealias Case = ASCII::ASCII.Case
}

extension INCITS_4_1986 {

    public static var whitespaces: Set<ASCII::ASCII.Code> {
        ASCII::ASCII.whitespaces
    }
}
