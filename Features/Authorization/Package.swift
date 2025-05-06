// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Authorization",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Authorization",
            targets: ["Authorization"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        .package(name: "CombineCoreData", path: "../../CombineCoreData"),
        .package(name: "UserDefaultsExtensions", path: "../../UserDefaultsExtensions"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "6.2.4")
        
    ],
    targets: [
        .target(
            name: "Authorization",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
                "CombineCoreData",
                "UserDefaultsExtensions",
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
            ]),
    ]
)
