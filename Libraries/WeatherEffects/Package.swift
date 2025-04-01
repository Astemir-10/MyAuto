// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "WeatherEffects",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "WeatherEffects",
            targets: ["WeatherEffects"]),
    ],
    dependencies: [
        
    ],
    targets: [
        
        .target(
            name: "WeatherEffects",
            dependencies: [
            ],
            resources: [.process("Resources")])
    ]
)
