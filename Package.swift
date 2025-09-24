// swift-tools-version: 5.9
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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.52/ImmersionKit.xcframework.zip",
            checksum: "e93d44b2bde3ffe5d176a4cfceaa0c64c237497ab903bd21d138f156c5e5ef2c"
        )
    ]
)
