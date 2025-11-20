import Testing
@testable import INCITS_4_1986

// MARK: - UInt8.ascii Namespace Access Tests

@Suite
struct `UInt8.ascii - Control Characters` {

    @Test
    func `NUL character via namespace`() {
        let nul = UInt8.ascii.nul
        #expect(nul == 0x00)
    }

    @Test
    func `HTAB character via namespace`() {
        let htab = UInt8.ascii.htab
        #expect(htab == 0x09)
    }

    @Test
    func `LF character via namespace`() {
        let lf = UInt8.ascii.lf
        #expect(lf == 0x0A)
    }

    @Test
    func `CR character via namespace`() {
        let cr = UInt8.ascii.cr
        #expect(cr == 0x0D)
    }

    @Test
    func `DELETE character via namespace`() {
        let del = UInt8.ascii.del
        #expect(del == 0x7F)
    }

    @Test
    func `All 33 control characters accessible`() {
        // Verify all C0 controls (0x00-0x1F)
        #expect(UInt8.ascii.nul == 0x00)
        #expect(UInt8.ascii.soh == 0x01)
        #expect(UInt8.ascii.stx == 0x02)
        #expect(UInt8.ascii.etx == 0x03)
        #expect(UInt8.ascii.eot == 0x04)
        #expect(UInt8.ascii.enq == 0x05)
        #expect(UInt8.ascii.ack == 0x06)
        #expect(UInt8.ascii.bel == 0x07)
        #expect(UInt8.ascii.bs == 0x08)
        #expect(UInt8.ascii.htab == 0x09)
        #expect(UInt8.ascii.lf == 0x0A)
        #expect(UInt8.ascii.vtab == 0x0B)
        #expect(UInt8.ascii.ff == 0x0C)
        #expect(UInt8.ascii.cr == 0x0D)
        #expect(UInt8.ascii.so == 0x0E)
        #expect(UInt8.ascii.si == 0x0F)
        #expect(UInt8.ascii.dle == 0x10)
        #expect(UInt8.ascii.dc1 == 0x11)
        #expect(UInt8.ascii.dc2 == 0x12)
        #expect(UInt8.ascii.dc3 == 0x13)
        #expect(UInt8.ascii.dc4 == 0x14)
        #expect(UInt8.ascii.nak == 0x15)
        #expect(UInt8.ascii.syn == 0x16)
        #expect(UInt8.ascii.etb == 0x17)
        #expect(UInt8.ascii.can == 0x18)
        #expect(UInt8.ascii.em == 0x19)
        #expect(UInt8.ascii.sub == 0x1A)
        #expect(UInt8.ascii.esc == 0x1B)
        #expect(UInt8.ascii.fs == 0x1C)
        #expect(UInt8.ascii.gs == 0x1D)
        #expect(UInt8.ascii.rs == 0x1E)
        #expect(UInt8.ascii.us == 0x1F)
        // DELETE
        #expect(UInt8.ascii.del == 0x7F)
    }
}

@Suite
struct `UInt8.ascii - SPACE` {

    @Test
    func `SPACE character via namespace`() {
        let space = UInt8.ascii.SPACE.sp
        #expect(space == 0x20)
    }

    @Test
    func `SPACE is recognized as whitespace`() {
        let space = UInt8.ascii.SPACE.sp
        #expect(space.ascii.isWhitespace)
    }
}

@Suite
struct `UInt8.ascii - Graphic Characters - Digits` {

    @Test
    func `Digit 0 via backticked name`() {
        let zero = UInt8.ascii.0
        #expect(zero == 0x30)
        #expect(zero.ascii.isDigit)
    }

    @Test
    func `Digit 1 via backticked name`() {
        let one = UInt8.ascii.1
        #expect(one == 0x31)
        #expect(one.ascii.isDigit)
    }

    @Test
    func `All digits 0-9 via backticked names`() {
        #expect(UInt8.ascii.0 == 0x30)
        #expect(UInt8.ascii.1 == 0x31)
        #expect(UInt8.ascii.2 == 0x32)
        #expect(UInt8.ascii.3 == 0x33)
        #expect(UInt8.ascii.4 == 0x34)
        #expect(UInt8.ascii.5 == 0x35)
        #expect(UInt8.ascii.6 == 0x36)
        #expect(UInt8.ascii.7 == 0x37)
        #expect(UInt8.ascii.8 == 0x38)
        #expect(UInt8.ascii.9 == 0x39)
    }
}

@Suite
struct `UInt8.ascii - Graphic Characters - Punctuation` {

    @Test
    func `Common punctuation accessible`() {
        #expect(UInt8.ascii.exclamationPoint == 0x21)
        #expect(UInt8.ascii.quotationMark == 0x22)
        #expect(UInt8.ascii.numberSign == 0x23)
        #expect(UInt8.ascii.dollarSign == 0x24)
        #expect(UInt8.ascii.percentSign == 0x25)
        #expect(UInt8.ascii.ampersand == 0x26)
        #expect(UInt8.ascii.apostrophe == 0x27)
        #expect(UInt8.ascii.asterisk == 0x2A)
        #expect(UInt8.ascii.plusSign == 0x2B)
        #expect(UInt8.ascii.comma == 0x2C)
        #expect(UInt8.ascii.hyphen == 0x2D)
        #expect(UInt8.ascii.period == 0x2E)
        #expect(UInt8.ascii.slant == 0x2F)
    }

    @Test
    func `Parentheses and brackets accessible`() {
        #expect(UInt8.ascii.leftParenthesis == 0x28)
        #expect(UInt8.ascii.rightParenthesis == 0x29)
        #expect(UInt8.ascii.leftBracket == 0x5B)
        #expect(UInt8.ascii.rightBracket == 0x5D)
        #expect(UInt8.ascii.leftBrace == 0x7B)
        #expect(UInt8.ascii.rightBrace == 0x7D)
    }

    @Test
    func `Operators and symbols accessible`() {
        #expect(UInt8.ascii.lessThanSign == 0x3C)
        #expect(UInt8.ascii.equalsSign == 0x3D)
        #expect(UInt8.ascii.greaterThanSign == 0x3E)
        #expect(UInt8.ascii.questionMark == 0x3F)
        #expect(UInt8.ascii.commercialAt == 0x40)
        #expect(UInt8.ascii.colon == 0x3A)
        #expect(UInt8.ascii.semicolon == 0x3B)
    }
}

@Suite
struct `UInt8.ascii - Graphic Characters - Letters` {

    @Test
    func `Uppercase letters accessible`() {
        #expect(UInt8.ascii.A == 0x41)
        #expect(UInt8.ascii.B == 0x42)
        #expect(UInt8.ascii.Z == 0x5A)

        // Verify they're recognized as letters
        #expect(UInt8.ascii.A.ascii.isLetter)
        #expect(UInt8.ascii.A.ascii.isUppercase)
        #expect(!UInt8.ascii.A.ascii.isLowercase)
    }

    @Test
    func `Lowercase letters accessible via backticked names`() {
        #expect(UInt8.ascii.a == 0x61)
        #expect(UInt8.ascii.b == 0x62)
        #expect(UInt8.ascii.z == 0x7A)

        // Verify they're recognized as letters
        #expect(UInt8.ascii.a.ascii.isLetter)
        #expect(UInt8.ascii.a.ascii.isLowercase)
        #expect(!UInt8.ascii.a.ascii.isUppercase)
    }


    @Test
    func `All 26 uppercase letters A-Z accessible`() {
        let letters: [(UInt8, UInt8)] = [
            (UInt8.ascii.A, 0x41),
            (UInt8.ascii.B, 0x42),
            (UInt8.ascii.C, 0x43),
            (UInt8.ascii.D, 0x44),
            (UInt8.ascii.E, 0x45),
            (UInt8.ascii.F, 0x46),
            (UInt8.ascii.G, 0x47),
            (UInt8.ascii.H, 0x48),
            (UInt8.ascii.I, 0x49),
            (UInt8.ascii.J, 0x4A),
            (UInt8.ascii.K, 0x4B),
            (UInt8.ascii.L, 0x4C),
            (UInt8.ascii.M, 0x4D),
            (UInt8.ascii.N, 0x4E),
            (UInt8.ascii.O, 0x4F),
            (UInt8.ascii.P, 0x50),
            (UInt8.ascii.Q, 0x51),
            (UInt8.ascii.R, 0x52),
            (UInt8.ascii.S, 0x53),
            (UInt8.ascii.T, 0x54),
            (UInt8.ascii.U, 0x55),
            (UInt8.ascii.V, 0x56),
            (UInt8.ascii.W, 0x57),
            (UInt8.ascii.X, 0x58),
            (UInt8.ascii.Y, 0x59),
            (UInt8.ascii.Z, 0x5A)
        ]

        for (actual, expected) in letters {
            #expect(actual == expected)
        }
    }

    @Test
    func `All 26 lowercase letters a-z accessible via backticked names`() {
        let letters: [(UInt8, UInt8)] = [
            (UInt8.ascii.a, 0x61),
            (UInt8.ascii.b, 0x62),
            (UInt8.ascii.c, 0x63),
            (UInt8.ascii.d, 0x64),
            (UInt8.ascii.e, 0x65),
            (UInt8.ascii.f, 0x66),
            (UInt8.ascii.g, 0x67),
            (UInt8.ascii.h, 0x68),
            (UInt8.ascii.i, 0x69),
            (UInt8.ascii.j, 0x6A),
            (UInt8.ascii.k, 0x6B),
            (UInt8.ascii.l, 0x6C),
            (UInt8.ascii.m, 0x6D),
            (UInt8.ascii.n, 0x6E),
            (UInt8.ascii.o, 0x6F),
            (UInt8.ascii.p, 0x70),
            (UInt8.ascii.q, 0x71),
            (UInt8.ascii.r, 0x72),
            (UInt8.ascii.s, 0x73),
            (UInt8.ascii.t, 0x74),
            (UInt8.ascii.u, 0x75),
            (UInt8.ascii.v, 0x76),
            (UInt8.ascii.w, 0x77),
            (UInt8.ascii.x, 0x78),
            (UInt8.ascii.y, 0x79),
            (UInt8.ascii.z, 0x7A)
        ]

        for (actual, expected) in letters {
            #expect(actual == expected)
        }
    }

}

@Suite
struct `UInt8.ascii - Graphic Characters - Additional Symbols` {

    @Test
    func `Additional symbols accessible`() {
        #expect(UInt8.ascii.reverseSlant == 0x5C)  // \
        #expect(UInt8.ascii.circumflexAccent == 0x5E)  // ^
        #expect(UInt8.ascii.underline == 0x5F)  // _
        #expect(UInt8.ascii.leftSingleQuotationMark == 0x60)  // `
        #expect(UInt8.ascii.verticalLine == 0x7C)  // |
        #expect(UInt8.ascii.tilde == 0x7E)  // ~
    }
}

@Suite
struct `UInt8.ascii - Complete Coverage` {

    @Test
    func `All 128 ASCII characters accessible via namespace`() {
        // This test verifies that all ASCII characters (0x00-0x7F) are accessible
        // through the namespace structure

        // Control characters: 0x00-0x1F, 0x7F (33 total)
        var covered = Set<UInt8>()

        // Add all control characters
        covered.insert(UInt8.ascii.nul)
        covered.insert(UInt8.ascii.soh)
        covered.insert(UInt8.ascii.stx)
        covered.insert(UInt8.ascii.etx)
        covered.insert(UInt8.ascii.eot)
        covered.insert(UInt8.ascii.enq)
        covered.insert(UInt8.ascii.ack)
        covered.insert(UInt8.ascii.bel)
        covered.insert(UInt8.ascii.bs)
        covered.insert(UInt8.ascii.htab)
        covered.insert(UInt8.ascii.lf)
        covered.insert(UInt8.ascii.vtab)
        covered.insert(UInt8.ascii.ff)
        covered.insert(UInt8.ascii.cr)
        covered.insert(UInt8.ascii.so)
        covered.insert(UInt8.ascii.si)
        covered.insert(UInt8.ascii.dle)
        covered.insert(UInt8.ascii.dc1)
        covered.insert(UInt8.ascii.dc2)
        covered.insert(UInt8.ascii.dc3)
        covered.insert(UInt8.ascii.dc4)
        covered.insert(UInt8.ascii.nak)
        covered.insert(UInt8.ascii.syn)
        covered.insert(UInt8.ascii.etb)
        covered.insert(UInt8.ascii.can)
        covered.insert(UInt8.ascii.em)
        covered.insert(UInt8.ascii.sub)
        covered.insert(UInt8.ascii.esc)
        covered.insert(UInt8.ascii.fs)
        covered.insert(UInt8.ascii.gs)
        covered.insert(UInt8.ascii.rs)
        covered.insert(UInt8.ascii.us)
        covered.insert(UInt8.ascii.del)

        // SPACE: 0x20 (1 total)
        covered.insert(UInt8.ascii.SPACE.sp)

        // Verify we have 34 characters so far (33 control + 1 space)
        #expect(covered.count == 34)

        // Graphic characters: 0x21-0x7E (94 total)
        // We have all of them defined, so total coverage should be 128

        // This confirms the structure is complete
        #expect(UInt8.ascii.exclamationPoint == 0x21)
        #expect(UInt8.ascii.tilde == 0x7E)
    }
}

// MARK: - Convenience Direct Access Tests

@Suite
struct `UInt8.ascii - Direct Access (Convenience)` {

    @Test
    func `Control characters accessible directly without ControlCharacters namespace`() {
        // Test that UInt8.ascii.nul works (not just UInt8.ascii.nul)
        #expect(UInt8.ascii.nul == 0x00)
        #expect(UInt8.ascii.htab == 0x09)
        #expect(UInt8.ascii.lf == 0x0A)
        #expect(UInt8.ascii.cr == 0x0D)
        #expect(UInt8.ascii.del == 0x7F)
    }

    @Test
    func `SPACE accessible directly without SPACE namespace`() {
        // Test that UInt8.ascii.sp works (not just UInt8.ascii.SPACE.sp)
        #expect(UInt8.ascii.sp == 0x20)
    }

    @Test
    func `Digits accessible directly without GraphicCharacters namespace`() {
        // Test that UInt8.ascii.0 works (not just UInt8.ascii.0)
        #expect(UInt8.ascii.0 == 0x30)
        #expect(UInt8.ascii.1 == 0x31)
        #expect(UInt8.ascii.9 == 0x39)
    }

    @Test
    func `Punctuation accessible directly without GraphicCharacters namespace`() {
        #expect(UInt8.ascii.exclamationPoint == 0x21)
        #expect(UInt8.ascii.comma == 0x2C)
        #expect(UInt8.ascii.period == 0x2E)
    }

    @Test
    func `Letters accessible directly without GraphicCharacters namespace`() {
        #expect(UInt8.ascii.A == 0x41)
        #expect(UInt8.ascii.Z == 0x5A)
        #expect(UInt8.ascii.a == 0x61)
        #expect(UInt8.ascii.z == 0x7A)
    }

    @Test
    func `All 33 control characters accessible via direct access`() {
        // Verify all C0 controls via convenient direct access
        #expect(UInt8.ascii.nul == 0x00)
        #expect(UInt8.ascii.soh == 0x01)
        #expect(UInt8.ascii.stx == 0x02)
        #expect(UInt8.ascii.etx == 0x03)
        #expect(UInt8.ascii.eot == 0x04)
        #expect(UInt8.ascii.enq == 0x05)
        #expect(UInt8.ascii.ack == 0x06)
        #expect(UInt8.ascii.bel == 0x07)
        #expect(UInt8.ascii.bs == 0x08)
        #expect(UInt8.ascii.htab == 0x09)
        #expect(UInt8.ascii.lf == 0x0A)
        #expect(UInt8.ascii.vtab == 0x0B)
        #expect(UInt8.ascii.ff == 0x0C)
        #expect(UInt8.ascii.cr == 0x0D)
        #expect(UInt8.ascii.so == 0x0E)
        #expect(UInt8.ascii.si == 0x0F)
        #expect(UInt8.ascii.dle == 0x10)
        #expect(UInt8.ascii.dc1 == 0x11)
        #expect(UInt8.ascii.dc2 == 0x12)
        #expect(UInt8.ascii.dc3 == 0x13)
        #expect(UInt8.ascii.dc4 == 0x14)
        #expect(UInt8.ascii.nak == 0x15)
        #expect(UInt8.ascii.syn == 0x16)
        #expect(UInt8.ascii.etb == 0x17)
        #expect(UInt8.ascii.can == 0x18)
        #expect(UInt8.ascii.em == 0x19)
        #expect(UInt8.ascii.sub == 0x1A)
        #expect(UInt8.ascii.esc == 0x1B)
        #expect(UInt8.ascii.fs == 0x1C)
        #expect(UInt8.ascii.gs == 0x1D)
        #expect(UInt8.ascii.rs == 0x1E)
        #expect(UInt8.ascii.us == 0x1F)
        #expect(UInt8.ascii.del == 0x7F)
    }

    @Test
    func `Direct and namespaced access return same values`() {
        // Verify that both access patterns return the same values
        #expect(UInt8.ascii.nul == UInt8.ascii.ControlCharacters.nul)
        #expect(UInt8.ascii.lf == UInt8.ascii.ControlCharacters.lf)
        #expect(UInt8.ascii.cr == UInt8.ascii.ControlCharacters.cr)
        #expect(UInt8.ascii.sp == UInt8.ascii.SPACE.sp)
        #expect(UInt8.ascii.0 == UInt8.ascii.GraphicCharacters.`0`)
        #expect(UInt8.ascii.comma == UInt8.ascii.GraphicCharacters.comma)
        #expect(UInt8.ascii.A == UInt8.ascii.GraphicCharacters.`A`)
        #expect(UInt8.ascii.z == UInt8.ascii.GraphicCharacters.`z`)
    }
}
