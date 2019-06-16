// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "NonStandard",
    products: [
        .library(
            name: "NonStandard",
            targets: ["NonStandard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NonStandard",
            dependencies: []),
        .testTarget(
            name: "NonStandardTests",
            dependencies: ["NonStandard"]),
    ]
)
