// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "CarInfo", path: "../../CarInfo"),
        .package(name: "AppKeychain", path: "../../AppKeychain"),
        .package(name: "UserDefaultsExtensions", path: "../../UserDefaultsExtensions"),
        
        
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData",
                "CarInfo",
                "AppKeychain",
                "UserDefaultsExtensions"
            ]),
    ]
)
