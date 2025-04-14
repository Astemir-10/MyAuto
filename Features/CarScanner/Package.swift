// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CarScanner",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "CarScanner",
            targets: ["CarScanner"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CarScannerCore", path: "../../CarScannerCore"),
        .package(name: "UserDefaultsExtensions", path: "../../UserDefaultsExtensions"),
        
        
    ],
    targets: [
        .target(
            name: "CarScanner",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CarScannerCore",
                "UserDefaultsExtensions"
            ]),
    ]
)
