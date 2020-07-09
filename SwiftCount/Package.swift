// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftCount",
  products: [
    .executable(name: "swiftcount", targets: ["SwiftCount"]),
  ],
  targets: [
    .target(
      name: "SwiftCount",
      dependencies: ["SwiftCountCore"]),
    .target(
      name: "SwiftCountCore"),
    .testTarget(
      name: "SwiftCountCoreTests",
      dependencies: ["SwiftCountCore"]),
  ]
)
