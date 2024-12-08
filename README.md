#  AwakeKit

A Wake-on-Lan library in Swift

## Usage

```swift
try sendMagicPacket(to: "c2:d4:ee:f4:cf:dd")
```

This command is equivalent to:

```swift
try sendMagicPacket(to: "c2:d4:ee:f4:cf:dd", broadcast: "255.255.255.255", port: 9, interfaceName: "en0")
```

## Addition of `AwakeKit` as a Dependency

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/pultar/AwakeKit.git", branch: "main"),
    ],
    targets: [
        .executableTarget(name: "<command-line-tool>", dependencies: [
            // other dependencies
            .product(name: "AwakeKit", package: "awake-kit"),
        ]),
        // other targets
    ]
)
```

## License
[MIT License](http://opensource.org/licenses/MIT)

## Author
Felix Pultar

## Credits
Jesper Lindberg [@lindbergjesper](http://twitter.com/lindbergjesper/)
