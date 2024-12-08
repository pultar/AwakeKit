// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "awake-kit",
    products: [
        .library(
            name: "AwakeKit",
            targets: ["AwakeKit"]),
    ],
    targets: [
        .target(
            name: "AwakeKit"),
        .testTarget(
            name: "AwakeKitTests",
            dependencies: ["AwakeKit"]
        ),
    ]
)
