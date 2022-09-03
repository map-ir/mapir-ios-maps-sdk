// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "MapirMapKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "MapirMapKit",
            targets: ["MapirMapKit"]),
    ],
    dependencies: [
         .package(url: "https://github.com/mapbox/mapbox-maps-ios.git", from: "10.7.0"),
    ],
    targets: [
        .target(
            name: "MapirMapKit",
            dependencies: [
                .product(name: "MapboxMaps", package: "mapbox-maps-ios")
            ]),
        .testTarget(
            name: "MapirMapKitTests",
            dependencies: ["MapirMapKit"]),
    ]
)
