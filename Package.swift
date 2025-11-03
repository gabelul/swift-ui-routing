// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIRouting",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "UIRouting",
            targets: ["UIRouting"]),
    ],
    dependencies: [
        // Zero dependencies - SwiftUI only
    ],
    targets: [
        .target(
            name: "UIRouting",
            dependencies: []
        ),
        .testTarget(
            name: "UIRoutingTests",
            dependencies: ["UIRouting"]
        )
    ]
)
