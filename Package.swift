// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImmersionKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "ImmersionKit", targets: ["ImmersionKit"])
    ],
    targets: [
        .binaryTarget(
            name: "ImmersionKit",
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.2/ImmersionKit.xcframework.zip",
            checksum: "4793ff8ce4daf96d28496e30c49b58656c1170366abffae74141b2fcc6e0edf4"
        )
    ]
)
