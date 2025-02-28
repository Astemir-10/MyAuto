// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "News",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "News",
            targets: ["News"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "CarInfo", path: "../../CarInfo"),
        
    ],
    targets: [
        .target(
            name: "News",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData",
                "CarInfo"
            ]),
    ]
)
