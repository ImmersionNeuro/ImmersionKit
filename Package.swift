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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.113/ImmersionKit.xcframework.zip",
            checksum: "4d1f4c002468e6650427774f3ae5d6e98e337c32652b925cec0e32e3ee82ab5a"
        )
    ]
)
