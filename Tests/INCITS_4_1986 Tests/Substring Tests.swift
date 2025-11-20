//import Testing
//@testable import INCITS_4_1986
//
//@Suite
//struct `Substring - trimmingCharacters` {
//
//    @Test
//    func `Trim substring whitespace`() {
//        let string = "  hello world  "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim substring custom characters`() {
//        let string = "xxhelloxx"
//        let substring = string[...]
//        let result = substring.trimming(["x"])
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Trim substring range with whitespace`() {
//        let string = "  prefix: hello world :suffix  "
//        let start = string.index(string.startIndex, offsetBy: 9)
//        let end = string.index(string.endIndex, offsetBy: -10)
//        let substring = string[start..<end]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Trim empty substring`() {
//        let string = ""
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "")
//    }
//
//    @Test
//    func `Trim substring with only whitespace`() {
//        let string = "   \t\n   "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "")
//    }
//
//    @Test
//    func `Trim substring preserving internal characters`() {
//        let string = "  hello  world  "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello  world")
//    }
//
//    @Test
//    func `Trim substring with mixed whitespace types`() {
//        let string = " \t\n\rtext\t\n\r "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "text")
//    }
//
//    @Test
//    func `Trim substring without matching characters`() {
//        let string = "hello"
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello")
//    }
//}
//
//@Suite
//struct `Substring - static trimmingCharacters` {
//
//    @Test
//    func `Static method trims whitespace`() {
//        let string = "  test  "
//        let substring = string[...]
//        let result = Substring.trimming(substring, of: .whitespaces)
//        #expect(result == "test")
//    }
//
//    @Test
//    func `Static method trims custom characters`() {
//        let string = "***value***"
//        let substring = string[...]
//        let result = Substring.trimming(substring, of: ["*"])
//        #expect(result == "value")
//    }
//
//    @Test
//    func `Static method with empty character set`() {
//        let string = "  test  "
//        let substring = string[...]
//        let result = Substring.trimming(substring, of: [])
//        #expect(result == "  test  ")
//    }
//}
//
//@Suite
//struct `Substring - UTF-8 fast path optimization` {
//
//    @Test
//    func `Fast path for whitespace trimming`() {
//        let string = "   hello world   "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Fast path with tab characters`() {
//        let string = "\t\thello\t\t"
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Fast path with newline characters`() {
//        let string = "\n\nhello\n\n"
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Fast path with carriage return characters`() {
//        let string = "\r\rhello\r\r"
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello")
//    }
//
//    @Test
//    func `Fast path with mixed whitespace`() {
//        let string = " \t\n\rhello world\r\n\t "
//        let substring = string[...]
//        let result = substring.trimming(.whitespaces)
//        #expect(result == "hello world")
//    }
//}
//
//@Suite
//struct `Substring - Generic path for custom character sets` {
//
//    @Test
//    func `Generic path with single character`() {
//        let string = "xxxhello worldxxx"
//        let substring = string[...]
//        let result = substring.trimming(["x"])
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Generic path with multiple characters`() {
//        let string = "xyzHello Worldzyx"
//        let substring = string[...]
//        let result = substring.trimming(["x", "y", "z"])
//        #expect(result == "Hello World")
//    }
//
//    @Test
//    func `Generic path preserves internal occurrences`() {
//        let string = "aaahello a worldaaa"
//        let substring = string[...]
//        let result = substring.trimming(["a"])
//        #expect(result == "hello a world")
//    }
//
//    @Test
//    func `Generic path with unicode characters`() {
//        let string = "😀😀hello world😀😀"
//        let substring = string[...]
//        let result = substring.trimming(["😀"])
//        #expect(result == "hello world")
//    }
//
//    @Test
//    func `Generic path with punctuation`() {
//        let string = "!!!???hello world???!!!"
//        let substring = string[...]
//        let result = substring.trimming(["!", "?"])
//        #expect(result == "hello world")
//    }
//}
