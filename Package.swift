// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WakeOnLan",
    products: [
        .library(
            name: "WakeOnLan",
            targets: ["WakeOnLan"]),
    ],
    targets: [
        .target(
            name: "WakeOnLan"),
        .testTarget(
            name: "WakeOnLanTests",
            dependencies: ["WakeOnLan"]
        ),
    ]
)
