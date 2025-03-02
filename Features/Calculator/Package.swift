// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Calculator",
            targets: ["Calculator"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "AppMap", path: "../../AppMap"),
        .package(name: "AppWidgets", path: "../../AppWidgets"),
        
    ],
    targets: [
        .target(
            name: "Calculator",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData",
                "AppMap",
                "AppWidgets"
            ]),
    ]
)
