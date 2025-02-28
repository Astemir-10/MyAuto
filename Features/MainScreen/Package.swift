// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "MainScreen",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "MainScreen",
            targets: ["MainScreen"]),
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
            name: "MainScreen",
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
