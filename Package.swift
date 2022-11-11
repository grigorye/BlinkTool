// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "BlinkTool",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "BlinkTool", targets: ["BlinkTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/grigorye/BlinkKit", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "BlinkTool",
            dependencies: [
                "BlinkKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "BlinkToolTests",
            dependencies: ["BlinkTool"]
        ),
    ]
)
