// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "LocationManager",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "LocationManager",
            targets: ["LocationManager"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "LocationManager",
            dependencies: [
            ]),
    ]
)
