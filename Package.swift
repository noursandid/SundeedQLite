// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SundeedQLite",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SundeedQLite",
            targets: ["SundeedQLite"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SundeedQLite",
            path: "Library",
            sources: ["**/*.swift"]
        )
    ]
)
