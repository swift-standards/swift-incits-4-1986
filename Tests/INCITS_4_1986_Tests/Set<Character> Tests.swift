import Testing
@testable import INCITS_4_1986

@Suite
struct `Set<Character> - whitespaces` {

    @Test
    func `Whitespace set contains space`() {
        #expect(Set<Character>.whitespaces.contains(" "))
    }

    @Test
    func `Whitespace set contains tab`() {
        #expect(Set<Character>.whitespaces.contains("\t"))
    }

    @Test
    func `Whitespace set contains newline`() {
        #expect(Set<Character>.whitespaces.contains("\n"))
    }

    @Test
    func `Whitespace set contains carriage return`() {
        #expect(Set<Character>.whitespaces.contains("\r"))
    }

    @Test
    func `Whitespace set has exactly 4 characters`() {
        #expect(Set<Character>.whitespaces.count == 4)
    }

    @Test(arguments: ["a", "Z", "0", "!", "é", "😀", "@", "#"])
    func `Whitespace set does not contain non-whitespace`(char: Character) {
        #expect(!Set<Character>.whitespaces.contains(char))
    }

    @Test
    func `Whitespace set matches expected characters`() {
        let expected: Set<Character> = [" ", "\t", "\n", "\r"]
        #expect(Set<Character>.whitespaces == expected)
    }

    @Test
    func `All whitespace characters are ASCII`() {
        for char in Set<Character>.whitespaces {
            #expect(char.isASCII)
        }
    }

    @Test
    func `Whitespace characters match ASCII values`() {
        let whitespaceBytes: Set<UInt8> = [0x20, 0x09, 0x0A, 0x0D]
        for char in Set<Character>.whitespaces {
            if let ascii = char.asciiValue {
                #expect(whitespaceBytes.contains(ascii))
            }
        }
    }

    @Test
    func `Can use whitespaces in Set operations`() {
        let custom: Set<Character> = [" ", "\t", "x", "y"]
        let intersection = custom.intersection(.whitespaces)
        #expect(intersection == [" ", "\t"])
    }
}
