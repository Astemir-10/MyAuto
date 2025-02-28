// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CombineCoreData",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "CombineCoreData",
            targets: ["CombineCoreData"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CombineCoreData",
            dependencies: [
            ]),
    ]
)
