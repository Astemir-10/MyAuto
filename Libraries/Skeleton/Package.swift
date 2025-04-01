// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Skeleton",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Skeleton",
            targets: ["Skeleton"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0")
    ],
    targets: [
        .target(
            name: "Skeleton",
            dependencies: [
                .product(name: "SkeletonView", package: "SkeletonView")
            ]),
    ]
)
