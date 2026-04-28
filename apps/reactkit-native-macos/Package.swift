// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ReactKit",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ReactKit", targets: ["reactkit"])
    ],
    targets: [
        .executableTarget(
            name: "reactkit"
        )
    ]
)
