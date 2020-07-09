// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftCount",
  products: [
    .executable(name: "swiftcount", targets: ["SwiftCount"]),
  ],
  dependencies: [
    .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50200.0")),
  ],
  targets: [
    .target(
      name: "SwiftCount",
      dependencies: ["SwiftCountCore"]),
    .target(
      name: "SwiftCountCore",
      dependencies: ["SwiftSyntax"]),
    .testTarget(
      name: "SwiftCountCoreTests",
      dependencies: ["SwiftCountCore"]),
  ]
)
