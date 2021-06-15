// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyTopology",
    products: [
        .library(
            name: "SwmTopology",
            targets: ["SwmTopology"]
		),
    ],
    dependencies: [
        .package(
			url: "https://github.com/taketo1024/swm-core.git",
			from: "1.2.6"
//            path: "../swm-core/"
		),
        .package(
			url: "https://github.com/taketo1024/swm-homology.git",
			from: "1.3.0"
//            path: "../swm-homology/"
		),
    ],
    targets: [
        .target(
            name: "SwmTopology",
            dependencies: [
                .product(name: "SwmCore", package: "swm-core"),
                .product(name: "SwmHomology", package: "swm-homology"),
			]
		),
        .testTarget(
            name: "SwmTopologyTests",
            dependencies: ["SwmTopology"]
		),
    ]
)
