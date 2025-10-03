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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.94/ImmersionKit.xcframework.zip",
            checksum: "c3419e48f204374c3a4307a39a23867d919d6a76c746e4ded07f0d8e8ebe6cd8"
        )
    ]
)
