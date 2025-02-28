// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AnyFormatter",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AnyFormatter",
            targets: ["AnyFormatter"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AnyFormatter",
            dependencies: [
            ]),
    ]
)
