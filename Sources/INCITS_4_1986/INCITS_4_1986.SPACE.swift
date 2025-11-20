// INCITS_4_1986.SPACE.swift
// swift-incits-4-1986
//
// Section 4.2: SPACE (INCITS 4-1986)

extension INCITS_4_1986 {
    /// Section 4.2: SPACE (0x20)
    ///
    /// The character SPACE is both a graphic character and a control character.
    /// As a graphic character, it has a visual representation consisting of the absence
    /// of a graphic symbol. As a control character, it acts as a format effector that
    /// causes the active position to be advanced one character position.
    public enum SPACE {}
}

// MARK: - Authoritative SPACE Constants

extension INCITS_4_1986.SPACE {
    /// SPACE (0x20)
    ///
    /// Acronym: SP
    /// This character is interpreted both as a graphic character and as a control character.
    public static let sp: UInt8 = 0x20
}
