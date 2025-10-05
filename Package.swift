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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.95/ImmersionKit.xcframework.zip",
            checksum: "00ac558efa914a2e54b62700ae8ef3f7a6c26493d55ef650bb4e3b0d4ada87c9"
        )
    ]
)
