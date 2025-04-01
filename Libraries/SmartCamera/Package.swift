// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "SmartCamera",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SmartCamera",
            targets: ["SmartCamera"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SmartCamera",
            dependencies: [
            ]),
    ]
)
