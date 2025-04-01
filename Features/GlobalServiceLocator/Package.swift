// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "GlobalServiceLocator",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "GlobalServiceLocator",
            targets: ["GlobalServiceLocator"]),
    ],
    dependencies: [
        .package(name: "Networking", path: "../../Networking"),
        .package(name: "AppServices", path: "../../AppServices"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "LocationManager", path: "../../LocationManager"),
        .package(name: "AppFileManager", path: "../../AppFileManager"),

    ],
    targets: [
        .target(
            name: "GlobalServiceLocator",
            dependencies: [
                "Networking",
                "AppServices",
                "CombineCoreData",
                "LocationManager",
                "AppFileManager"
            ]),
    ]
)
