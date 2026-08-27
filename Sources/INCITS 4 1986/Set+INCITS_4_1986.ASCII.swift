import Binary
import Standard_Library_Extensions

extension Set {

    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public enum ASCII {}
}

extension Set<Character>.ASCII {

    public static let whitespaces: Set<Character> = {
        var set = Set(
            INCITS_4_1986.whitespaces.map {
                Character(UnicodeScalar($0.underlying))
            }
        )
        set.insert(Character("\r\n"))
        return set
    }()

    public static func isWhitespace(_ char: Character) -> Bool {
        char.unicodeScalars.allSatisfy { scalar in
            scalar.value < 128
                && INCITS_4_1986.whitespaces.contains(
                    ASCII.ASCII.Code(UInt8(scalar.value))
                )
        }
    }
}

extension Set where Element == ASCII.ASCII.Code {

    public static var whitespaces: Set<ASCII.ASCII.Code> { INCITS_4_1986.whitespaces }
}
