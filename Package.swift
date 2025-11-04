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
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0")
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
