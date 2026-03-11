// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TerminalGrid",
    platforms: [.macOS(.v13)],
    targets: [
        .target(
            name: "TerminalGridLib",
            path: "Sources/TerminalGridLib"
        ),
        .executableTarget(
            name: "TerminalGrid",
            dependencies: ["TerminalGridLib"],
            path: "Sources/TerminalGrid"
        ),
        .testTarget(
            name: "TerminalGridTests",
            dependencies: ["TerminalGridLib"],
            path: "Tests/TerminalGridTests"
        )
    ]
)
