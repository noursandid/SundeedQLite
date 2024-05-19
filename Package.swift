// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SundeedQLite",
    platforms: [
        .iOS(.v13)
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
            path: "Library"
        )
    ]
)
