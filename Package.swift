// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "historyprobe",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "historyprobe"
        ),
        .testTarget(
            name: "historyprobeTests",
            dependencies: ["historyprobe"])
    ]
)
