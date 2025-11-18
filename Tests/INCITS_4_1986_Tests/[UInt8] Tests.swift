import Testing
@testable import INCITS_4_1986

// MARK: - ASCII Control Character Constants

@Suite
struct `UInt8 - ASCII control character constants` {

    @Test
    func `NULL constant is correct`() {
        #expect(UInt8.nul == 0x00)
    }

    @Test
    func `HORIZONTAL TAB constant is correct`() {
        #expect(UInt8.htab == 0x09)
    }

    @Test
    func `LINE FEED constant is correct`() {
        #expect(UInt8.lf == 0x0A)
    }

    @Test
    func `CARRIAGE RETURN constant is correct`() {
        #expect(UInt8.cr == 0x0D)
    }

    @Test
    func `SPACE constant is correct`() {
        #expect(UInt8.sp == 0x20)
    }

    @Test
    func `DELETE constant is correct`() {
        #expect(UInt8.del == 0x7F)
    }
}

// MARK: - ASCII Control and Visible Character Classification

@Suite
struct `UInt8 - isASCIIControl` {

    @Test
    func `All C0 control characters (0x00-0x1F) are recognized`() {
        for byte: UInt8 in 0x00...0x1F {
            #expect(byte.isASCIIControl, "Byte 0x\(String(byte, radix: 16, uppercase: true)) should be a control character")
        }
    }

    @Test
    func `DELETE (0x7F) is a control character`() {
        #expect(UInt8(0x7F).isASCIIControl)
        #expect(UInt8.del.isASCIIControl)
    }

    @Test
    func `Visible characters are not control characters`() {
        for byte: UInt8 in 0x21...0x7E {
            #expect(!byte.isASCIIControl, "Byte 0x\(String(byte, radix: 16, uppercase: true)) should not be a control character")
        }
    }

    @Test
    func `SPACE (0x20) is not a control character`() {
        #expect(!UInt8(0x20).isASCIIControl)
        #expect(!UInt8.sp.isASCIIControl)
    }

    @Test
    func `Common control characters are recognized`() {
        #expect(UInt8.nul.isASCIIControl)   // NULL
        #expect(UInt8.htab.isASCIIControl)  // TAB
        #expect(UInt8.lf.isASCIIControl)    // LINE FEED
        #expect(UInt8.cr.isASCIIControl)    // CARRIAGE RETURN
    }
}

@Suite
struct `UInt8 - isASCIIVisible` {

    @Test
    func `All visible characters (0x21-0x7E) are recognized`() {
        for byte: UInt8 in 0x21...0x7E {
            #expect(byte.isASCIIVisible, "Byte 0x\(String(byte, radix: 16, uppercase: true)) ('\(Character(UnicodeScalar(byte)))') should be visible")
        }
    }

    @Test
    func `Control characters are not visible`() {
        for byte: UInt8 in 0x00...0x1F {
            #expect(!byte.isASCIIVisible, "Byte 0x\(String(byte, radix: 16, uppercase: true)) should not be visible")
        }
    }

    @Test
    func `SPACE (0x20) is not visible`() {
        #expect(!UInt8(0x20).isASCIIVisible)
        #expect(!UInt8.sp.isASCIIVisible)
    }

    @Test
    func `DELETE (0x7F) is not visible`() {
        #expect(!UInt8(0x7F).isASCIIVisible)
        #expect(!UInt8.del.isASCIIVisible)
    }

    @Test
    func `Common visible characters are recognized`() {
        #expect(UInt8(ascii: "!").isASCIIVisible)  // 0x21
        #expect(UInt8(ascii: "0").isASCIIVisible)  // digit
        #expect(UInt8(ascii: "A").isASCIIVisible)  // uppercase
        #expect(UInt8(ascii: "a").isASCIIVisible)  // lowercase
        #expect(UInt8(ascii: "~").isASCIIVisible)  // 0x7E
    }

    @Test
    func `Visible implies not control`() {
        for byte: UInt8 in 0...255 {
            if byte.isASCIIVisible {
                #expect(!byte.isASCIIControl)
            }
        }
    }
}

// MARK: - Byte Sequence Constants

@Suite
struct `[UInt8] - Line ending constants` {

    @Test
    func `CRLF constant is correct`() {
        #expect([UInt8].crlf == [0x0D, 0x0A])
        #expect([UInt8].crlf == [UInt8.cr, UInt8.lf])
    }

    @Test
    func `LF constant is correct`() {
        #expect([UInt8].lf == [0x0A])
        #expect([UInt8].lf == [UInt8.lf])
    }

    @Test
    func `CR constant is correct`() {
        #expect([UInt8].cr == [0x0D])
        #expect([UInt8].cr == [UInt8.cr])
    }

    @Test
    func `Line ending constants are distinct`() {
        #expect([UInt8].crlf != [UInt8].lf)
        #expect([UInt8].crlf != [UInt8].cr)
        #expect([UInt8].lf != [UInt8].cr)
    }

    @Test
    func `CRLF can be constructed from individual constants`() {
        let crlf = [UInt8.cr, UInt8.lf]
        #expect(crlf == [UInt8].crlf)
    }
}
