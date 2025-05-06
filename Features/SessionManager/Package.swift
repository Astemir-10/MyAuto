// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "SessionManager",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SessionManager",
            targets: ["SessionManager"]),
    ],
    dependencies: [
        .package(name: "Networking", path: "../../Networking"),
        .package(name: "AppKeychain", path: "../../AppKeychain"),
    ],
    targets: [
        .target(
            name: "SessionManager",
            dependencies: [
                "Networking",
                "AppKeychain"
            ]),
    ]
)
