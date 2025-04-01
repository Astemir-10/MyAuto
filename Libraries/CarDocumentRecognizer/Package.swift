// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CarDocumentRecognizer",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "CarDocumentRecognizer",
            targets: ["CarDocumentRecognizer"]),
    ],
    dependencies: [
        .package(name: "AnyFormatter", path: "../../AnyFormatter"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(url: "https://github.com/SwiftyTesseract/SwiftyTesseract.git", branch: "develop")
    ],
    targets: [
        .target(
            name: "CarDocumentRecognizer",
            dependencies: [
                "AnyFormatter",
                "Extensions",
                .product(name: "SwiftyTesseract", package: "SwiftyTesseract")
            ],
            resources: [.process("Resources"), .copy("tessdata")]),
    ]
)
