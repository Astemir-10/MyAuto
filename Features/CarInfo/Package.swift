// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CarInfo",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "CarInfo",
            targets: ["CarInfo"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        
    ],
    targets: [
        .target(
            name: "CarInfo",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData"
            ]),
    ]
)
