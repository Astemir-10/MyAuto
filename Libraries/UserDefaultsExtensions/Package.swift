// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "UserDefaultsExtensions",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "UserDefaultsExtensions",
            targets: ["UserDefaultsExtensions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "UserDefaultsExtensions",
            dependencies: [
            ]),
    ]
)
