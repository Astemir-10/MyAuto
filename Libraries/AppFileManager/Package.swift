// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AppFileManager",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppFileManager",
            targets: ["AppFileManager"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppFileManager",
            dependencies: [
            ]),
    ]
)
