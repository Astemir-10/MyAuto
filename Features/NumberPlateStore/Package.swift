// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "NumberPlateStore",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "NumberPlateStore",
            targets: ["NumberPlateStore"]),
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
            name: "NumberPlateStore",
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
