// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ImmersionKit",
    platforms: [
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .macOS(.v15)
    ],
    products: [
        .library(name: "ImmersionKit", targets: ["ImmersionKit"])
    ],
    targets: [
        .binaryTarget(
            name: "ImmersionKit",
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.105/ImmersionKit.xcframework.zip",
            checksum: "65fb54b28b210564f59c5a960b4368d34ac3b14958ec64f61dccb6adecf77c76"
        )
    ]
)
