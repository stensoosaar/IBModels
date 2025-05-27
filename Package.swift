// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IBModels",
	platforms: [
		.macOS(.v12), .iOS(.v15)
	],
    products: [
        .library(
            name: "TWS",
            targets: ["TWS"]),
    ],
    targets: [
        .target(
            name: "TWS",
			path: "Sources/TWS"
		),
        .testTarget(
            name: "TWSTests",
            dependencies: ["TWS"],
			path: "Sources/TWSTests"
        ),
    ]
)
