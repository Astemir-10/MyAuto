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
        .package(name: "SessionManager", path: "../../SessionManager"),
        .package(name: "Networking", path: "../../Networking"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "AppKeychain", path: "../../AppKeychain"),
    ],
    targets: [
        .target(
            name: "AppServices",
            dependencies: [
                "SessionManager",
                "Networking",
                "Extensions",
                "AppKeychain",
                "DesignTokens"
            ]),
    ]
)
