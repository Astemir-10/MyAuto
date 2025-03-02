// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Documents",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Documents",
            targets: ["Documents"]),
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
            name: "Documents",
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
