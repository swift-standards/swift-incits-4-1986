//import Testing
//@testable import INCITS_4_1986
//
//// MARK: - Trimming Characters
//
//@Suite
//struct `String - trimmingCharacters with whitespace` {
//
//    @Test
//    func `Trim whitespace from both ends`() {
//        let input = "  hello world  "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim only leading whitespace`() {
//        let input = "  hello world"
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim only trailing whitespace`() {
//        let input = "hello world  "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `No trimming needed`() {
//        let input = "hello world"
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim all whitespace types`() {
//        let input = " \t\n\rhello\t\n\r "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Preserve internal whitespace`() {
//        let input = "  hello  world  "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "hello  world")
//    }
//
//    @Test
//    func `Empty string remains empty`() {
//        let input = ""
//        let result = input.trimming(.whitespaces)
//        #expect(result == "")
//    }
//
//    @Test
//    func `Only whitespace becomes empty`() {
//        let input = "   \t\n\r   "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "")
//    }
//
//    @Test
//    func `Single character with whitespace`() {
//        let input = "  a  "
//        let result = input.trimming(.whitespaces)
//        #expect(result == "a")
//    }
//}
//
//@Suite
//struct `String - trimmingCharacters with custom character sets` {
//
//    @Test
//    func `Trim custom characters`() {
//        let input = "xxhello worldxx"
//        let result = input.trimming( ["x"])
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim multiple custom characters`() {
//        let input = "xyzHello Worldzyx"
//        let result = input.trimming( ["x", "y", "z"])
//        #expect(result == "Hello World")
//    }
//
//    @Test
//    func `Trim punctuation`() {
//        let input = "!!!Hello World!!!"
//        let result = input.trimming( ["!"])
//        #expect(result == "Hello World")
//    }
//
//    @Test
//    func `No matching characters to trim`() {
//        let input = "hello world"
//        let result = input.trimming( ["x", "y", "z"])
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Preserve internal matching characters`() {
//        let input = "xxhello x worldxx"
//        let result = input.trimming( ["x"])
//        #expect(result == "hello x world")
//    }
//
//    @Test
//    func `Empty character set performs no trimming`() {
//        let input = "  hello  "
//        let result = input.trimming( [])
//        #expect(result == "  hello  ")
//    }
//}
//
//@Suite
//struct `String - static trimmingCharacters` {
//
//    @Test
//    func `Static method trims whitespace`() {
//        let input = "  hello  "
//        let result = String.trimming(input, of: .whitespaces)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Static method with custom character set`() {
//        let input = "***text***"
//        let result = String.trimming(input, of: ["*"])
//        #expect(result == "text")
//    }
//}
//
//// MARK: - ASCII Validation
//
//@Suite
//struct `String - asciiBytes` {
//
//    @Test
//    func `Pure ASCII string returns bytes`() {
//        let result = "hello".asciiBytes
//        #expect(result != nil)
//        #expect(result == [104, 101, 108, 108, 111])
//    }
//
//    @Test
//    func `ASCII with numbers and symbols`() {
//        let result = "Hello123!".asciiBytes
//        #expect(result != nil)
//        #expect(result?.count == 9)
//    }
//
//    @Test
//    func `Empty string returns empty array`() {
//        let result = "".asciiBytes
//        #expect(result != nil)
//        #expect(result == [])
//    }
//
//    @Test
//    func `Non-ASCII character returns nil`() {
//        #expect("hello🌍".asciiBytes == nil)
//        #expect("世界".asciiBytes == nil)
//        #expect("café".asciiBytes == nil)
//    }
//
//    @Test
//    func `All ASCII characters 0-127`() {
//        for byte: UInt8 in 0...127 {
//            let str = String(UnicodeScalar(byte))
//            let result = str.asciiBytes
//            #expect(result != nil)
//            #expect(result == [byte])
//        }
//    }
//}
//
//@Suite
//struct `String - init(ascii:)` {
//
//    @Test
//    func `Valid ASCII bytes create string`() {
//        let bytes: [UInt8] = [104, 101, 108, 108, 111]
//        let result = String(ascii: bytes)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Empty bytes create empty string`() {
//        let result = String(ascii: [])
//        #expect(result == "")
//    }
//
//    @Test
//    func `Non-ASCII byte returns nil`() {
//        #expect(String(ascii: [128]) == nil)
//        #expect(String(ascii: [255]) == nil)
//        #expect(String(ascii: [104, 101, 200]) == nil)
//    }
//
//    @Test
//    func `Boundary values`() {
//        #expect(String(ascii: [0]) != nil)
//        #expect(String(ascii: [127]) != nil)
//        #expect(String(ascii: [128]) == nil)
//    }
//
//    @Test
//    func `Round trip ASCII conversion`() {
//        let original = "Hello, World! 123"
//        let bytes = original.asciiBytes
//        #expect(bytes != nil)
//        let reconstructed = String(ascii: bytes!)
//        #expect(reconstructed == original)
//    }
//}
//
//// MARK: - Line Endings
//
//@Suite
//struct `String.LineEnding - String values` {
//
//    @Test
//    func `LF string value`() {
//        #expect(String.LineEnding.lf.string == "\n")
//    }
//
//    @Test
//    func `CR string value`() {
//        #expect(String.LineEnding.cr.string == "\r")
//    }
//
//    @Test
//    func `CRLF string value`() {
//        #expect(String.LineEnding.crlf.string == "\r\n")
//    }
//}
//
//@Suite
//struct `String.LineEnding - Byte values` {
//
//    @Test
//    func `LF bytes reference UInt8 constant`() {
//        #expect(String.LineEnding.lf.bytes == [UInt8.lf])
//        #expect(String.LineEnding.lf.bytes == [0x0A])
//    }
//
//    @Test
//    func `CR bytes reference UInt8 constant`() {
//        #expect(String.LineEnding.cr.bytes == [UInt8.cr])
//        #expect(String.LineEnding.cr.bytes == [0x0D])
//    }
//
//    @Test
//    func `CRLF bytes reference UInt8 constants`() {
//        #expect(String.LineEnding.crlf.bytes == [UInt8.cr, UInt8.lf])
//        #expect(String.LineEnding.crlf.bytes == [0x0D, 0x0A])
//    }
//
//    @Test
//    func `Bytes match array constants`() {
//        #expect(String.LineEnding.lf.bytes == [UInt8].lf)
//        #expect(String.LineEnding.cr.bytes == [UInt8].cr)
//        #expect(String.LineEnding.crlf.bytes == [UInt8].crlf)
//    }
//}
//
//@Suite
//struct `String.LineEnding - Static properties` {
//
//    @Test
//    func `lineFeed is lf`() {
//        #expect(String.LineEnding.lineFeed == .lf)
//    }
//
//    @Test
//    func `carriageReturn is cr`() {
//        #expect(String.LineEnding.carriageReturn == .cr)
//    }
//
//    @Test
//    func `carriageReturnLineFeed is crlf`() {
//        #expect(String.LineEnding.carriageReturnLineFeed == .crlf)
//    }
//}
//
//@Suite
//struct `String - normalized(to:) with LF` {
//
//    @Test
//    func `CRLF to LF`() {
//        let input = "line1\r\nline2\r\nline3"
//        let result = input.normalized(to: .lf)
//        #expect(result == "line1\nline2\nline3")
//    }
//
//    @Test
//    func `CR to LF`() {
//        let input = "line1\rline2\rline3"
//        let result = input.normalized(to: .lf)
//        #expect(result == "line1\nline2\nline3")
//    }
//
//    @Test
//    func `Already LF returns unchanged`() {
//        let input = "line1\nline2\nline3"
//        let result = input.normalized(to: .lf)
//        #expect(result == input)
//    }
//
//    @Test
//    func `Mixed line endings to LF`() {
//        let input = "line1\nline2\r\nline3\rline4"
//        let result = input.normalized(to: .lf)
//        #expect(result == "line1\nline2\nline3\nline4")
//    }
//
//    @Test
//    func `No line endings unchanged`() {
//        let input = "hello world"
//        let result = input.normalized(to: .lf)
//        #expect(result == input)
//    }
//
//    @Test
//    func `Empty string`() {
//        let input = ""
//        let result = input.normalized(to: .lf)
//        #expect(result == "")
//    }
//}
//
//@Suite
//struct `String - normalized(to:) with CRLF` {
//
//    @Test
//    func `LF to CRLF`() {
//        let input = "line1\nline2\nline3"
//        let result = input.normalized(to: .crlf)
//        #expect(result == "line1\r\nline2\r\nline3")
//    }
//
//    @Test
//    func `CR to CRLF`() {
//        let input = "line1\rline2\rline3"
//        let result = input.normalized(to: .crlf)
//        #expect(result == "line1\r\nline2\r\nline3")
//    }
//
//    @Test
//    func `Already CRLF preserved`() {
//        let input = "line1\r\nline2\r\nline3"
//        let result = input.normalized(to: .crlf)
//        #expect(result == input)
//    }
//
//    @Test
//    func `Mixed line endings to CRLF`() {
//        let input = "line1\nline2\r\nline3\rline4"
//        let result = input.normalized(to: .crlf)
//        #expect(result == "line1\r\nline2\r\nline3\r\nline4")
//    }
//
//    @Test
//    func `Multiple consecutive line endings`() {
//        let input = "\n\n"
//        let result = input.normalized(to: .crlf)
//        #expect(result == "\r\n\r\n")
//    }
//}
//
//@Suite
//struct `String - normalized(to:) with CR` {
//
//    @Test
//    func `LF to CR`() {
//        let input = "line1\nline2\nline3"
//        let result = input.normalized(to: .cr)
//        #expect(result == "line1\rline2\rline3")
//    }
//
//    @Test
//    func `CRLF to CR`() {
//        let input = "line1\r\nline2\r\nline3"
//        let result = input.normalized(to: .cr)
//        #expect(result == "line1\rline2\rline3")
//    }
//
//    @Test
//    func `Already CR preserved`() {
//        let input = "line1\rline2\rline3"
//        let result = input.normalized(to: .cr)
//        #expect(result == input)
//    }
//
//    @Test
//    func `Mixed line endings to CR`() {
//        let input = "line1\nline2\r\nline3\rline4"
//        let result = input.normalized(to: .cr)
//        #expect(result == "line1\rline2\rline3\rline4")
//    }
//}
