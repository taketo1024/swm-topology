// swift-tools-version:5.1
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
        .package(url: "https://github.com/taketo1024/SwiftyMath.git", .branch("develop")),
        .package(url: "https://github.com/taketo1024/SwiftyMath-homology.git", .branch("develop")),
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
