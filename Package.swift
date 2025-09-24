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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.57/ImmersionKit.xcframework.zip",
            checksum: "17d4e68de44bf7df13602ff502646a4078e92d4f0f8233c34d81e0565cd8227f"
        )
    ]
)
