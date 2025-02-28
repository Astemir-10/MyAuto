// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Architecture",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Architecture",
            targets: ["Architecture"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Architecture",
            dependencies: [
            ]),
    ]
)
