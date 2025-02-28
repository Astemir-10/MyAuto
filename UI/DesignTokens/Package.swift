// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "DesignTokens",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DesignTokens",
            targets: ["DesignTokens"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DesignTokens",
            dependencies: [
            ]),
    ]
)
