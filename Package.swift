// swift-tools-version: 6.0

import PackageDescription

// INCITS 4-1986 (R2022): Coded Character Sets - 7-Bit American Standard Code for Information Interchange
//
// Implements US-ASCII character set standard
// - Current designation: INCITS 4-1986 (Reaffirmed 2022)
// - Historical names: ANSI X3.4-1986, ANSI X3.4-1968, ASA X3.4-1963
// - IANA charset: US-ASCII
//
// This is a pure Swift implementation with no Foundation dependencies,
// suitable for Swift Embedded and constrained environments.

let package = Package(
    name: "swift-incits-4-1986",
    products: [
        .library(
            name: "INCITS_4_1986",
            targets: ["INCITS_4_1986"]
        )
    ],
    dependencies: [
        .package(name: "swift-standards", path: "../swift-standards")
    ],
    targets: [
        .target(
            name: "INCITS_4_1986",
            dependencies: [
                .product(name: "Standards", package: "swift-standards")
            ]
        ),
        .testTarget(
            name: "INCITS_4_1986_Tests",
            dependencies: ["INCITS_4_1986"]
        )
    ]
)

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(
        .enableUpcomingFeature("MemberImportVisibility")
    )
    target.swiftSettings = settings
}
