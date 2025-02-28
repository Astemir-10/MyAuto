// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
    ],
    dependencies: [
        .package(name: "DesignTokens", path: "../../DesignTokens")
    ],
    targets: [
        .target(
            name: "DesignKit",
            dependencies: [
                "DesignTokens"
            ]),
    ]
)
