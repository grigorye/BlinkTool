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
        .package(url: "https://github.com/grigorye/GETracing", branch: "master"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.0.3"),
    ],
    targets: [
        .executableTarget(
            name: "BlinkTool",
            dependencies: [
                "BlinkKit",
                "GETracing",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            plugins: [
                "GenerateBundleVersion"
            ]
        ),
        .plugin(
            name: "GenerateBundleVersion",
            capability: .buildTool()
        ),
        .testTarget(
            name: "BlinkToolTests",
            dependencies: ["BlinkTool"]
        ),
    ]
)
