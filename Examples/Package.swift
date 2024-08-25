// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFeature",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(name: "Navigator", path: ".."),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Navigator",
                "Feature1",
                "Feature2",
                "Feature3",
            ]),
        .target(
            name: "Feature1",
            dependencies: [
                "Navigator",
            ]),
        .target(
            name: "Feature2",
            dependencies: [
                "Navigator",
            ]),
        .target(
            name: "Feature3"),
    ]
)
