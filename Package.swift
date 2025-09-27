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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.77/ImmersionKit.xcframework.zip",
            checksum: "a36cd522746428ef6ba8697640658f75f24111bfd5b1dc6e8c5d586e081b5e70"
        )
    ]
)
