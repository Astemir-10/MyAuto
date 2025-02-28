// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AppServices",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppServices",
            targets: ["AppServices"]),
    ],
    dependencies: [
        .package(name: "Networking", path: "../../Networking"),
        .package(name: "Extensions", path: "../../Extensions")
    ],
    targets: [
        .target(
            name: "AppServices",
            dependencies: [
                "Networking",
                "Extensions"
            ]),
    ]
)
