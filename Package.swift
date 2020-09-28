// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "BlinkTool",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/grigorye/BlinkKit", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.5"),
    ],
    targets: [
        .target(
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
