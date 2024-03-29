// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Utility",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Utility",
            targets: ["Utility"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "Utility",
            dependencies: []
        ),
        .testTarget(
            name: "UtilityTests",
            dependencies: ["Utility"]
        ),
    ]
)
