// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "CarScanner", path: "../../CarScanner"),
        
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData",
                "CarScanner"
            ]),
    ]
)
