// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWBarberPoleView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWBarberPoleView", targets: ["WWBarberPoleView"]),
    ],
    targets: [
        .target(name: "WWBarberPoleView", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
