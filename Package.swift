// swift-tools-version:5.3

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
        .package(url: "https://github.com/grigorye/BlinkKit", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.5"),
        .package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.10.1"),
    ],
    targets: [
        .target(
            name: "BlinkTool",
            dependencies: [
                "BlinkKit",
                .product(name: "OpenCombine", package: "OpenCombine", condition: .when(platforms: [.linux])),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "BlinkToolTests",
            dependencies: ["BlinkTool"]
        ),
    ]
)
