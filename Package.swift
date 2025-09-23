// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "ImmersionKit",
  platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10)],
  products: [.library(name: "ImmersionKit", targets: ["ImmersionKit"])],
  targets: [
    // Placeholder; will be overwritten by the private workflow on next tag.
    .binaryTarget(
      name: "ImmersionKit",
      url: "https://github.com/ImmersionNeuro/ImmersionKit/releases/download/v0.0.0/ImmersionKit.xcframework.zip",
      checksum: "0000000000000000000000000000000000000000000000000000000000000000"
    )
  ]
)
