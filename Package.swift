// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImmersionKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
    	.macOS(.v14),
    	.tvOS(.v17),
    	.watchOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ImmersionKit",
            targets: ["ImmersionKit"]),
    ],
    dependencies: [
        // Add external packages here as needed, e.g.:
        // .package(url: "https://github.com/apple/swift-log", from: "1.5.0")
	.package(
            url: "https://github.com/influxdata/influxdb-client-swift.git",
            from: "1.7.0" // adjust to latest stable
        ),
    .package(url: "https://github.com/apple/swift-log.git", exact: "1.6.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ImmersionKit",
            dependencies: [
                .product(
                    name: "InfluxDBSwift",
                    package: "influxdb-client-swift",
                    condition: .when(platforms: [.iOS, .macOS, .tvOS])
                ),
                .product(
                    name: "InfluxDBSwiftApis",
                    package: "influxdb-client-swift",
                    condition: .when(platforms: [.iOS, .macOS, .tvOS])
                ),
                .product(name: "Logging", package: "swift-log",
                                         condition: .when(platforms: [.iOS, .macOS, .tvOS]))
            ],
            resources: [
                // .process("Resources") // If you add bundled assets later
            ],
            swiftSettings: [
                // .define("IMK_FEATURE_X"), // Example feature flags
            ]
        ),
        .testTarget(
            name: "ImmersionKitTests",
            dependencies: ["ImmersionKit"]
        ),
    ]
)
