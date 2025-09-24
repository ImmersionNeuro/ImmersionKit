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
            url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.50/ImmersionKit.xcframework.zip",
            checksum: "400f7060b041a5250cd12992411bb0735a788ec344d8d9295e2e21aba3531e2f"
        )
    ]
)
