// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CLI",
    dependencies: [
        .package(
            url: "https://github.com/phlippieb/NoughtsAndCrossesGameEngine.git",
            from: "1.0.0")
    ],

    targets: [
        .target(
            name: "CLI",
            dependencies: [
                "GameEngine",
                ]),

        .testTarget(
            name: "CLITests",
            dependencies: ["CLI"]),
    ]
)
