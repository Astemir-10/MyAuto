// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "ReceiptReader",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ReceiptReader",
            targets: ["ReceiptReader"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ReceiptReader",
            dependencies: [
            ]),
    ]
)
