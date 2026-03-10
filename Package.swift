// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TerminalGrid",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "TerminalGrid",
            path: "Sources"
        )
    ]
)
