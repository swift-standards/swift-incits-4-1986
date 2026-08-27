import ASCII_Standard_Library_Integration
import Standard_Library_Extensions

extension [ASCII.ASCII.Code] {

    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public enum ASCII {}
}

extension [ASCII.ASCII.Code] {

    public init?(ascii s: some StringProtocol) {
        guard s.allSatisfy({ $0.isASCII }) else { return nil }
        self = s.utf8.map { ASCII.ASCII.Code($0) }
    }

    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.Line.Ending) {
        switch lineEnding {
        case .lf: self = [ASCII.ASCII.Code.lf]
        case .cr: self = [ASCII.ASCII.Code.cr]
        case .crlf: self = [ASCII.ASCII.Code].ascii.crlf
        }
    }
}

extension [ASCII.ASCII.Code].ASCII {

    public static func unchecked(_ s: some StringProtocol) -> [ASCII.ASCII.Code] {
        s.utf8.map { ASCII.ASCII.Code($0) }
    }

    public static var crlf: [ASCII.ASCII.Code] {
        [.cr, .lf]
    }

    public static var whitespaces: Set<ASCII.ASCII.Code> {
        INCITS_4_1986.whitespaces
    }
}
