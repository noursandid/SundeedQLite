// swift-tools-version:5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SundeedQLite",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SundeedQLite",
            targets: ["SundeedQLite"]
        ),
    ],
    dependencies: [
        // Supports Swift 5.9 (509.x) through Swift 6.x (600.x/601.x)
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            "509.0.0"..<"602.0.0"
        ),
    ],
    targets: [
        // ─── Main Library (now includes macro annotations) ───
        .target(
            name: "SundeedQLite",
            dependencies: [
                "SundeedQLiteMacrosPlugin",
            ],
            path: "Library"
        ),

        // ─── Macro Compiler Plugin (build-time only, not linked into user binary) ───
        .macro(
            name: "SundeedQLiteMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/SundeedQLiteMacrosPlugin"
        ),

        // ─── Macro Expansion Tests ───
        .testTarget(
            name: "SundeedQLiteMacroTests",
            dependencies: [
                "SundeedQLiteMacrosPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "Tests/SundeedQLiteMacroTests"
        ),
    ]
)
