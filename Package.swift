// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyTopology",
    products: [
        .library(
            name: "SwiftyTopology",
            targets: ["SwiftyTopology"]),
    ],
    dependencies: [
        .package(url: "https://github.com/taketo1024/SwiftyMath.git", .exact("1.0.18")),
        .package(url: "https://github.com/taketo1024/SwiftyMath-homology.git", .exact("1.0.13")),
    ],
    targets: [
        .target(
            name: "SwiftyTopology",
            dependencies: ["SwiftyMath", "SwiftyHomology"],
			path: "Sources/SwiftyTopology"),
        .testTarget(
            name: "SwiftyTopologyTests",
            dependencies: ["SwiftyTopology"]),
        .target(
            name: "SwiftyTopology-Sample",
            dependencies: ["SwiftyMath", "SwiftyHomology", "SwiftyTopology"],
			path: "Sources/Sample"),
    ]
)
