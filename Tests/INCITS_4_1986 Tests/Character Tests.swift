//import Testing
//@testable import INCITS_4_1986
//
//@Suite
//struct `Character - ASCII Whitespace` {
//
//    @Test(arguments: [" ", "\t", "\n", "\r"])
//    func `Whitespace characters are recognized`(char: Character) {
//        #expect(char.ascii.isWhitespace)
//    }
//
//    @Test(arguments: ["a", "Z", "0", "!", "é", "😀"])
//    func `Non-whitespace characters are not recognized`(char: Character) {
//        #expect(!char.ascii.isWhitespace)
//    }
//
//    @Test
//    func `All ASCII whitespace characters`() {
//        let whitespace: [Character] = [
//            " ",   // Space (0x20)
//            "\t",  // Tab (0x09)
//            "\n",  // Line Feed (0x0A)
//            "\r"   // Carriage Return (0x0D)
//        ]
//        for char in whitespace {
//            #expect(char.ascii.isWhitespace)
//        }
//    }
//}
//
//@Suite
//struct `Character - ASCII Digits` {
//
//    @Test(arguments: Array("0123456789"))
//    func `Digit characters are recognized`(char: Character) {
//        #expect(char.isASCIIDigit)
//    }
//
//    @Test(arguments: ["a", "Z", " ", "!", "٠", "۰"])
//    func `Non-digit characters are not recognized`(char: Character) {
//        #expect(!char.isASCIIDigit)
//    }
//
//    @Test
//    func `All ASCII digits 0-9`() {
//        for ascii in UInt8(ascii: "0")...UInt8(ascii: "9") {
//            let char = Character(UnicodeScalar(ascii))
//            #expect(char.isASCIIDigit, "Character '\(char)' should be a digit")
//        }
//    }
//}
//
//@Suite
//struct `Character - ASCII Letters` {
//
//    @Test
//    func `Uppercase letters A-Z are recognized`() {
//        for ascii in UInt8(ascii: "A")...UInt8(ascii: "Z") {
//            let char = Character(UnicodeScalar(ascii))
//            #expect(char.isASCIILetter, "Character '\(char)' should be a letter")
//        }
//    }
//
//    @Test
//    func `Lowercase letters a-z are recognized`() {
//        for ascii in UInt8.init(ascii: "a")...UInt8(ascii: "z") {
//            let char = Character(UnicodeScalar(ascii))
//            #expect(char.isASCIILetter, "Character '\(char)' should be a letter")
//        }
//    }
//
//    @Test(arguments: ["0", "9", " ", "!", "@", "é", "ñ"])
//    func `Non-letter characters are not recognized`(char: Character) {
//        #expect(!char.isASCIILetter)
//    }
//}
//
//@Suite
//struct `Character - ASCII Alphanumeric` {
//
//    @Test
//    func `Letters and digits are alphanumeric`() {
//        let alphanumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
//        for char in alphanumeric {
//            #expect(char.isASCIIAlphanumeric, "Character '\(char)' should be alphanumeric")
//        }
//    }
//
//    @Test(arguments: [" ", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "="])
//    func `Special characters are not alphanumeric`(char: Character) {
//        #expect(!char.isASCIIAlphanumeric)
//    }
//
//    @Test
//    func `Unicode letters are not ASCII alphanumeric`() {
//        let unicodeChars: [Character] = ["é", "ñ", "ü", "ø", "α", "β", "中", "文"]
//        for char in unicodeChars {
//            #expect(!char.isASCIIAlphanumeric)
//        }
//    }
//}
//
//@Suite
//struct `Character - ASCII Hex Digits` {
//
//    @Test
//    func `Hex digits 0-9 are recognized`() {
//        for char in "0123456789" {
//            #expect(char.isASCIIHexDigit)
//        }
//    }
//
//    @Test
//    func `Hex digits A-F uppercase are recognized`() {
//        for char in "ABCDEF" {
//            #expect(char.isASCIIHexDigit)
//        }
//    }
//
//    @Test
//    func `Hex digits a-f lowercase are recognized`() {
//        for char in "abcdef" {
//            #expect(char.isASCIIHexDigit)
//        }
//    }
//
//    @Test(arguments: ["G", "g", "Z", "z", " ", "!", "@"])
//    func `Non-hex characters are not recognized`(char: Character) {
//        #expect(!char.isASCIIHexDigit)
//    }
//
//    @Test
//    func `All valid hex characters`() {
//        let hexChars = "0123456789ABCDEFabcdef"
//        for char in hexChars {
//            #expect(char.isASCIIHexDigit, "Character '\(char)' should be a hex digit")
//        }
//    }
//}
//
//@Suite
//struct `Character - ASCII Case` {
//
//    @Test
//    func `Uppercase letters A-Z are recognized`() {
//        for ascii in UInt8(ascii: "A")...UInt8(ascii: "Z") {
//            let char = Character(UnicodeScalar(ascii))
//            #expect(char.isASCIIUppercase, "Character '\(char)' should be uppercase")
//            #expect(!char.isASCIILowercase, "Character '\(char)' should not be lowercase")
//        }
//    }
//
//    @Test
//    func `Lowercase letters a-z are recognized`() {
//        for ascii in UInt8(ascii: "a")...UInt8(ascii: "z") {
//            let char = Character(UnicodeScalar(ascii))
//            #expect(char.isASCIILowercase, "Character '\(char)' should be lowercase")
//            #expect(!char.isASCIIUppercase, "Character '\(char)' should not be uppercase")
//        }
//    }
//
//    @Test(arguments: ["0", "9", " ", "!", "@", "#"])
//    func `Non-letter characters are neither uppercase nor lowercase`(char: Character) {
//        #expect(!char.isASCIIUppercase)
//        #expect(!char.isASCIILowercase)
//    }
//
//    @Test
//    func `Unicode uppercase letters are not ASCII uppercase`() {
//        let unicodeUppercase: [Character] = ["É", "Ñ", "Ü", "Ø", "Α", "Β"]
//        for char in unicodeUppercase {
//            #expect(!char.isASCIIUppercase)
//        }
//    }
//}
