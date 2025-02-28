// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AppWidgets",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppWidgets",
            targets: ["AppWidgets"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "AppMap", path: "../../AppMap"),
        
    ],
    targets: [
        .target(
            name: "AppWidgets",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "AppMap"
            ]),
    ]
)
