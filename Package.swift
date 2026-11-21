// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClockStudio",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "ClockStudio", targets: ["ClockStudio"])
    ],
    targets: [
        .executableTarget(name: "ClockStudio")
    ]
)
