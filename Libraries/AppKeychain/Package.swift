// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AppKeychain",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppKeychain",
            targets: ["AppKeychain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "AppKeychain",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ]),
    ]
)
