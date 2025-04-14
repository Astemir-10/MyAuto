// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CarScannerCore",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "CarScannerCore",
            targets: ["CarScannerCore"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CarScannerCore",
            dependencies: [
            ]),
    ]
)
