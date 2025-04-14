// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "KnowledgeBook",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "KnowledgeBook",
            targets: ["KnowledgeBook"]),
    ],
    dependencies: [
        .package(name: "DesignKit", path: "../../DesignKit"),
        .package(name: "GlobalServiceLocator", path: "../../GlobalServiceLocator"),
        .package(name: "Extensions", path: "../../Extensions"),
        .package(name: "DesignTokens", path: "../../DesignTokens"),
        
    ],
    targets: [
        .target(
            name: "KnowledgeBook",
            dependencies: [
                "DesignKit",
                "GlobalServiceLocator",
                "Extensions",
                "DesignTokens",
            ]),
    ]
)
